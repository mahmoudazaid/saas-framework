# Backend Setup Guide

This guide covers setting up the backend development environment for the Gym Manager framework.

## 🚀 Quick Start

### Prerequisites
- **Node.js**: 18+ and npm 8+
- **PostgreSQL**: 14+ (or use Docker)
- **Docker**: Latest version with Docker Compose
- **Git**: Latest version

### One-Command Setup
```bash
# Clone and setup everything
git clone <repository-url>
cd gym-manager
npm run setup
```

## 🔧 Detailed Setup

### 1. Clone Repository
```bash
git clone <repository-url>
cd gym-manager
```

### 2. Install Dependencies
```bash
# Install root dependencies
npm install

# Install backend dependencies
cd apps/backend
npm install
```

### 3. Database Setup
```bash
# Start PostgreSQL with Docker
npm run start:db

# Or manually with Docker Compose
docker-compose up -d postgres
```

### 4. Environment Configuration
```bash
# Backend environment
cp apps/backend/env.example apps/backend/.env

# Edit the .env file with your settings
# DATABASE_URL=postgresql://postgres:password@localhost:5432/app_database
# PORT=3000
# NODE_ENV=development
```

### 5. Start Development
```bash
# Start backend
npm run dev:backend

# Backend will be available at http://localhost:3000
```

## 🛠️ Development Tools

### Required Tools
- **VS Code**: Recommended IDE
- **Docker Desktop**: For containerization
- **Postman**: For API testing

### VS Code Extensions
```json
{
  "recommendations": [
    "ms-vscode.vscode-typescript-next",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "ms-vscode.vscode-docker"
  ]
}
```

### Backend Development
- **TypeScript**: Strict mode enabled
- **ESLint**: Code quality and style
- **Prettier**: Code formatting
- **Jest**: Testing framework

## 🗄️ Database Development

### Local Database
```bash
# Start PostgreSQL
npm run start:db

# Check database status
docker ps

# Connect to database
docker exec -it gym-manager-postgres-1 psql -U postgres -d app_database
```

### Database Management
```bash
# Reset database (removes all data)
npm run reset:db

# Stop database
npm run stop:db

# View database logs
docker-compose logs postgres
```

### Database Schema
- **Multi-tenant**: All tables include `tenantId`
- **Audit Fields**: `createdAt`, `updatedAt`, `isDeleted`
- **UUIDs**: All primary keys are UUIDs
- **Indexes**: Optimized for tenant-based queries

## 🧪 Testing Setup

### Backend Testing
```bash
# Run all tests
npm run test:backend

# Run specific test types
npm run test:backend:unit
npm run test:backend:integration

# Run tests with coverage
npm run test:backend:coverage

# Run tests in watch mode
npm run test:backend:watch
```

## 🔍 Debugging

### Backend Debugging
```bash
# Start with debugger
npm run start:debug

# Attach debugger to running process
# VS Code: Attach to Node Process
```

### Database Debugging
```bash
# View database logs
docker-compose logs postgres

# Connect to database
docker exec -it gym-manager-postgres-1 psql -U postgres -d app_database

# View database schema
\dt
\d+ <table_name>
```

## 📊 Monitoring

### Application Logs
```bash
# Backend logs
npm run dev:backend

# Database logs
docker-compose logs postgres
```

### Performance Monitoring
- **Backend**: Built-in logging and metrics
- **Database**: PostgreSQL query logs

## 🚀 Build and Deploy

### Development Build
```bash
# Build backend
npm run build:backend
```

### Production Build
```bash
# Production build with optimizations
NODE_ENV=production npm run build:backend
```

### Docker Build
```bash
# Build Docker images
docker-compose build

# Run with Docker
docker-compose up
```

## 🔧 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

#### Database Connection Issues
```bash
# Check if PostgreSQL is running
docker ps

# Restart database
npm run stop:db
npm run start:db
```

#### Node.js Issues
```bash
# Clear npm cache
npm cache clean --force

# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

### Getting Help
- **Documentation**: Check the [docs/](docs/) directory
- **Issues**: Create a GitHub issue
- **Discussions**: Use GitHub Discussions

## 📚 Next Steps

After setup, you can:
1. **Read Architecture**: [Clean Architecture](architecture/clean-architecture.md)
2. **Follow Development**: [Code Organization](code-organization.md)
3. **Understand Testing**: [Testing Guide](testing/testing-guide.md)
4. **Learn API**: [API Documentation](api/endpoints.md)

## 🎯 Development Checklist

- [ ] Repository cloned
- [ ] Dependencies installed
- [ ] Database running
- [ ] Environment configured
- [ ] Backend running (http://localhost:3000)
- [ ] Tests passing
- [ ] Linting passing
- [ ] Documentation accessible

---

**Happy Developing! 🚀**
