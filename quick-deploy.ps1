# Quick Deploy Script - Run this after enabling billing
# This script will complete your Google Cloud deployment

param(
    [string]$ProjectId = "empyrean-engine-474503-v3",
    [string]$FrontendBucket = "empyrean-engine-frontend-$(Get-Random)"
)

Write-Host "🚀 Quick Deploy to Google Cloud" -ForegroundColor Green
Write-Host "Project: $ProjectId" -ForegroundColor Cyan
Write-Host "Frontend Bucket: $FrontendBucket" -ForegroundColor Cyan

# Set project
Write-Host "📋 Setting project..." -ForegroundColor Yellow
gcloud config set project $ProjectId

# Enable APIs
Write-Host "🔧 Enabling required APIs..." -ForegroundColor Yellow
gcloud services enable cloudbuild.googleapis.com run.googleapis.com sql-component.googleapis.com sqladmin.googleapis.com storage-api.googleapis.com

# Create service account for GitHub Actions
Write-Host "👤 Creating service account..." -ForegroundColor Yellow
gcloud iam service-accounts create github-actions --description="Service account for GitHub Actions" --display-name="GitHub Actions"

# Grant permissions
Write-Host "🔐 Setting up permissions..." -ForegroundColor Yellow
gcloud projects add-iam-policy-binding $ProjectId --member="serviceAccount:github-actions@$ProjectId.iam.gserviceaccount.com" --role="roles/run.admin"
gcloud projects add-iam-policy-binding $ProjectId --member="serviceAccount:github-actions@$ProjectId.iam.gserviceaccount.com" --role="roles/storage.admin"
gcloud projects add-iam-policy-binding $ProjectId --member="serviceAccount:github-actions@$ProjectId.iam.gserviceaccount.com" --role="roles/cloudsql.client"
gcloud projects add-iam-policy-binding $ProjectId --member="serviceAccount:github-actions@$ProjectId.iam.gserviceaccount.com" --role="roles/cloudbuild.builds.editor"

# Create service account key
Write-Host "🔑 Creating service account key..." -ForegroundColor Yellow
gcloud iam service-accounts keys create github-actions-key.json --iam-account=github-actions@$ProjectId.iam.gserviceaccount.com

# Create Cloud SQL instance
Write-Host "🗄️ Creating Cloud SQL instance..." -ForegroundColor Yellow
gcloud sql instances create myapp-db --database-version=POSTGRES_14 --tier=db-f1-micro --region=us-central1 --storage-type=HDD --storage-size=10GB

# Create database and user
Write-Host "📊 Setting up database..." -ForegroundColor Yellow
gcloud sql databases create myapp_production --instance=myapp-db
gcloud sql users create myapp_user --instance=myapp-db --password="$(New-Guid)"

# Get connection info
$CONNECTION_NAME = gcloud sql instances describe myapp-db --format='value(connectionName)'

Write-Host "✅ Setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 GitHub Secrets to add:" -ForegroundColor Yellow
Write-Host "GCP_PROJECT_ID: $ProjectId" -ForegroundColor White
Write-Host "GCP_SA_KEY: [Content of github-actions-key.json file]" -ForegroundColor White
Write-Host "DJANGO_SECRET_KEY: [Generate a random 50-character string]" -ForegroundColor White
Write-Host "DATABASE_URL: postgresql://myapp_user:password@/myapp_production?host=/cloudsql/$CONNECTION_NAME" -ForegroundColor White
Write-Host "CLOUD_SQL_CONNECTION_NAME: $CONNECTION_NAME" -ForegroundColor White
Write-Host "FRONTEND_BUCKET: $FrontendBucket" -ForegroundColor White
Write-Host ""
Write-Host "🌐 Add these to: https://github.com/Vit537/project_prove/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 After adding secrets, push any change to main branch to trigger deployment!" -ForegroundColor Green