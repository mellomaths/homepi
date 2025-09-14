# Check if folder exists
if [ -d "health-check-api" ]; then
    echo "Repository folder exists, pulling latest changes..."
    cd health-check-api
    git pull
    cd ..
else
    echo "Repository folder does not exist, cloning..."
    gh repo clone mellomaths/health-check-api
fi
