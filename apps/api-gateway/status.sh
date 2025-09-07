# Docker :: Health check API
docker ps | grep health-check-api
if [ $? -eq 0 ]; then
    echo "✅ (Health Check API) Docker container is running"
else
    echo "❌ (Health Check API) Docker container is down"
fi

# Check if Health Check API is up and running
# This will check if the /up endpoint returns a 200 status code
status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3001/up)
if [ $status_code -eq 200 ]; then
    echo "✅ (Health Check API) Application is up and running"
else
    echo "❌ (Health Check API) Application is down"
fi

