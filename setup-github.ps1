# GitHub Repository Setup Script
# Run this script to initialize your GitHub repository

param(
    [Parameter(Mandatory=$true)]
    [string]$RepoName,
    
    [Parameter(Mandatory=$true)]
    [string]$GitHubUsername,
    
    [string]$Description = "Django + React + PostgreSQL project with Google Cloud deployment"
)

Write-Host "🚀 Setting up GitHub repository..." -ForegroundColor Green

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Check if GitHub CLI is installed
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

# Initialize git repository
if (-not (Test-Path ".git")) {
    Write-Host "📁 Initializing Git repository..." -ForegroundColor Yellow
    git init
} else {
    Write-Host "📁 Git repository already exists." -ForegroundColor Green
}

# Add all files
Write-Host "📝 Adding files to Git..." -ForegroundColor Yellow
git add .

# Create initial commit
$commitExists = git log --oneline 2>$null
if (-not $commitExists) {
    Write-Host "💾 Creating initial commit..." -ForegroundColor Yellow
    git commit -m "Initial commit: Django + React + PostgreSQL project with Google Cloud deployment setup"
} else {
    Write-Host "💾 Repository already has commits." -ForegroundColor Green
}

# Set main branch
git branch -M main

if ($ghInstalled) {
    # Use GitHub CLI to create repository
    Write-Host "🌐 Creating GitHub repository using GitHub CLI..." -ForegroundColor Yellow
    
    try {
        gh repo create $RepoName --public --description $Description --source . --remote origin --push
        Write-Host "✅ Repository created successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to create repository with GitHub CLI. Please create manually." -ForegroundColor Red
        Write-Host "Manual steps:" -ForegroundColor Yellow
        Write-Host "1. Go to https://github.com/new" -ForegroundColor White
        Write-Host "2. Create repository named: $RepoName" -ForegroundColor White
        Write-Host "3. Run: git remote add origin https://github.com/$GitHubUsername/$RepoName.git" -ForegroundColor White
        Write-Host "4. Run: git push -u origin main" -ForegroundColor White
    }
} else {
    # Manual setup instructions
    Write-Host "📋 GitHub CLI not found. Manual setup required:" -ForegroundColor Yellow
    Write-Host "1. Go to https://github.com/new" -ForegroundColor White
    Write-Host "2. Repository name: $RepoName" -ForegroundColor White
    Write-Host "3. Description: $Description" -ForegroundColor White
    Write-Host "4. Choose Public or Private" -ForegroundColor White
    Write-Host "5. DO NOT initialize with README (we already have files)" -ForegroundColor White
    Write-Host "6. Click 'Create repository'" -ForegroundColor White
    Write-Host ""
    Write-Host "After creating the repository, run these commands:" -ForegroundColor Yellow
    Write-Host "git remote add origin https://github.com/$GitHubUsername/$RepoName.git" -ForegroundColor Cyan
    Write-Host "git push -u origin main" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎉 Next steps:" -ForegroundColor Green
Write-Host "1. Set up Google Cloud service account (see GITHUB_SETUP.md)" -ForegroundColor White
Write-Host "2. Configure GitHub secrets for deployment" -ForegroundColor White
Write-Host "3. Push code to trigger automatic deployment" -ForegroundColor White
Write-Host ""
Write-Host "📖 Read GITHUB_SETUP.md for detailed instructions" -ForegroundColor Cyan