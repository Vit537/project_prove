# Google Cloud Deployment Guide

## Prerequisites

1. **Install Google Cloud CLI**
   ```bash
   # Download and install from: https://cloud.google.com/sdk/docs/install
   gcloud init
   gcloud auth login
   ```

2. **Create a Google Cloud Project**
   ```bash
   gcloud projects create your-project-id
   gcloud config set project your-project-id
   ```

3. **Enable Billing** (required for Cloud SQL and Cloud Run)
   - Go to Google Cloud Console → Billing
   - Link a payment method to your project

## Cost Estimation (Monthly)

- **Cloud Run** (Backend): $0-5/month (free tier: 2M requests)
- **Cloud Storage** (Frontend): $1-3/month 
- **Cloud SQL** (PostgreSQL): $7-15/month (db-f1-micro instance)
- **Total**: ~$8-25/month for small traffic

## Deployment Steps

### 1. Set Up Database

```bash
# Make script executable
chmod +x setup-database.sh

# Edit the script with your values
nano setup-database.sh

# Run database setup
./setup-database.sh
```

### 2. Configure Environment

```bash
# Copy environment template
cp backend/.env.example backend/.env

# Edit with your values
nano backend/.env
```

### 3. Test Locally with Docker

```bash
# Build and run locally
docker-compose up --build

# Test:
# Frontend: http://localhost:3000
# Backend: http://localhost:8000
```

### 4. Deploy to Google Cloud

```bash
# Edit deploy script with your values
nano deploy.sh

# Make executable
chmod +x deploy.sh

# Deploy
./deploy.sh
```

## Post-Deployment Steps

### 1. Run Database Migrations

```bash
# Connect to Cloud Run and run migrations
gcloud run services update django-backend \
  --add-cloudsql-instances your-project:region:instance-name

# Run migrations through Cloud Shell or locally with Cloud SQL Proxy
```

### 2. Update React Frontend API URLs

Edit your React app to use the deployed backend URL:

```javascript
// In your React app
const API_BASE_URL = 'https://your-backend-url.run.app';
```

### 3. Set Up Custom Domain (Optional)

```bash
# Map custom domain to Cloud Run service
gcloud run domain-mappings create \
  --service django-backend \
  --domain your-domain.com \
  --region us-central1
```

## Monitoring and Logs

```bash
# View backend logs
gcloud run services logs tail django-backend --region=us-central1

# View database logs
gcloud sql operations list --instance=myapp-db
```

## Cost Optimization Tips

1. **Use Cloud Run's pay-per-request model** - automatically scales to zero
2. **Start with smallest Cloud SQL instance** (db-f1-micro)
3. **Use Cloud Storage for static files** instead of Cloud Run
4. **Set up Cloud Run min-instances=0** for development
5. **Monitor usage** with Google Cloud Console

## Scaling Up

When you need more resources:
- Increase Cloud Run memory/CPU
- Upgrade Cloud SQL instance tier
- Add Cloud CDN for global performance
- Implement Cloud Load Balancing

## Security Checklist

- [ ] Change SECRET_KEY in production
- [ ] Set DEBUG=False
- [ ] Use strong database passwords
- [ ] Enable Cloud SQL SSL
- [ ] Set up IAM roles properly
- [ ] Regular security updates

## Common Issues

1. **502 Bad Gateway**: Check Cloud Run logs for Django errors
2. **Database Connection**: Verify Cloud SQL connection name
3. **CORS Issues**: Update CORS_ALLOWED_ORIGINS in settings
4. **Static Files**: Ensure collectstatic runs in Dockerfile

## Support

- Google Cloud Documentation: https://cloud.google.com/docs
- Cloud Run: https://cloud.google.com/run/docs
- Cloud SQL: https://cloud.google.com/sql/docs