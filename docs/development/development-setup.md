# Development Setup Guide

> **🛠️ Complete Development Environment Setup for Generic Multi-Tenant Framework**

This guide provides step-by-step instructions for setting up the complete development environment for both backend and frontend components.

## 📋 **Table of Contents**

1. [Prerequisites](#prerequisites)
2. [Backend Setup](#backend-setup)
3. [Frontend Setup](#frontend-setup)
4. [Database Setup](#database-setup)
5. [Docker Setup](#docker-setup)
6. [IDE Configuration](#ide-configuration)
7. [Verification](#verification)
8. [Troubleshooting](#troubleshooting)

## 🔧 **Prerequisites**

### **System Requirements**
- **Operating System**: macOS, Windows, or Linux
- **RAM**: 16GB minimum, 32GB recommended
- **Storage**: 20GB free space minimum
- **Network**: Internet connection for package downloads

### **Required Software**

#### **Backend Requirements**
- **Node.js**: 18.0.0 or higher
- **npm**: 8.0.0 or higher
- **Docker**: Latest version
- **Docker Compose**: Latest version
- **PostgreSQL**: 14.0 or higher (or use Docker)

#### **Frontend Requirements**
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher (included with Flutter)
- **Android Studio**: Latest version (for Android development)
- **Xcode**: 14.0 or higher (for iOS development, macOS only)

#### **Development Tools**
- **Git**: Latest version
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA
- **Terminal**: Command line interface

## 🔧 **Backend Setup**

### **1. Install Node.js and npm**

#### **macOS**
```bash
# Using Homebrew
brew install node

# Verify installation
node --version
npm --version
```

#### **Windows**
1. Download Node.js from [nodejs.org](https://nodejs.org/)
2. Run the installer
3. Verify installation in Command Prompt

#### **Linux**
```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

### **2. Clone Repository**
```bash
# Clone the repository
git clone <repository-url>
cd gym-manager

# Navigate to backend
cd apps/backend
```

### **3. Install Dependencies**
```bash
# Install backend dependencies
npm install

# Verify installation
npm list
```

### **4. Environment Configuration**
```bash
# Copy environment template
cp env.example .env

# Edit environment variables
nano .env
```

#### **Environment Variables**
```bash
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=password
DATABASE_NAME=generic_framework

# Application
PORT=3000
NODE_ENV=development
LOG_LEVEL=debug

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=24h

# Multi-tenancy
DEFAULT_TENANT_SLUG=default-tenant
```

### **5. Verify Backend Setup**
```bash
# Run linting
npm run lint

# Run tests
npm run test

# Start development server
npm run start:dev
```

## 📱 **Frontend Setup**

### **1. Install Flutter SDK**

#### **macOS**
```bash
# Download Flutter SDK
cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.16.0-stable.zip

# Extract Flutter SDK
unzip flutter_macos_3.16.0-stable.zip

# Add to PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

#### **Windows**
1. Download Flutter SDK from [Flutter website](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\flutter`
3. Add `C:\flutter\bin` to system PATH

#### **Linux**
```bash
# Download Flutter SDK
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# Extract Flutter SDK
tar xf flutter_linux_3.16.0-stable.tar.xz

# Add to PATH
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### **2. Verify Flutter Installation**
```bash
# Check Flutter installation
flutter --version

# Run Flutter doctor
flutter doctor
```

### **3. Install Flutter Dependencies**
```bash
# Navigate to frontend
cd apps/frontend

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n
```

### **4. Platform-Specific Setup**

#### **Android Setup**
```bash
# Install Android Studio
# Download from https://developer.android.com/studio

# Accept Android licenses
flutter doctor --android-licenses

# Create Android emulator
flutter emulators --create --name generic_framework
```

#### **iOS Setup (macOS only)**
```bash
# Install Xcode from App Store
# Install CocoaPods
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..
```

### **5. Verify Frontend Setup**
```bash
# Run analysis
flutter analyze

# Run tests
flutter test

# Check available devices
flutter devices
```

## 🗄️ **Database Setup**

### **Option 1: Docker (Recommended)**

```bash
# Start PostgreSQL with Docker
docker-compose up -d postgres

# Verify database is running
docker-compose ps
```

### **Option 2: Local PostgreSQL**

#### **macOS**
```bash
# Install PostgreSQL
brew install postgresql

# Start PostgreSQL
brew services start postgresql

# Create database
createdb generic_framework
```

#### **Windows**
1. Download PostgreSQL from [postgresql.org](https://www.postgresql.org/download/windows/)
2. Run the installer
3. Create database using pgAdmin

#### **Linux**
```bash
# Install PostgreSQL
sudo apt-get install postgresql postgresql-contrib

# Start PostgreSQL
sudo systemctl start postgresql

# Create database
sudo -u postgres createdb generic_framework
```

### **Database Configuration**
```sql
-- Create database
CREATE DATABASE generic_framework;

-- Create user
CREATE USER framework_user WITH PASSWORD 'framework_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE generic_framework TO framework_user;
```

## 🐳 **Docker Setup**

### **1. Install Docker**

#### **macOS**
```bash
# Install Docker Desktop
brew install --cask docker

# Start Docker Desktop
open -a Docker
```

#### **Windows**
1. Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)
2. Run the installer
3. Start Docker Desktop

#### **Linux**
```bash
# Install Docker
sudo apt-get update
sudo apt-get install docker.io docker-compose

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### **2. Docker Compose Configuration**
```yaml
# docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: generic_framework
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### **3. Start Services**
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 💻 **IDE Configuration**

### **VS Code (Recommended)**

#### **1. Install VS Code**
- Download from [VS Code website](https://code.visualstudio.com/)

#### **2. Install Extensions**
```bash
# Backend extensions
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension bradlc.vscode-tailwindcss
code --install-extension esbenp.prettier-vscode

# Frontend extensions
code --install-extension dart-code.dart-code
code --install-extension dart-code.flutter
code --install-extension localizely.flutter-intl

# General extensions
code --install-extension ms-vscode.vscode-json
code --install-extension redhat.vscode-yaml
code --install-extension ms-vscode.vscode-markdown
```

#### **3. Configure Settings**
```json
// .vscode/settings.json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.sdkPath": "/path/to/flutter/bin/cache/dart-sdk",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.lineLength": 80,
  "dart.insertArgumentPlaceholders": false,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true
}
```

### **Android Studio**

#### **1. Install Android Studio**
- Download from [Android Studio website](https://developer.android.com/studio)

#### **2. Install Plugins**
- Flutter plugin
- Dart plugin

#### **3. Configure Flutter SDK**
- Set Flutter SDK path in preferences
- Configure Android SDK path

## ✅ **Verification**

### **1. Backend Verification**
```bash
# Navigate to backend
cd apps/backend

# Run tests
npm run test

# Start development server
npm run start:dev

# Check API health
curl http://localhost:3000/health
```

### **2. Frontend Verification**
```bash
# Navigate to frontend
cd apps/frontend

# Run analysis
flutter analyze

# Run tests
flutter test

# Start development server
flutter run
```

### **3. Database Verification**
```bash
# Connect to database
psql -h localhost -U postgres -d generic_framework

# Check tables
\dt

# Exit
\q
```

### **4. Full Stack Verification**
```bash
# Start all services
npm run dev

# Check backend
curl http://localhost:3000/health

# Check frontend
open http://localhost:3001
```

## 🐛 **Troubleshooting**

### **Common Issues**

#### **1. Node.js Issues**
```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

#### **2. Flutter Issues**
```bash
# Clean Flutter cache
flutter clean

# Get dependencies again
flutter pub get

# Clear pub cache
flutter pub cache clean
```

#### **3. Database Issues**
```bash
# Reset database
docker-compose down -v
docker-compose up -d

# Check database logs
docker-compose logs postgres
```

#### **4. Docker Issues**
```bash
# Restart Docker
sudo systemctl restart docker

# Clean Docker cache
docker system prune -a
```

### **Performance Issues**

#### **1. Slow Build Times**
- Use `--debug` for development
- Use `--profile` for performance testing
- Use `--release` for production

#### **2. Memory Issues**
- Close unused emulators
- Restart IDE
- Clear caches

#### **3. Network Issues**
- Check internet connection
- Use VPN if needed
- Clear package caches

## 📚 **Additional Resources**

### **Documentation**
- [Backend Documentation](apps/backend/docs/backend-documentation-overview.md)
- [Frontend Documentation](apps/frontend/docs/frontend-documentation-overview.md)
- [Architecture Documentation](docs/architecture/monorepo-architecture.md)

### **Community Resources**
- [NestJS Documentation](https://docs.nestjs.com/)
- [Flutter Documentation](https://flutter.dev/docs)
- [Docker Documentation](https://docs.docker.com/)

## ✅ **Verification Checklist**

Before starting development, verify:

- [ ] Node.js and npm installed
- [ ] Flutter SDK installed and in PATH
- [ ] Docker and Docker Compose installed
- [ ] PostgreSQL running (Docker or local)
- [ ] Backend dependencies installed
- [ ] Frontend dependencies installed
- [ ] Backend tests passing
- [ ] Frontend tests passing
- [ ] Backend server starting
- [ ] Frontend app running
- [ ] Database connection working
- [ ] IDE configured properly

## 🎯 **Next Steps**

After completing setup:

1. **Read Architecture Guide**: [Monorepo Architecture](docs/architecture/monorepo-architecture.md)
2. **Learn Backend**: [Backend Documentation](apps/backend/docs/backend-documentation-overview.md)
3. **Learn Frontend**: [Frontend Documentation](apps/frontend/docs/frontend-documentation-overview.md)
4. **Start Development**: Begin building features

---

**Last Updated**: September 2024  
**Framework Version**: 1.0.0  
**Node.js Version**: 18+  
**Flutter Version**: 3.0+
