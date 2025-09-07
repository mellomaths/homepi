# Docker :: Health check API
docker ps | grep health-check-api
if [ $? -eq 0 ]; then
    echo "✅ Docker :: Health check API is running"
else
    echo "❌ Docker :: Health check API is not running"
fi

# Check if Health Check API is up and running
curl -X GET http://localhost:3001/up
if [ $? -eq 0 ]; then
    echo "✅ Health Check API is up and running"
else
    echo "❌ Health Check API is not up and running"
fi

