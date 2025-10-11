#!/bin/bash

# Google Cloud Deployment Script
# Make sure you have gcloud CLI installed and authenticated

set -e

# Configuration - UPDATE THESE VALUES
PROJECT_ID="your-project-id"
REGION="us-central1"
SERVICE_NAME="django-backend"
FRONTEND_BUCKET="your-frontend-bucket"

# Database configuration
DB_INSTANCE="myapp-db"
DB_NAME="myapp_production"
DB_USER="myapp_user"

echo "🚀 Starting deployment to Google Cloud..."

# Set project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "📋 Enabling required APIs..."
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Build and deploy backend
echo "🏗️ Building and deploying Django backend..."
cd backend

# Build container image
gcloud builds submit --tag gcr.io/$PROJECT_ID/$SERVICE_NAME

# Deploy to Cloud Run
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$SERVICE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 8080 \
  --memory 512Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10 \
  --set-env-vars DJANGO_SETTINGS_MODULE=myapp_conf.settings_prod

echo "✅ Backend deployed successfully!"

# Get backend URL
BACKEND_URL=$(gcloud run services describe $SERVICE_NAME --region=$REGION --format='value(status.url)')
echo "Backend URL: $BACKEND_URL"

cd ../

# Build and deploy frontend
echo "🎨 Building and deploying React frontend..."
cd frontend/myapp_front

# Create bucket for frontend
gsutil mb gs://$FRONTEND_BUCKET || true

# Build React app
npm run build

# Upload to Cloud Storage
gsutil -m rsync -r -d build gs://$FRONTEND_BUCKET

# Make bucket public
gsutil iam ch allUsers:objectViewer gs://$FRONTEND_BUCKET

# Set up website configuration
gsutil web set -m index.html -e index.html gs://$FRONTEND_BUCKET

echo "✅ Frontend deployed successfully!"
echo "Frontend URL: https://storage.googleapis.com/$FRONTEND_BUCKET/index.html"

cd ../../

echo "🎉 Deployment completed!"
echo "📊 Services deployed:"
echo "  Backend:  $BACKEND_URL"
echo "  Frontend: https://storage.googleapis.com/$FRONTEND_BUCKET/index.html"
echo ""
echo "💡 Next steps:"
echo "1. Update your React app's API URLs to point to: $BACKEND_URL"
echo "2. Run database migrations: gcloud run services update $SERVICE_NAME --add-cloudsql-instances $PROJECT_ID:$REGION:$DB_INSTANCE"
echo "3. Set up your environment variables in Cloud Run"