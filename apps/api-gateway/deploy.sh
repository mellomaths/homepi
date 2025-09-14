#!/bin/bash

# API Gateway Deployment Script
# This script runs ./deploy.sh in every subdirectory of the api-gateway folder

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}🚀 Starting API Gateway deployment...${NC}"
echo ""

# Counter for tracking deployments
deployed_count=0
failed_count=0
skipped_count=0

# List of apps to deploy
apps=(mellomaths/health-check-api mellomaths/football-fan-api)

# Process each directory
for app in "${apps[@]}"
do    
    echo -e "${YELLOW}📁 Processing application: $app${NC}"

    # Check if app directory exists
    if [[ -d "$app" ]]; then
        echo -e "  ${BLUE}Found $app directory, running deployment...${NC}"
        # Runs git pull in the app directory
        echo -e "  ${BLUE}Running: git pull in $app directory${NC}"
        (cd "$app" && git pull)
    else
        echo -e "  ${RED}❌ $app directory does not exist, skipping...${NC}"
        # Runs gh repo clone in the app directory
        echo -e "  ${BLUE}Running: gh repo clone $app in $app directory${NC}"
        (cd "$app" && gh repo clone $app $app)
    fi

    # Runs docker compose up --build -d in the app directory
    echo -e "  ${BLUE}Running: docker compose up --build -d in $app directory${NC}"
    (cd "$app" && docker compose up --build -d)
    echo -e "  ${GREEN}✅ Successfully deployed $app${NC}"
    ((deployed_count++))
    echo ""
done

# Print summary
echo -e "${BLUE}📊 Deployment Summary:${NC}"
echo -e "  ${GREEN}✅ Successfully deployed: $deployed_count${NC}"
echo -e "  ${RED}❌ Failed deployments: $failed_count${NC}"
echo -e "  ${YELLOW}⚠️  Skipped directories: $skipped_count${NC}"

# Exit with error code if any deployments failed
if [[ $failed_count -gt 0 ]]; then
    echo -e "${RED}💥 Some deployments failed!${NC}"
    exit 1
else
    echo -e "${GREEN}🎉 All deployments completed successfully!${NC}"
    exit 0
fi
