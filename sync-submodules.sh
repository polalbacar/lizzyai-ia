#!/bin/bash

# LizzyAI Submodule Sync Script
# Helps keep parent repo in sync with submodule changes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to update submodules to latest
update_submodules() {
    print_header "Updating Submodules to Latest"
    
    print_status "Fetching latest changes from submodules..."
    git submodule update --remote --merge
    
    print_status "Current submodule status:"
    git submodule status
    
    # Check if there are changes to commit
    if [[ -n $(git status --porcelain) ]]; then
        print_status "Found submodule updates. Committing changes..."
        git add .
        git commit -m "Update submodules to latest commits

Backend: $(cd lizzyai-interview-analysis-backend && git log --oneline -1)
Frontend: $(cd lizzyai-interview-analysis-frontend && git log --oneline -1)"
        
        print_status "✅ Parent repo updated with latest submodule changes"
        print_warning "Don't forget to push: git push"
    else
        print_status "✅ Submodules are already up to date"
    fi
}

# Function to show submodule status
show_status() {
    print_header "Submodule Status"
    
    echo "Parent repo status:"
    git status --short
    echo ""
    
    echo "Submodule commits:"
    git submodule status
    echo ""
    
    echo "Backend latest commit:"
    cd lizzyai-interview-analysis-backend
    git log --oneline -1
    cd ..
    echo ""
    
    echo "Frontend latest commit:"
    cd lizzyai-interview-analysis-frontend
    git log --oneline -1
    cd ..
    echo ""
}

# Function to sync all - update submodules and push
sync_all() {
    print_header "Full Sync - Update Submodules and Push"
    
    update_submodules
    
    if [[ -n $(git log origin/main..HEAD) ]]; then
        print_status "Pushing changes to remote..."
        git push
        print_status "🚀 All changes synced!"
    else
        print_status "✅ Already in sync with remote"
    fi
}

# Function to develop workflow
develop_workflow() {
    print_header "Development Workflow Guide"
    echo ""
    echo "1. Make changes in backend or frontend:"
    echo "   cd lizzyai-interview-analysis-backend"
    echo "   # ... make changes ..."
    echo "   git add . && git commit -m 'Your changes' && git push"
    echo ""
    echo "2. Update parent repo to use latest:"
    echo "   cd ../  # back to lizzyai-ia"
    echo "   ./sync-submodules.sh update"
    echo ""
    echo "3. Push parent repo changes:"
    echo "   git push"
    echo ""
    echo "Or use: ./sync-submodules.sh sync  # Does steps 2-3 automatically"
}

# Function to show help
show_help() {
    print_header "LizzyAI Submodule Management"
    echo ""
    echo "Usage: ./sync-submodules.sh <command>"
    echo ""
    echo "Commands:"
    echo "  update     Update submodules to latest commits"
    echo "  status     Show current submodule status"
    echo "  sync       Update submodules and push (full sync)"
    echo "  workflow   Show development workflow guide"
    echo "  help       Show this help message"
    echo ""
    echo "Typical workflow:"
    echo "  1. Work in backend/frontend repos and push changes"
    echo "  2. Run: ./sync-submodules.sh sync"
    echo "  3. Parent repo now tracks latest submodule commits"
}

# Main script logic
case "${1:-help}" in
    update)
        update_submodules
        ;;
    status)
        show_status
        ;;
    sync)
        sync_all
        ;;
    workflow)
        develop_workflow
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac 