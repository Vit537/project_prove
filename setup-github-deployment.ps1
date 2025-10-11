# Automatic Setup Script for GitHub Actions Deployment
# Run this AFTER enabling billing in Google Cloud Console

# Configuration for your account
$PROJECT_ID = "big-axiom-474503-m5"
$REGION = "us-central1"
$DB_INSTANCE = "myapp-db"
$SERVICE_ACCOUNT = "github-actions"
$FRONTEND_BUCKET = "big-axiom-frontend-$(Get-Random -Maximum 9999)"

Write-Host "🚀 Setting up automatic GitHub deployment" -ForegroundColor Green
Write-Host "Account: goku02820@gmail.com" -ForegroundColor Cyan
Write-Host "Project: $PROJECT_ID" -ForegroundColor Cyan
Write-Host "Frontend Bucket: $FRONTEND_BUCKET" -ForegroundColor Cyan
Write-Host ""

# Verify we're using the right project
Write-Host "📋 Verifying project configuration..." -ForegroundColor Yellow
gcloud config set project $PROJECT_ID

# Enable required APIs
Write-Host "🔧 Enabling Google Cloud APIs..." -ForegroundColor Yellow
$apis = @(
    "cloudbuild.googleapis.com",
    "run.googleapis.com", 
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-api.googleapis.com"
)

foreach ($api in $apis) {
    Write-Host "  Enabling $api..." -ForegroundColor White
    gcloud services enable $api
}

# Create service account
Write-Host "👤 Creating service account for GitHub Actions..." -ForegroundColor Yellow
gcloud iam service-accounts create $SERVICE_ACCOUNT `
    --description="GitHub Actions Service Account" `
    --display-name="GitHub Actions"

# Grant permissions
Write-Host "🔐 Setting up IAM permissions..." -ForegroundColor Yellow
$roles = @(
    "roles/run.admin",
    "roles/storage.admin", 
    "roles/cloudsql.client",
    "roles/cloudbuild.builds.editor"
)

$serviceAccountEmail = "$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com"

foreach ($role in $roles) {
    Write-Host "  Granting $role..." -ForegroundColor White
    gcloud projects add-iam-policy-binding $PROJECT_ID `
        --member="serviceAccount:$serviceAccountEmail" `
        --role="$role"
}

# Create service account key (LOCAL ONLY - NOT COMMITTED TO GIT)
Write-Host "🔑 Creating service account key (LOCAL FILE ONLY)..." -ForegroundColor Yellow
gcloud iam service-accounts keys create github-actions-key.json `
    --iam-account=$serviceAccountEmail

Write-Host "⚠️  SECURITY NOTE: github-actions-key.json created locally and ignored by git" -ForegroundColor Red

# Create Cloud SQL instance
Write-Host "🗄️ Creating Cloud SQL PostgreSQL database..." -ForegroundColor Yellow
gcloud sql instances create $DB_INSTANCE `
    --database-version=POSTGRES_14 `
    --tier=db-f1-micro `
    --region=$REGION `
    --storage-type=HDD `
    --storage-size=10GB `
    --storage-auto-increase

# Generate passwords
$rootPassword = "Root$(Get-Random -Maximum 99999)Pass!"
$userPassword = "User$(Get-Random -Maximum 99999)Pass!"

# Set root password
Write-Host "🔒 Setting database passwords..." -ForegroundColor Yellow
gcloud sql users set-password postgres `
    --instance=$DB_INSTANCE `
    --password="$rootPassword"

# Create database
Write-Host "📊 Creating application database..." -ForegroundColor Yellow
gcloud sql databases create myapp_production --instance=$DB_INSTANCE

# Create database user
gcloud sql users create myapp_user `
    --instance=$DB_INSTANCE `
    --password="$userPassword"

# Get connection name
$connectionName = gcloud sql instances describe $DB_INSTANCE --format='value(connectionName)'

# Generate Django secret key
Write-Host "🔐 Generating Django secret key..." -ForegroundColor Yellow
$djangoSecret = -join ((65..90) + (97..122) + (48..57) + 33,35,40,41,42,43,45,61,95,123,125 | Get-Random -Count 50 | ForEach-Object {[char]$_})

# Read service account key content
$serviceAccountKey = Get-Content "github-actions-key.json" -Raw

Write-Host ""
Write-Host "✅ Setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 GitHub Secrets Configuration" -ForegroundColor Yellow
Write-Host "Go to: https://github.com/Vit537/project_prove/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "Add these 6 repository secrets:" -ForegroundColor White
Write-Host ""

Write-Host "1. GCP_PROJECT_ID" -ForegroundColor Magenta
Write-Host "   Value: $PROJECT_ID" -ForegroundColor White
Write-Host ""

Write-Host "2. GCP_SA_KEY" -ForegroundColor Magenta  
Write-Host "   Value: [Content of github-actions-key.json - copy from file]" -ForegroundColor White
Write-Host ""

Write-Host "3. DJANGO_SECRET_KEY" -ForegroundColor Magenta
Write-Host "   Value: $djangoSecret" -ForegroundColor White
Write-Host ""

Write-Host "4. DATABASE_URL" -ForegroundColor Magenta
Write-Host "   Value: postgresql://myapp_user:$userPassword@/myapp_production?host=/cloudsql/$connectionName" -ForegroundColor White
Write-Host ""

Write-Host "5. CLOUD_SQL_CONNECTION_NAME" -ForegroundColor Magenta  
Write-Host "   Value: $connectionName" -ForegroundColor White
Write-Host ""

Write-Host "6. FRONTEND_BUCKET" -ForegroundColor Magenta
Write-Host "   Value: $FRONTEND_BUCKET" -ForegroundColor White
Write-Host ""

Write-Host "🚀 After adding all secrets to GitHub:" -ForegroundColor Green
Write-Host "git add . && git commit -m 'Deploy to production' && git push origin main" -ForegroundColor Cyan
Write-Host ""
Write-Host "Watch deployment at: https://github.com/Vit537/project_prove/actions" -ForegroundColor Yellow

# Save configuration for reference (LOCAL ONLY - NOT COMMITTED TO GIT)
@"
# Deployment Configuration
Project: $PROJECT_ID
Account: goku02820@gmail.com  
Region: $REGION
Database Instance: $DB_INSTANCE
Connection Name: $connectionName
Frontend Bucket: $FRONTEND_BUCKET
Service Account: $serviceAccountEmail

# Database Credentials (SENSITIVE - LOCAL ONLY)
Root Password: $rootPassword
User Password: $userPassword
Django Secret: $djangoSecret

# GitHub Repository: https://github.com/Vit537/project_prove
# Add secrets at: https://github.com/Vit537/project_prove/settings/secrets/actions

# SECURITY NOTE: This file contains sensitive information and is ignored by git
"@ | Out-File -FilePath "deployment-config.txt" -Encoding UTF8

Write-Host "📄 Configuration saved to: deployment-config.txt (LOCAL ONLY)" -ForegroundColor Green
Write-Host "⚠️  These files contain sensitive data and are ignored by git for security" -ForegroundColor Red