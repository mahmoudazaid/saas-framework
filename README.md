# SaaS Framework - Multi-Tenant SaaS Application Platform

A comprehensive, production-ready framework for building scalable multi-tenant SaaS applications with Flutter frontend and NestJS backend.

## 🏗️ Architecture Overview

This is a **monorepo** containing:
- **Backend**: NestJS + Fastify + TypeORM + PostgreSQL
- **Frontend**: Flutter + Dart (mobile + web)
- **Database**: PostgreSQL with multi-tenancy support
- **Containerization**: Docker for development and production

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm 8+
- Flutter 3.0+
- Docker and Docker Compose
- PostgreSQL 14+

### Setup
   ```bash
# Clone and setup
   git clone <repository-url>
   cd saas-framework

# Install dependencies
   npm run setup

# Start database only
   npm run start:db

# Start full development stack (database + backend)
npm run start:dev

# Start development servers
   npm run dev
   ```

### 🎯 Customize for Your Project
```bash
# Run the complete setup and customization script
./setup.sh

# Or follow the detailed guide
# See: docs/development/project-customization-checklist.md
```

## 🐳 Docker Usage

### Database Only (Production/Staging)
```bash
# Start PostgreSQL + pgAdmin
npm run start:db

# Stop services
npm run stop:db

# Reset database (removes all data)
npm run reset:db
```

### Full Development Stack
```bash
# Start database + backend (with hot reload)
npm run start:dev

# Stop all services
npm run stop:dev

# View logs
docker-compose -f docker/docker-compose.yml logs -f backend
```

### Manual Docker Commands
```bash
# Database only
docker-compose -f docker/docker-compose.yml up -d

# Full development stack
docker-compose -f docker/docker-compose.yml --profile development up -d
```

### Available Services
- **PostgreSQL**: `localhost:5432` (database: `saas_framework`)
- **pgAdmin**: `localhost:5050` (admin@saasframework.com / admin)
- **Backend API**: `localhost:3000` (development profile only)

## 📚 Documentation

### 🏗️ Architecture
- [Monorepo Architecture](docs/architecture/monorepo-architecture.md) - Overall system design and structure
- [Multi-tenancy Design](docs/architecture/multi-tenancy-design.md) - Multi-tenant architecture patterns
- [Clean Architecture](docs/architecture/clean-architecture.md) - Architectural principles and patterns
- [Database Design](docs/architecture/database-design.md) - Database schema and relationships

### 🔧 Development
- [Development Setup](docs/development/development-setup.md) - Environment setup and configuration
- [Project Customization](docs/development/project-customization-checklist.md) - How to customize for your business
- [Framework Customization](docs/development/framework-customization-checklist.md) - Complete list of entities, classes, and docs to update/delete
- [Development Workflow](docs/development/development-workflow.md) - How to develop features
- [Testing Strategy](docs/development/testing-strategy.md) - Testing approach and tools
- [Contributing Guidelines](docs/development/contributing-guidelines.md) - How to contribute

### 🗄️ Database
- [Database Overview](docs/database/) - Complete database documentation
- [Schema Overview](docs/database/schema-overview.md) - High-level database design
- [Entity Documentation](docs/database/entities/) - Individual entity specifications
- [Relationships](docs/database/relationships/) - Table relationships and constraints
- [Migrations](docs/database/migrations/) - Migration history and guidelines
- [Database Diagrams](docs/database/diagrams/) - Visual schema representations

### 📖 API Documentation
- [Entity Management](docs/api/entity-apis.md) - Entity management endpoints
- [Multi-tenant Authentication](docs/api/multi-tenant-authentication.md) - Tenant management APIs
- [API Client](docs/api/api-client.md) - Frontend API client patterns

### 🔧 Backend-Specific Documentation
- [Backend Documentation Overview](apps/backend/docs/backend-documentation-overview.md) - Complete backend documentation hub
- [Backend Architecture](apps/backend/docs/architecture/clean-architecture.md) - Detailed backend architecture
- [Backend Setup](apps/backend/docs/development/setup.md) - Backend-specific setup guide
- [Backend Testing](apps/backend/docs/testing/testing-guide.md) - Backend testing guide
- [Backend API Endpoints](apps/backend/docs/api/endpoints/) - Complete backend API documentation
- [Backend API Documentation](apps/backend/docs/api/) - Complete backend API documentation

### 📱 Frontend-Specific Documentation
- [Frontend Documentation Overview](apps/frontend/docs/frontend-documentation-overview.md) - Complete frontend documentation hub
- [Flutter Clean Architecture](apps/frontend/docs/architecture/clean-architecture.md) - Flutter Clean Architecture implementation
- [State Management Guide](apps/frontend/docs/architecture/state-management.md) - Riverpod state management patterns
- [Error Handling Architecture](apps/frontend/docs/architecture/error-handling.md) - Comprehensive error handling system
- [Flutter Setup Guide](apps/frontend/docs/development/setup.md) - Complete Flutter development setup
- [Localization Guide](apps/frontend/docs/development/localization-guide.md) - Multi-language support with ARB files
- [Navigation Guide](apps/frontend/docs/development/navigation-guide.md) - GoRouter navigation patterns
- [Performance Guide](apps/frontend/docs/development/performance-guide.md) - Performance optimization strategies
- [Deployment Guide](apps/frontend/docs/development/deployment-guide.md) - Build and deploy across platforms
- [Flutter Testing Guide](apps/frontend/docs/testing/testing-guide.md) - Comprehensive Flutter testing strategy
- [Test Tagging Guide](apps/frontend/docs/testing/test-tagging-guide.md) - Advanced test organization and execution
- [Design System](apps/frontend/docs/ui/design-system.md) - Material Design implementation and UI components
- [Loading Widgets](apps/frontend/docs/ui/loading-widgets.md) - Shared loading components and scenarios
- [API Integration Guide](apps/frontend/docs/api/api-integration.md) - Backend API communication patterns

## 🛠️ Available Scripts

### Development
```bash
npm run dev              # Start both backend and frontend
npm run dev:backend      # Start backend only
npm run dev:frontend     # Start frontend only
```

### Building
```bash
npm run build            # Build both backend and frontend
npm run build:backend    # Build backend only
npm run build:frontend   # Build frontend only
```

### Testing
```bash
npm run test:backend     # Run backend tests
npm run test:frontend    # Run frontend tests
```

### Database
```bash
npm run start:db         # Start PostgreSQL database
npm run stop:db          # Stop database
npm run reset:db         # Reset database (removes all data)
```

### Documentation
```bash
npm run docs:build       # Build all shared documentation
npm run docs:serve       # Serve shared documentation locally
npm run docs:architecture # View architecture documentation
npm run docs:development # View development documentation
npm run docs:api         # View API documentation
```

### Utilities
```bash
npm run lint:backend     # Lint backend code
npm run clean            # Clean all build artifacts
npm run setup            # Initial project setup
```

### Code Quality Checkers
   ```bash
# Framework compliance checkers
npm run check:framework:backend     # Check backend framework compliance
npm run check:framework:frontend    # Check Flutter framework compliance
npm run check:framework:watch       # Watch backend for changes
npm run check:framework:frontend:watch # Watch frontend for changes
npm run check:all                   # Run all framework checkers

# Hardcoded content checkers
npm run check:hardcoded:frontend    # Check for hardcoded text/styling
npm run check:hardcoded:frontend:watch # Watch for hardcoded violations
```

## 🔍 Code Quality Checkers

This project includes automated checkers to maintain code quality and enforce design patterns.

### Framework Compliance Checkers

#### Backend Framework Checker
   ```bash
# Check backend code for framework compliance
npm run check:framework:backend

# Watch mode - automatically check on file changes
npm run check:framework:watch

# Check specific path
npm run check:framework:backend -- apps/backend/src/modules/user
```

**What it checks:**
- Clean Architecture violations
- Generic terminology usage
- Multi-tenancy patterns
- Error handling compliance
- Type safety issues

#### Frontend Framework Checker
   ```bash
# Check Flutter code for framework compliance
npm run check:framework:frontend

# Watch mode - automatically check on file changes
npm run check:framework:frontend:watch

# Check specific path
npm run check:framework:frontend -- apps/frontend/lib/features/home
```

**What it checks:**
- Clean Architecture patterns
- State management compliance
- Error handling with FrameworkException
- Multi-tenancy implementation
- Accessibility compliance

### Hardcoded Content Checker

#### Flutter Hardcoded Violations Checker
   ```bash
# Check for hardcoded text and styling
npm run check:hardcoded:frontend

# Watch mode - automatically check on file changes
npm run check:hardcoded:frontend:watch

# Check specific path
npm run check:hardcoded:frontend -- apps/frontend/lib/features/home
```

**What it checks:**
- Hardcoded user-facing text (should be in ARB files)
- Hardcoded colors (should use theme colors)
- Hardcoded sizes (should use AppStyles constants)
- Missing localization imports
- Direct styling instead of theme-based styling

### Checker Output

All checkers provide detailed output with:
- **File locations** and line numbers
- **Violation types** (ERROR, WARNING, INFO)
- **Specific suggestions** for fixes
- **Code snippets** showing the issue
- **Summary statistics** (total violations, warnings, etc.)

### Integration with Development

The checkers are designed to be run:
- **During development** - Use watch mode for real-time feedback
- **Before commits** - Run all checkers to ensure compliance
- **In CI/CD** - Automated checking in GitHub Actions
- **Code reviews** - Verify compliance before merging

## 🎯 Key Features

### ✅ SaaS Framework
- **Reusable**: Works for any SaaS business domain
- **Multi-tenant**: Built-in tenant isolation and management
- **Scalable**: Clean Architecture patterns for enterprise growth
- **Type-safe**: Strict TypeScript throughout
- **Production-ready**: Comprehensive error handling and monitoring

### ✅ Backend Features
- **Clean Architecture**: Domain, Application, Infrastructure, Presentation
- **Multi-tenancy**: Generic tenant management
- **Event-driven**: Domain events and event bus
- **Comprehensive Logging**: Structured logging with context
- **API Validation**: DTO validation with class-validator
- **Error Handling**: Global exception filters
- **Testing**: Unit and integration test framework

### ✅ Frontend Features
- **Cross-platform**: Mobile and web support
- **State Management**: Provider/Riverpod patterns
- **Responsive Design**: Material Design 3
- **Generic Components**: Reusable UI components
- **Loading System**: Smooth transitions with localization support
- **API Integration**: Type-safe API client

## 🏢 Multi-tenancy

This framework is designed for SaaS applications:
- **Tenant Isolation**: Complete data separation by tenant
- **Scalable Multi-tenancy**: Support for unlimited SaaS customers
- **Secure**: Proper tenant context validation and access control
- **Subscription-ready**: Built for SaaS billing and subscription models

## 🔧 Technology Stack

### Backend
- **Framework**: NestJS with Fastify
- **Language**: TypeScript (strict mode)
- **Database**: PostgreSQL with TypeORM
- **Validation**: class-validator + class-transformer
- **Testing**: Jest + Testcontainers
- **Logging**: Custom LoggerService

### Frontend
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider/Riverpod
- **UI**: Material Design 3
- **Testing**: Flutter Test

### DevOps
- **Containerization**: Docker + Docker Compose
- **Database**: PostgreSQL
- **CI/CD**: GitHub Actions (planned)

## 📁 Project Structure

```
saas-framework/
├── apps/
│   ├── backend/                 # NestJS API
│   │   ├── src/
│   │   │   ├── core/           # Domain layer
│   │   │   ├── application/    # Application layer
│   │   │   ├── infrastructure/ # Infrastructure layer
│   │   │   ├── presentation/   # Presentation layer
│   │   │   └── common/         # Shared utilities
│   │   ├── test/               # Backend tests
│   │   └── .cursorrules        # Backend development rules
│   └── frontend/               # Flutter app
│       ├── lib/
│       ├── test/
│       └── .cursorrules        # Frontend development rules
├── docs/                       # Documentation
├── docker/                     # Docker configuration
│   ├── docker-compose.yml     # Docker services
│   └── Dockerfile.backend     # Backend container
├── package.json                # Root package.json
└── .cursorrules               # Project-wide rules
```

## 🤝 Contributing

1. Read the [Contributing Guidelines](docs/development/contributing.md)
2. Follow the [Backend Development Rules](apps/backend/.cursorrules)
3. Follow the [Frontend Development Rules](apps/frontend/.cursorrules)
4. Write tests for new features
5. Update documentation as needed

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: Check the [docs/](docs/) directory
- **Issues**: Create a GitHub issue
- **Discussions**: Use GitHub Discussions for questions

---

**Built with ❤️ for scalable, multi-tenant SaaS applications**