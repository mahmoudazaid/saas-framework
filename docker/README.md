# Docker Configuration

This directory contains all Docker-related configuration files for the SaaS Framework.

## 📁 Files

- **`docker-compose.yml`** - Main Docker Compose configuration
- **`Dockerfile.backend`** - Backend service container definition

## 🚀 Usage

### Quick Start
```bash
# From project root
npm run start:db      # Database only
npm run start:dev     # Full development stack
npm run stop:db       # Stop database
npm run stop:dev      # Stop all services
```

### Manual Commands
```bash
# Database only
docker-compose -f docker/docker-compose.yml up -d

# Full development stack
docker-compose -f docker/docker-compose.yml --profile development up -d

# View logs
docker-compose -f docker/docker-compose.yml logs -f backend

# Stop all services
docker-compose -f docker/docker-compose.yml down
```

## 🏗️ Services

### PostgreSQL
- **Port**: 5432
- **Database**: `saas_framework`
- **User**: `postgres`
- **Password**: `password`

### pgAdmin
- **Port**: 5050
- **Email**: `admin@saasframework.com`
- **Password**: `admin`

### Backend (Development Profile)
- **Port**: 3000
- **Hot Reload**: Enabled
- **Volume Mount**: `./apps/backend:/app`

## 🔧 Configuration

### Build Context
The Docker Compose file uses `context: ..` to build from the project root, allowing access to the `apps/backend` directory.

### Profiles
- **Default**: PostgreSQL + pgAdmin only
- **Development**: Includes backend service with hot reload

### Volumes
- **Database**: `postgres_data` (persistent)
- **Backend**: `./apps/backend:/app` (hot reload)
- **Node Modules**: `/app/node_modules` (performance)

## 🛠️ Development

### Adding New Services
1. Add service definition to `docker-compose.yml`
2. Create Dockerfile if needed
3. Update package.json scripts
4. Update documentation

### Environment Variables
All environment variables are defined in the Docker Compose file. For production, use `.env` files or external configuration.

## 📚 Related Documentation

- [Development Setup](../docs/development/development-setup.md)
- [Monorepo Architecture](../docs/architecture/monorepo-architecture.md)
- [Backend Setup](../apps/backend/docs/development/setup.md)
