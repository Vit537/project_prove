# MyProject - Django + React + PostgreSQL

A full-stack web application built with Django REST API backend, React frontend, and PostgreSQL database. Deployable to Google Cloud Platform with Docker containerization.

## 🏗️ Architecture

- **Backend**: Django 5.2.5 + Django REST Framework
- **Frontend**: React 19.1.1 with modern hooks
- **Database**: PostgreSQL 14
- **Deployment**: Google Cloud (Cloud Run + Cloud Storage + Cloud SQL)
- **Containerization**: Docker & Docker Compose

## 🚀 Quick Start

### Local Development

1. **Clone the repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   cd YOUR_REPO_NAME
   ```

2. **Run with Docker Compose**:
   ```bash
   docker-compose up --build
   ```

3. **Access the application**:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - Django Admin: http://localhost:8000/admin

### Manual Setup (Alternative)

<details>
<summary>Click to expand manual setup instructions</summary>

#### Backend Setup

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

#### Frontend Setup

```bash
cd frontend/myapp_front
npm install
npm start
```

#### Database Setup

```bash
# Install PostgreSQL and create database
createdb myapp_dev
```

</details>

## 🌐 Deployment

### Google Cloud Platform

This project is configured for easy deployment to Google Cloud Platform:

- **Backend**: Cloud Run (serverless containers)
- **Frontend**: Cloud Storage (static website hosting)
- **Database**: Cloud SQL (managed PostgreSQL)

#### Cost Estimation
- ~$8-25/month for small to medium traffic
- Free tier available for development

#### Deployment Options

1. **Automatic (GitHub Actions)**: See [GITHUB_SETUP.md](GITHUB_SETUP.md)
2. **Manual**: See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

### Quick Deploy Commands

```bash
# PowerShell (Windows)
.\deploy.ps1 -ProjectId "your-project-id" -FrontendBucket "your-bucket-name"

# Bash (Linux/Mac)
chmod +x deploy.sh
./deploy.sh
```

## 📁 Project Structure

```
myProject/
├── backend/                 # Django backend
│   ├── myapp/              # Main Django app
│   ├── myapp_conf/         # Django project settings
│   ├── Dockerfile          # Backend container config
│   ├── requirements.txt    # Python dependencies
│   └── manage.py
├── frontend/               
│   └── myapp_front/        # React frontend
│       ├── src/            # React components
│       ├── public/         # Static assets
│       ├── Dockerfile      # Frontend container config
│       └── package.json
├── .github/
│   └── workflows/          # GitHub Actions CI/CD
├── docker-compose.yml      # Local development setup
├── deploy.sh               # Deployment script (Bash)
├── deploy.ps1              # Deployment script (PowerShell)
└── README.md
```

## 🔧 Configuration

### Environment Variables

#### Backend (.env)
```bash
SECRET_KEY=your-secret-key
DEBUG=False
DATABASE_URL=postgresql://user:pass@host:port/dbname
FRONTEND_URL=https://your-frontend-domain.com
```

#### Frontend (.env)
```bash
REACT_APP_API_URL=https://your-backend-domain.com
```

### Docker Configuration

- **Backend**: Python 3.11 with Django and PostgreSQL support
- **Frontend**: Node.js 18 with Nginx for production serving
- **Database**: PostgreSQL 14 official image

## 🧪 Testing

```bash
# Backend tests
cd backend
python manage.py test

# Frontend tests
cd frontend/myapp_front
npm test
```

## 🔒 Security Features

- CORS configuration for frontend-backend communication
- Django security middleware
- Environment-based configuration
- PostgreSQL with proper authentication
- HTTPS enforcement in production
- Security headers (XSS, CSRF protection)

## 📊 Monitoring & Logs

### Google Cloud Logging
```bash
# View backend logs
gcloud run services logs tail django-backend --region=us-central1

# View database logs
gcloud sql operations list --instance=myapp-db
```

### Local Development
- Django debug toolbar (in development)
- Console logging for both frontend and backend

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make changes and test locally
4. Commit changes: `git commit -am 'Add feature'`
5. Push to branch: `git push origin feature-name`
6. Submit a Pull Request

## 📚 Documentation

- [Deployment Guide](DEPLOYMENT_GUIDE.md) - Complete deployment instructions
- [GitHub Setup](GITHUB_SETUP.md) - CI/CD with GitHub Actions
- [Django Documentation](https://docs.djangoproject.com/)
- [React Documentation](https://react.dev/)

## 🛠️ Tech Stack Details

### Backend
- **Django 5.2.5** - Web framework
- **Django REST Framework** - API development
- **psycopg2** - PostgreSQL adapter
- **django-cors-headers** - CORS handling
- **gunicorn** - WSGI HTTP Server
- **whitenoise** - Static file serving

### Frontend
- **React 19.1.1** - UI library
- **axios** - HTTP client
- **React Scripts** - Build toolchain
- **Testing Library** - Testing utilities

### DevOps
- **Docker** - Containerization
- **GitHub Actions** - CI/CD
- **Google Cloud Run** - Container hosting
- **Cloud SQL** - Managed database
- **Cloud Storage** - Static file hosting

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

- Create an issue for bug reports
- Start a discussion for questions
- Check existing documentation first

---

**Built with ❤️ using Django, React, and Google Cloud Platform**
#  Ready for automatic deployment to Google Cloud!

