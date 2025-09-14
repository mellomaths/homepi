# Check if folder exists
if [ -d "football-fan-api" ]; then
    echo "Repository folder exists, pulling latest changes..."
    cd football-fan-api
    git pull
    cd ..
else
    echo "Repository folder does not exist, cloning..."
    gh repo clone mellomaths/football-fan-api
fi
