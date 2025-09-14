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
echo -e "Applications found: ${BLUE}$(ls -d */ | tr -d '/')${NC}"
echo ""

# Counter for tracking deployments
deployed_count=0
failed_count=0
skipped_count=0

# Find all subdirectories and process them
# Get list of directories first
dirs=($(find . -maxdepth 1 -type d -not -name "." -exec basename {} \;))

echo -e "${BLUE}Debug: Found directories: ${dirs[*]}${NC}"

# Process each directory
for dir_name in "${dirs[@]}"; do
    # Skip hidden directories
    if [[ "$dir_name" =~ ^\..* ]]; then
        continue
    fi
    
    echo -e "${YELLOW}📁 Processing application: $dir_name${NC}"
    
    # Check if deploy.sh exists in the subdirectory
    if [[ -f "$dir_name/deploy.sh" ]]; then
        echo -e "  ${BLUE}Found deploy.sh, running deployment...${NC}"
        echo -e "  ${BLUE}Running: $dir_name/deploy.sh${NC}"
        
        # Make sure deploy.sh is executable
        chmod +x "$dir_name/deploy.sh"
        
        # Change to the subdirectory and run deploy.sh
        if (cd "$dir_name" && ./deploy.sh); then
            echo -e "  ${GREEN}✅ Successfully deployed $dir_name${NC}"
            ((deployed_count++))
        else
            echo -e "  ${RED}❌ Failed to deploy $dir_name${NC}"
            ((failed_count++))
        fi
    else
        echo -e "  ${YELLOW}⚠️  No deploy.sh found in $dir_name, skipping...${NC}"
        ((skipped_count++))
    fi
    
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
