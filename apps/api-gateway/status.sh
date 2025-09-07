check_container() {
    local container_name="$1"
    echo "Checking status of $container_name..."
    # Check if running
    if docker ps --filter "name=$container_name" --filter "status=running" --format "{{.Names}}" | grep -q "$container_name"; then
        echo "✅ $container_name is running"
        
        # Get status details
        local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}")
        echo "Status: $status"
        
        # Check health if available
        local health=$(docker inspect --format='{{.State.Health.Status}}' "$container_name" 2>/dev/null)
        if [ "$health" = "healthy" ]; then
            echo "✅ Healthy"
        elif [ "$health" = "unhealthy" ]; then
            echo "❌ Unhealthy"
        elif [ "$health" = "starting" ]; then
            echo "⚠️ Starting"
        else
            echo "⚠️ No health check configured"
        fi
        
        return 0
    else
        echo "❌ $container_name is not running"
        return 1
    fi
}

check_api_is_up() {
    local api_name="$1"
    local api_url="$2"
    status_code=$(curl -s -o /dev/null -w "%{http_code}" $api_url)
    if [ $status_code -eq 200 ]; then
        echo "✅ $api_name is up and running"
    else
        echo "❌ $api_name is down"
    fi
}

echo "Checking status of API Gateway..."
echo "================================================"
echo "Health Check API:"
check_container "health-check-api"
check_api_is_up "Health Check API" "http://localhost:3001/up"
echo "================================================"
