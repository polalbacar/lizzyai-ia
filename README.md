# 🎤 LizzyAI Interview Analysis System

**AI-Powered Interview Evaluation Platform** - Complete monorepo with React frontend and FastAPI backend.

## 🏗️ Architecture Overview

```
lizzyai-ia/
├── 🚀 docker-compose.yml           # Production setup
├── 🛠️ docker-compose.dev.yml       # Development with hot reload  
├── 📜 run.sh                       # Management script
├── 🚫 .dockerignore               # Docker ignore rules
├── 📚 README.md                   # This file
├── 🐍 lizzyai-interview-analysis-backend/
│   ├── 📦 Dockerfile              # Backend container
│   ├── 🔧 dev.sh                  # Backend dev script
│   └── ... (FastAPI application)
└── ⚛️ lizzyai-interview-analysis-frontend/
    ├── 📦 Dockerfile              # Frontend production (nginx)
    ├── 🔧 Dockerfile.dev          # Frontend development (vite)
    ├── 🌐 nginx.conf              # Nginx configuration
    └── ... (React application)
```

## ⚡ Quick Start

### 1. **Setup Environment**
```bash
# Copy environment template
cp lizzyai-interview-analysis-backend/env.example .env

# Edit .env and add your OpenAI API key
OPENAI_API_KEY=your_openai_api_key_here
```

### 2. **Production Deployment**
```bash
# Start production environment (nginx + optimized builds)
./run.sh start

# 🌐 Access the application
# Frontend: http://localhost
# API: http://localhost/api/v1/health
# Docs: http://localhost/docs
```

### 3. **Development Mode**
```bash
# Start with hot reload (vite dev server + uvicorn reload)
./run.sh dev

# 🔥 Development URLs
# Frontend: http://localhost:8080 (hot reload)
# Backend: http://localhost:8000 (auto reload)
# API Docs: http://localhost:8000/docs
```

## 🐳 Docker Architecture

### **Production Setup**
- **Frontend**: React app built and served by **nginx** (port 80)
- **Backend**: FastAPI with **uvicorn** (internal port 8000)
- **Networking**: nginx proxies `/api/*` requests to backend
- **Optimization**: Multi-stage builds, static asset caching, gzip compression

### **Development Setup**
- **Frontend**: **Vite dev server** with hot module replacement (port 8080)
- **Backend**: **uvicorn** with auto-reload (port 8000)
- **Volume mounting**: Source code mounted for instant updates
- **No rebuilds**: Code changes reflect immediately

## 🎛️ Management Commands

```bash
# Production
./run.sh start        # Start production environment
./run.sh stop         # Stop production environment  
./run.sh logs         # View production logs

# Development
./run.sh dev          # Start development with hot reload
./run.sh dev-stop     # Stop development environment
./run.sh dev-logs     # View development logs

# Utilities
./run.sh status       # Show container status
./run.sh test         # Test API endpoints
./run.sh clean        # Clean unused Docker resources
./run.sh help         # Show all commands
```

## 🔧 Individual Service Development

### **Backend Only** (FastAPI)
```bash
cd lizzyai-interview-analysis-backend
./dev.sh start        # Backend with hot reload on port 8000
```

### **Frontend Only** (React)
```bash
cd lizzyai-interview-analysis-frontend
npm install
npm run dev           # Frontend dev server on port 8080
```

## 🌐 API Integration

The frontend automatically connects to the backend through:

**Production**: nginx proxy (`/api/*` → `backend:8000`)
```nginx
location /api/ {
    proxy_pass http://lizzyai-backend:8000;
}
```

**Development**: Direct connection via `VITE_API_URL`
```typescript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';
```

## 📋 Environment Variables

Create `.env` in the root directory:

```bash
# Required
OPENAI_API_KEY=your_openai_api_key_here

# Optional (with defaults)
BACKEND_PORT=8000
BACKEND_HOST=0.0.0.0
BACKEND_ENVIRONMENT=production
FRONTEND_PORT=80
MAX_FILE_SIZE_MB=100
```

## 🔄 CI/CD Ready

The setup is optimized for deployment:

- **Docker Compose**: Production-ready orchestration
- **Multi-stage builds**: Optimized image sizes
- **Health checks**: Automatic service monitoring
- **Dependency management**: Services start in correct order
- **Volume persistence**: Data survives container restarts

## 🚀 Deployment Options

### **1. Local Production**
```bash
./run.sh start
```

### **2. Cloud Deployment** 
```bash
# Push to your registry
docker-compose build
docker tag lizzyai-ia_lizzyai-frontend your-registry/lizzyai-frontend
docker tag lizzyai-ia_lizzyai-backend your-registry/lizzyai-backend

# Deploy to your cloud provider
docker-compose up -d
```

### **3. Kubernetes**
Convert docker-compose to k8s manifests using tools like Kompose.

## 📊 System Requirements

- **Docker**: 20.10+
- **Docker Compose**: 2.0+
- **Memory**: 2GB+ recommended
- **Storage**: 5GB for images and dependencies

## 🔍 Troubleshooting

### **Port Conflicts**
```bash
# Check what's using ports
lsof -i :80 -i :8000 -i :8080

# Stop conflicting services
sudo systemctl stop nginx  # if nginx is running
```

### **OpenAI API Issues**
```bash
# Test your API key
curl -H "Authorization: Bearer your_key" https://api.openai.com/v1/models

# Check backend logs
./run.sh logs
```

### **Build Failures**
```bash
# Clean Docker cache
./run.sh clean

# Force rebuild
docker-compose build --no-cache
```

### **File Upload Issues**
```bash
# Ensure temp directory exists
mkdir -p lizzyai-interview-analysis-backend/temp

# Check file permissions
ls -la lizzyai-interview-analysis-backend/temp
```

## 🛡️ Security Features

- **nginx security headers**: XSS protection, CSRF prevention
- **Docker non-root users**: Services don't run as root
- **Environment isolation**: Secrets only in environment variables
- **CORS configuration**: Controlled cross-origin access
- **API rate limiting**: Built into FastAPI backend

## 📈 Performance Optimizations

- **Frontend**: Static asset caching, gzip compression, tree shaking
- **Backend**: Async FastAPI, connection pooling, response caching
- **Docker**: Multi-stage builds, layer caching, minimal base images
- **Development**: Hot reload, incremental compilation

## 🤝 Contributing

1. **Development setup**: `./run.sh dev`
2. **Make changes**: Edit source code (auto-reloads)
3. **Test**: `./run.sh test`
4. **Production test**: `./run.sh start`

## 📝 License

This project is part of the LizzyAI interview analysis platform.

---

**🎯 Ready to process interviews with AI!** 

Start with `./run.sh dev` for development or `./run.sh start` for production. 