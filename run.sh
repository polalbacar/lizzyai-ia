#!/bin/bash

# LizzyAI Interview Analysis System - Docker Management Script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Function to check if .env file exists
check_env_file() {
    if [ ! -f ".env" ]; then
        print_warning ".env file not found!"
        echo ""
        echo "Create a .env file with the following variables:"
        echo "OPENAI_API_KEY=your_openai_api_key_here"
        echo ""
        print_warning "You can copy from the backend example:"
        echo "cp lizzyai-interview-analysis-backend/env.example .env"
        echo ""
        exit 1
    else
        print_status ".env file found ✓"
    fi
}

# Function to ensure temp directory exists
ensure_temp_dir() {
    if [ ! -d "lizzyai-interview-analysis-backend/temp" ]; then
        print_status "Creating temp directory..."
        mkdir -p lizzyai-interview-analysis-backend/temp
    fi
}

# Production commands
start_prod() {
    print_header "Starting LizzyAI Production Environment"
    check_env_file
    ensure_temp_dir
    
    print_status "Building and starting production containers..."
    docker-compose up --build -d
    
    print_status "🚀 LizzyAI is running!"
    echo ""
    echo "Frontend: http://localhost"
    echo "Backend API: http://localhost/api/v1/health"
    echo "API Docs: http://localhost/api/v1/docs"
}

stop_prod() {
    print_header "Stopping LizzyAI Production Environment"
    docker-compose down
}

# Development commands
start_dev() {
    print_header "Starting LizzyAI Development Environment"
    check_env_file
    ensure_temp_dir
    
    print_status "Building and starting development containers with hot reload..."
    docker-compose -f docker-compose.dev.yml up --build
}

stop_dev() {
    print_header "Stopping LizzyAI Development Environment"
    docker-compose -f docker-compose.dev.yml down
}

# Utility commands
logs_prod() {
    print_header "Production Logs"
    docker-compose logs -f
}

logs_dev() {
    print_header "Development Logs"
    docker-compose -f docker-compose.dev.yml logs -f
}

status() {
    print_header "LizzyAI System Status"
    echo "Production containers:"
    docker-compose ps
    echo ""
    echo "Development containers:"
    docker-compose -f docker-compose.dev.yml ps
}

clean() {
    print_header "Cleaning Docker Resources"
    print_status "Stopping all containers..."
    docker-compose down 2>/dev/null || true
    docker-compose -f docker-compose.dev.yml down 2>/dev/null || true
    
    print_status "Removing unused images..."
    docker image prune -f
    
    print_status "Cleanup completed!"
}

# Test API
test_api() {
    print_header "Testing LizzyAI API"
    
    # Test production (port 80)
    if curl -s -f http://localhost/api/v1/health > /dev/null 2>&1; then
        print_status "✓ Production API is responding"
        curl -s http://localhost/api/v1/health | python -m json.tool 2>/dev/null || curl -s http://localhost/api/v1/health
    else
        print_warning "✗ Production API not responding"
    fi
    
    echo ""
    
    # Test development (port 8000)
    if curl -s -f http://localhost:8000/api/v1/health > /dev/null 2>&1; then
        print_status "✓ Development API is responding"
        curl -s http://localhost:8000/api/v1/health | python -m json.tool 2>/dev/null || curl -s http://localhost:8000/api/v1/health
    else
        print_warning "✗ Development API not responding"
    fi
}

# Help function
show_help() {
    print_header "LizzyAI Interview Analysis System"
    echo ""
    echo "Usage: ./run.sh <command>"
    echo ""
    echo "Production Commands:"
    echo "  start         Start production environment (nginx + uvicorn)"
    echo "  stop          Stop production environment"
    echo "  logs          View production logs"
    echo ""
    echo "Development Commands:"
    echo "  dev           Start development environment with hot reload"
    echo "  dev-stop      Stop development environment"
    echo "  dev-logs      View development logs"
    echo ""
    echo "Utility Commands:"
    echo "  status        Show container status"
    echo "  test          Test API endpoints"
    echo "  clean         Clean unused Docker resources"
    echo "  help          Show this help message"
    echo ""
    echo "URLs:"
    echo "  Production:   http://localhost (frontend + backend)"
    echo "  Development:  http://localhost:8080 (frontend), http://localhost:8000 (backend)"
    echo "  API Docs:     http://localhost/docs (prod) or http://localhost:8000/docs (dev)"
}

# Main script logic
case "${1:-help}" in
    start)
        start_prod
        ;;
    stop)
        stop_prod
        ;;
    logs)
        logs_prod
        ;;
    dev)
        start_dev
        ;;
    dev-stop)
        stop_dev
        ;;
    dev-logs)
        logs_dev
        ;;
    status)
        status
        ;;
    test)
        test_api
        ;;
    clean)
        clean
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