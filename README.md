# 🎤 LizzyAI Interview Analysis System

**AI-Powered Interview Evaluation Platform**

LizzyAI is an intelligent recruitment tool that automates the evaluation of job interviews using advanced AI. The system transcribes candidate interviews, analyzes responses, and provides comprehensive fraud detection and scoring to help recruiters make informed hiring decisions.

## ✨ What LizzyAI Does

- **🎵 Audio Transcription**: Converts interview recordings to text using OpenAI Whisper
- **🤖 Intelligent Analysis**: Segments interviews into question-answer pairs using GPT-4  
- **🔍 Fraud Detection**: Analyzes answers for signs of cheating, external help, or scripted responses
- **📊 Comprehensive Scoring**: Provides detailed insights and fraud risk scores for each answer
- **📋 Interview Reports**: Generates complete evaluation reports with candidate details and recommendations

## 🏗️ Architecture

This repository uses a **monorepo structure with Git submodules** containing two separate applications:

```
lizzyai-ia/                           # Main repository
├── 📦 docker-compose.yml             # Production orchestration
├── 🛠️ docker-compose.dev.yml         # Development setup
├── 📜 run.sh                         # Management script
├── 🔧 sync-submodules.sh             # Submodule sync utility
├── 📚 README.md                      # This file
├── 🐍 lizzyai-interview-analysis-backend/     # Git submodule
│   ├── FastAPI application
│   ├── OpenAI Whisper integration
│   ├── GPT-4 analysis engine
│   └── RESTful API endpoints
└── ⚛️ lizzyai-interview-analysis-frontend/    # Git submodule
    ├── React + TypeScript UI
    ├── Modern responsive design
    ├── File upload interface
    └── Results visualization
```

### 🔗 Submodule Architecture

- **Backend Submodule**: [`lizzyai-interview-analysis-backend`](https://github.com/polalbacar/lizzyai-interview-analysis-backend) - FastAPI server handling AI processing
- **Frontend Submodule**: [`lizzyai-interview-analysis-frontend`](https://github.com/polalbacar/lizzyai-interview-analysis-frontend) - React application for user interaction
- **Main Repository**: Orchestrates both services using Docker Compose for seamless deployment

## 🚀 Quick Start

### Prerequisites
- **Git** (with submodule support)
- **Docker** & **Docker Compose**
- **OpenAI API Key** (for Whisper and GPT-4 access)

### Setup Instructions

1. **Clone the repository with submodules**:
   ```bash
   git clone --recursive https://github.com/polalbacar/lizzyai-ia.git
   cd lizzyai-ia
   ```
   
   > **Note**: If you already cloned without `--recursive`, run:
   > ```bash
   > git submodule update --init --recursive
   > ```

2. **Set up environment variables**:
   ```bash
   # Copy the example environment file
   cp lizzyai-interview-analysis-backend/env.example .env
   
   # Edit .env and add your OpenAI API key
   echo "OPENAI_API_KEY=your_openai_api_key_here" >> .env
   ```

3. **Launch the application**:
   ```bash
   docker-compose up --build
   ```

4. **Access the application**:
   - **Frontend**: http://localhost (Main interview interface)
   - **API Documentation**: http://localhost/docs (Swagger UI)
   - **Health Check**: http://localhost/api/v1/health

That's it! 🎉 The complete system is now running and ready to process interviews.

## 🎛️ Development Mode

For development with hot reload:

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up --build

# Development URLs:
# Frontend: http://localhost:8080 (Vite dev server)
# Backend: http://localhost:8000 (FastAPI with auto-reload)
```

## 📋 How It Works

1. **Upload**: Users upload audio files through the web interface
2. **Transcription**: OpenAI Whisper converts speech to text
3. **Segmentation**: GPT-4 identifies individual Q&A pairs
4. **Analysis**: Each answer is analyzed for fraud indicators:
   - Reading aloud from external sources
   - External help or coaching
   - Pre-scripted responses
   - Confidence and authenticity levels
5. **Scoring**: Comprehensive fraud risk scores (0-100) with detailed insights
6. **Results**: Complete interview report with recommendations

## 🔧 Advanced Usage

### Using the Management Script
```bash
# Production
./run.sh start        # Start production environment
./run.sh stop         # Stop all services
./run.sh logs         # View application logs

# Development  
./run.sh dev          # Start with hot reload
./run.sh dev-stop     # Stop development environment

# Utilities
./run.sh status       # Show container status
./run.sh clean        # Clean Docker resources
```

### Updating Submodules
```bash
# Sync submodules with latest changes
./sync-submodules.sh
```

## 📊 Supported Audio Formats

- **MP3** (`.mp3`)
- **WAV** (`.wav`) 
- **M4A** (`.m4a`)
- **MP4** (`.mp4`)
- **WebM** (`.webm`)
- **MPEG** (`.mpeg`, `.mpga`)

**Maximum file size**: 100MB

## 🔐 Environment Configuration

Required environment variables in `.env`:

```bash
# Required
OPENAI_API_KEY=your_openai_api_key_here

# Optional (with defaults)
BACKEND_PORT=8000
BACKEND_HOST=0.0.0.0
BACKEND_ENVIRONMENT=production
FRONTEND_PORT=80
MAX_FILE_SIZE_MB=100
LOG_LEVEL=INFO
```

## 🛠️ System Requirements

- **Docker**: 20.10+
- **Docker Compose**: 2.0+
- **Memory**: 2GB+ recommended
- **Storage**: 5GB for images and dependencies
- **Network**: Internet access for OpenAI API calls

## 🔍 Troubleshooting

### Port Conflicts
```bash
# Check what's using ports 80, 8000, 8080
lsof -i :80 -i :8000 -i :8080

# Stop conflicting services if needed
sudo systemctl stop nginx
```

### OpenAI API Issues
```bash
# Verify your API key works
curl -H "Authorization: Bearer your_key" https://api.openai.com/v1/models

# Check application logs
docker-compose logs lizzyai-backend
```

### Submodule Issues
```bash
# Reset submodules if they get out of sync
git submodule foreach git reset --hard HEAD
git submodule update --init --recursive
```

## 🤝 Contributing

1. **Fork** the main repository and both submodule repositories
2. **Clone** your fork with submodules: `git clone --recursive <your-fork-url>`
3. **Develop** using `docker-compose -f docker-compose.dev.yml up --build`
4. **Test** your changes thoroughly
5. **Submit** pull requests to the respective repositories

## 📜 License

This project is part of the LizzyAI interview analysis platform.

---

**🎯 Ready to revolutionize interview evaluation with AI!**

Get started in minutes: clone, add your OpenAI key, and run `docker-compose up --build` 