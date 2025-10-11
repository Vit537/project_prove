# Database setup script for Google Cloud SQL
# Run this after creating your Cloud SQL instance

# Set your project configuration
PROJECT_ID="your-project-id"
REGION="us-central1"
DB_INSTANCE="myapp-db"
DB_NAME="myapp_production"
DB_USER="myapp_user"

# Create Cloud SQL PostgreSQL instance (cheapest tier)
gcloud sql instances create $DB_INSTANCE \
  --database-version=POSTGRES_14 \
  --tier=db-f1-micro \
  --region=$REGION \
  --storage-type=HDD \
  --storage-size=10GB \
  --storage-auto-increase

# Set root password
gcloud sql users set-password postgres \
  --instance=$DB_INSTANCE \
  --password="your-secure-password"

# Create database
gcloud sql databases create $DB_NAME \
  --instance=$DB_INSTANCE

# Create database user
gcloud sql users create $DB_USER \
  --instance=$DB_INSTANCE \
  --password="user-password"

# Get connection name
CONNECTION_NAME=$(gcloud sql instances describe $DB_INSTANCE --format='value(connectionName)')
echo "Connection name: $CONNECTION_NAME"

# Update your .env file with this connection string:
echo "DATABASE_URL=postgresql://$DB_USER:user-password@/$DB_NAME?host=/cloudsql/$CONNECTION_NAME"