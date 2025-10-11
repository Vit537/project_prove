# Quick Setup Instructions

## 🚀 Complete Setup for GitHub + Google Cloud Deployment

### Prerequisites Check
✅ Docker installed (v28.3.3)  
✅ Docker Compose available (v2.39.2)  
❌ Git needs to be installed  
❌ Docker Desktop needs to be started  

### Step 1: Install Missing Tools

#### Install Git for Windows
1. Download from: https://git-scm.com/download/win
2. Install with default settings
3. Restart VS Code terminal after installation

#### Start Docker Desktop
1. Open Docker Desktop application
2. Wait for it to fully start (whale icon in system tray should be steady)
3. You should see "Docker Desktop is running" notification

### Step 2: Initialize Git Repository

```powershell
# After installing Git, run these commands:
cd "d:\All 02-2025\DjangoProject\myProject"
git init
git add .
git commit -m "Initial commit: Django + React + PostgreSQL project with Google Cloud deployment"
```

### Step 3: Test Local Docker Setup

```powershell
# After starting Docker Desktop:
docker compose build
docker compose up
```

Test URLs:
- Frontend: http://localhost:3000
- Backend: http://localhost:8000
- Backend Admin: http://localhost:8000/admin

### Step 4: Create GitHub Repository

#### Option A: With GitHub CLI (Recommended)
```powershell
# Install GitHub CLI first: https://cli.github.com/
gh auth login
gh repo create my-django-react-app --public --source . --remote origin --push
```

#### Option B: Manual Setup
1. Go to https://github.com/new
2. Repository name: `my-django-react-app`
3. Make it Public (or Private if preferred)
4. Don't initialize with README
5. Create repository
6. Run these commands:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/my-django-react-app.git
git branch -M main  
git push -u origin main
```

### Step 5: Setup Google Cloud Project

```powershell
# Install Google Cloud CLI: https://cloud.google.com/sdk/docs/install-sdk

# Initialize and login
gcloud init
gcloud auth login

# Create project (choose unique project ID)
gcloud projects create my-django-project-12345
gcloud config set project my-django-project-12345

# Enable billing in Google Cloud Console
# Go to: https://console.cloud.google.com/billing
```

### Step 6: Configure GitHub Secrets

After creating GitHub repository, go to:
**Repository → Settings → Secrets and variables → Actions**

Add these secrets:
- `GCP_PROJECT_ID`: Your project ID
- `GCP_SA_KEY`: Service account JSON key
- `DJANGO_SECRET_KEY`: Production Django secret
- `DATABASE_URL`: PostgreSQL connection string
- `CLOUD_SQL_CONNECTION_NAME`: Cloud SQL instance name
- `FRONTEND_BUCKET`: Storage bucket name

### Step 7: Deploy

Once everything is set up:
```powershell
git add .
git commit -m "Ready for deployment"
git push origin main
```

GitHub Actions will automatically deploy to Google Cloud!

## 📁 Files Created ✅

- [x] Docker configuration (Dockerfile, docker-compose.yml)
- [x] GitHub Actions workflow (.github/workflows/deploy.yml)
- [x] Production settings (settings_prod.py)
- [x] Environment templates (.env files)
- [x] Deployment scripts (deploy.ps1, deploy.sh)
- [x] Documentation (README.md, DEPLOYMENT_GUIDE.md, GITHUB_SETUP.md)
- [x] Git configuration (.gitignore)

## 🎯 Current Status

**Ready for deployment once prerequisites are installed!**

Your project is fully configured with:
- ✅ Docker containerization
- ✅ Production-ready Django settings  
- ✅ React build configuration
- ✅ GitHub Actions CI/CD pipeline
- ✅ Google Cloud deployment scripts
- ✅ Comprehensive documentation

## 💰 Expected Costs

- **Development**: $0 (local Docker)
- **Production**: $8-25/month (Google Cloud)

## 📞 Next Steps

1. **Install Git** → **Start Docker Desktop** → **Test locally**
2. **Create GitHub repo** → **Push code**  
3. **Setup Google Cloud** → **Configure secrets**
4. **Deploy automatically** with `git push`!

Everything is ready - just need to install the prerequisites! 🚀