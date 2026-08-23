#!/bin/bash

# API Gateway Deployment Script
# This script runs ./deploy.sh in every subdirectory of the api-gateway folder

# Per-app errors are handled in the loop (failed_count / deployed_count).
# Do not use set -e here or the script would exit before updating counters.

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

# DEPLOY_MODE=build (default): fresh clone + docker compose up --build -d
# DEPLOY_MODE=registry: git pull or clone, then docker compose pull && up -d (images from your registry)
DEPLOY_MODE="${DEPLOY_MODE:-build}"
echo -e "${BLUE}Mode: ${DEPLOY_MODE}${NC}"
echo ""

# Counter for tracking deployments
deployed_count=0
failed_count=0
skipped_count=0

# List of apps to deploy
apps=(mellomaths/health-check-api mellomaths/football-fan-api)

# Get directory name from repository name
function get_dir_name {
    echo "$1" | sed 's/.*\///'
}

# Process each directory
for app in "${apps[@]}"; do
    echo -e "${YELLOW}📁 Processing application: $app${NC}"
    dir_name=$(get_dir_name "$app")
    echo -e "  ${BLUE}Directory name: $dir_name${NC}"

    app_ok=1

    if [[ "$DEPLOY_MODE" == "registry" ]]; then
        if [[ -d "$dir_name" ]]; then
            echo -e "  ${BLUE}Running: git pull in $dir_name${NC}"
            (cd "$dir_name" && git pull) || app_ok=0
        else
            echo -e "  ${BLUE}Running: gh repo clone $app in $dir_name directory${NC}"
            gh repo clone "$app" || app_ok=0
        fi
        if [[ "$app_ok" -eq 1 ]]; then
            echo -e "  ${BLUE}Running: docker compose pull && docker compose up -d in $dir_name directory${NC}"
            (cd "$dir_name" && docker compose pull && docker compose up -d) || app_ok=0
        fi
    else
        if [[ -d "$dir_name" ]]; then
            echo -e "  ${YELLOW}⚠️ Found $app directory, removing...${NC}"
            rm -rf "$dir_name" || app_ok=0
        fi
        if [[ "$app_ok" -eq 1 ]]; then
            echo -e "  ${BLUE}Running: gh repo clone $app in $dir_name directory${NC}"
            gh repo clone "$app" || app_ok=0
        fi
        if [[ "$app_ok" -eq 1 ]]; then
            echo -e "  ${BLUE}Running: docker compose up --build -d in $dir_name directory${NC}"
            (cd "$dir_name" && docker compose up --build -d) || app_ok=0
        fi
    fi

    if [[ "$app_ok" -eq 1 ]]; then
        echo -e "  ${GREEN}✅ Successfully deployed $app${NC}"
        deployed_count=$((deployed_count + 1))
    else
        echo -e "  ${RED}❌ Failed to deploy $app${NC}"
        failed_count=$((failed_count + 1))
    fi
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
