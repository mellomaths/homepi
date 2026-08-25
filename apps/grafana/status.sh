#!/bin/bash

check_container() {
    local container_name="$1"
    echo "Checking status of $container_name..."
    if docker ps --filter "name=^${container_name}$" --filter "status=running" --format "{{.Names}}" | grep -q "^${container_name}$"; then
        echo "✅ $container_name is running"

        local status
        status=$(docker ps --filter "name=^${container_name}$" --format "{{.Status}}")
        echo "Status: $status"

        local health
        health=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$container_name" 2>/dev/null)
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

check_http_is_up() {
    local name="$1"
    local url="$2"
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$status_code" -eq 200 ]; then
        echo "✅ $name is up and running"
    else
        echo "❌ $name is down (HTTP $status_code)"
    fi
}

echo "Checking status of Grafana stack..."
echo "================================================"
check_container "grafana"
check_container "loki"
check_container "prometheus"
check_container "alloy"
echo "================================================"
check_http_is_up "Grafana" "http://localhost:3000/api/health"
check_http_is_up "Prometheus" "http://localhost:3003/-/healthy"
echo "================================================"
