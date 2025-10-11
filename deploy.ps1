# PowerShell Deployment Script for Windows
# Make sure you have gcloud CLI installed and authenticated

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectId,
    
    [string]$Region = "us-central1",
    [string]$ServiceName = "django-backend",
    [string]$FrontendBucket = "your-frontend-bucket"
)

Write-Host "🚀 Starting deployment to Google Cloud..." -ForegroundColor Green

# Set project
gcloud config set project $ProjectId

# Enable required APIs
Write-Host "📋 Enabling required APIs..." -ForegroundColor Yellow
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Build and deploy backend
Write-Host "🏗️ Building and deploying Django backend..." -ForegroundColor Yellow
Set-Location backend

# Build container image
gcloud builds submit --tag "gcr.io/$ProjectId/$ServiceName"

# Deploy to Cloud Run
gcloud run deploy $ServiceName `
  --image "gcr.io/$ProjectId/$ServiceName" `
  --platform managed `
  --region $Region `
  --allow-unauthenticated `
  --port 8080 `
  --memory 512Mi `
  --cpu 1 `
  --min-instances 0 `
  --max-instances 10 `
  --set-env-vars "DJANGO_SETTINGS_MODULE=myapp_conf.settings_prod"

Write-Host "✅ Backend deployed successfully!" -ForegroundColor Green

# Get backend URL
$BackendUrl = gcloud run services describe $ServiceName --region=$Region --format='value(status.url)'
Write-Host "Backend URL: $BackendUrl" -ForegroundColor Cyan

Set-Location ../

# Build and deploy frontend
Write-Host "🎨 Building and deploying React frontend..." -ForegroundColor Yellow
Set-Location frontend/myapp_front

# Create bucket for frontend
gsutil mb "gs://$FrontendBucket" 2>$null

# Install dependencies and build React app
npm install
npm run build

# Upload to Cloud Storage
gsutil -m rsync -r -d build "gs://$FrontendBucket"

# Make bucket public
gsutil iam ch allUsers:objectViewer "gs://$FrontendBucket"

# Set up website configuration
gsutil web set -m index.html -e index.html "gs://$FrontendBucket"

Write-Host "✅ Frontend deployed successfully!" -ForegroundColor Green
Write-Host "Frontend URL: https://storage.googleapis.com/$FrontendBucket/index.html" -ForegroundColor Cyan

Set-Location ../../

Write-Host "🎉 Deployment completed!" -ForegroundColor Green
Write-Host "📊 Services deployed:" -ForegroundColor White
Write-Host "  Backend:  $BackendUrl" -ForegroundColor White
Write-Host "  Frontend: https://storage.googleapis.com/$FrontendBucket/index.html" -ForegroundColor White
Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Yellow
Write-Host "1. Update your React app's API URLs to point to: $BackendUrl"
Write-Host "2. Run database migrations"
Write-Host "3. Set up your environment variables in Cloud Run"