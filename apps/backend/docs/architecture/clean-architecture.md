# Clean Architecture

This document describes the Clean Architecture implementation in the backend framework.

## 🏗️ Architecture Overview

The backend follows **Clean Architecture** with clear separation of concerns across four layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  Controllers, Middleware, Decorators, Filters, Guards      │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer                        │
│  Use Cases, DTOs, Interfaces, Application Services         │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                           │
│  Entities, Value Objects, Domain Services, Events          │
├─────────────────────────────────────────────────────────────┤
│                   Infrastructure Layer                      │
│  Database, External Services, Configurations, Messaging    │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Directory Structure

```
apps/backend/src/
├── core/                    # Domain Layer
│   ├── entities/           # Domain entities
│   ├── repositories/       # Repository interfaces
│   ├── services/           # Domain services
│   └── value-objects/      # Value objects
├── application/            # Application Layer
│   ├── dto/               # Data Transfer Objects
│   ├── interfaces/        # Application interfaces
│   ├── services/          # Application services
│   └── use-cases/         # Use cases
├── infrastructure/        # Infrastructure Layer
│   ├── config/           # Configuration
│   ├── database/         # Database implementations
│   ├── external-services/ # External service integrations
│   └── messaging/        # Event messaging
├── presentation/          # Presentation Layer
│   ├── controllers/      # REST controllers
│   ├── decorators/       # Custom decorators
│   ├── filters/          # Exception filters
│   ├── guards/           # Authentication guards
│   ├── interceptors/     # Request/response interceptors
│   └── middleware/       # Custom middleware
└── common/               # Shared utilities
    ├── base/            # Base classes
    ├── dto/             # Common DTOs
    ├── exceptions/      # Custom exceptions
    ├── filters/         # Global filters
    ├── interceptors/    # Global interceptors
    └── services/        # Shared services
```

## 🔄 Layer Responsibilities

### Domain Layer (`core/`)
**Purpose**: Contains the core business logic and rules.

**Components**:
- **Entities**: Core business objects with identity
- **Value Objects**: Immutable objects without identity
- **Domain Services**: Business logic that doesn't belong to entities
- **Repository Interfaces**: Contracts for data access
- **Domain Events**: Events that occur in the domain

**Rules**:
- ✅ No external dependencies
- ✅ Pure business logic
- ✅ No framework-specific code
- ✅ Independent of any framework

### Application Layer (`application/`)
**Purpose**: Orchestrates domain objects and handles use cases.

**Components**:
- **Use Cases**: Application-specific business rules
- **DTOs**: Data transfer objects for API communication
- **Interfaces**: Contracts for external dependencies
- **Application Services**: Orchestration of domain objects

**Rules**:
- ✅ Depends only on Domain layer
- ✅ No framework dependencies
- ✅ Use cases are the entry points
- ✅ DTOs for data validation

### Infrastructure Layer (`infrastructure/`)
**Purpose**: Implements external concerns and technical details.

**Components**:
- **Database**: TypeORM repositories and entities
- **External Services**: Third-party API integrations
- **Configuration**: Environment and app configuration
- **Messaging**: Event publishing and handling

**Rules**:
- ✅ Implements interfaces from Application layer
- ✅ Handles technical concerns
- ✅ Database and external service implementations
- ✅ Framework-specific code

### Presentation Layer (`presentation/`)
**Purpose**: Handles HTTP requests and responses.

**Components**:
- **Controllers**: REST API endpoints
- **Middleware**: Request processing pipeline
- **Guards**: Authentication and authorization
- **Interceptors**: Cross-cutting concerns
- **Filters**: Exception handling

**Rules**:
- ✅ Depends on Application layer
- ✅ Handles HTTP concerns
- ✅ Input validation and transformation
- ✅ Response formatting

## 🏢 Multi-tenancy Architecture

### Tenant Context
Every request includes tenant context:
- **Tenant ID**: Unique identifier for data isolation
- **Tenant Slug**: Human-readable identifier
- **Tenant Validation**: Ensures tenant exists and is active

### Data Isolation
- **Database Level**: All entities include `tenantId`
- **Repository Level**: Automatic tenant filtering
- **Service Level**: Tenant context validation
- **API Level**: Tenant extraction from headers/params

### Tenant Flow
```
Request → Tenant Middleware → Tenant Guard → Service → Repository → Database
   ↓              ↓              ↓           ↓          ↓
Extract      Validate        Check       Filter    Query with
Tenant       Tenant          Access      by        tenantId
Context      Context         Rights      Tenant
```

## 🔧 Key Patterns

### Repository Pattern
```typescript
// Interface in Domain layer
export interface IEntityRepository {
  findById(id: string): Promise<Entity | null>;
  findByTenantId(tenantId: string): Promise<Entity[]>;
  create(entity: Entity): Promise<Entity>;
  update(id: string, entity: Partial<Entity>): Promise<Entity>;
  delete(id: string): Promise<void>;
}

// Implementation in Infrastructure layer
export class TypeOrmEntityRepository implements IEntityRepository {
  // Implementation details
}
```

### Use Case Pattern
```typescript
export class CreateEntityUseCase {
  constructor(
    private readonly entityRepository: IEntityRepository,
    private readonly eventBus: IEventBus,
  ) {}

  async execute(dto: CreateEntityDto, tenantId: string): Promise<Entity> {
    // Business logic
    const entity = Entity.create(dto);
    const savedEntity = await this.entityRepository.create(entity);
    
    // Publish domain event
    await this.eventBus.publish(new EntityCreatedEvent(savedEntity));
    
    return savedEntity;
  }
}
```

### Event-Driven Architecture
```typescript
// Domain Event
export class EntityCreatedEvent {
  constructor(public readonly entity: Entity) {}
}

// Event Handler
@EventHandler(EntityCreatedEvent)
export class EntityCreatedHandler {
  async handle(event: EntityCreatedEvent): Promise<void> {
    // Handle the event (e.g., send notifications, update caches)
  }
}
```

## 📊 Logging Architecture

### Structured Logging
```typescript
// Context-aware logging
this.logger.log('Entity created', {
  entityId: entity.id,
  tenantId: tenantId,
  userId: userId,
  action: 'create_entity'
});
```

### Log Levels
- **Error**: System errors and exceptions
- **Warn**: Warning conditions
- **Info**: General information
- **Debug**: Detailed debugging information
- **Verbose**: Very detailed information

### Log Context
- **Request ID**: Unique request identifier
- **Tenant ID**: Tenant context
- **User ID**: User context
- **Action**: Business action performed
- **Duration**: Operation timing

## 🧪 Testing Architecture

### Test Types
- **Unit Tests**: Individual components in isolation
- **Integration Tests**: Component interactions
- **E2E Tests**: Full application flow

### Test Structure
```
test/
├── unit/                 # Unit tests
│   ├── services/        # Service tests
│   ├── use-cases/       # Use case tests
│   └── entities/        # Entity tests
├── integration/         # Integration tests
│   ├── repositories/    # Repository tests
│   ├── controllers/     # Controller tests
│   └── services/        # Service integration tests
└── config/             # Test configuration
    ├── jest.setup.unit.ts
    └── jest.setup.integration.ts
```

## 🚀 Performance Considerations

### Database Optimization
- **Indexing**: Proper database indexes
- **Query Optimization**: Efficient queries
- **Connection Pooling**: Database connection management
- **Caching**: Redis for frequently accessed data

### API Performance
- **Response Compression**: Gzip compression
- **Rate Limiting**: API rate limiting
- **Caching**: HTTP caching headers
- **Pagination**: Efficient data pagination

## 🔄 Scalability Patterns

### Horizontal Scaling
- **Stateless Design**: No server-side session state
- **Load Balancing**: Multiple server instances
- **Database Sharding**: Tenant-based data partitioning
- **Microservices**: Service decomposition

### Vertical Scaling
- **Resource Optimization**: Efficient resource usage
- **Caching**: Multiple cache layers
- **Database Optimization**: Query and index optimization
- **Memory Management**: Efficient memory usage

## 📈 Monitoring and Observability

### Metrics
- **Application Metrics**: Response times, error rates
- **Business Metrics**: User actions, tenant usage
- **Infrastructure Metrics**: CPU, memory, disk usage

### Logging
- **Structured Logs**: JSON-formatted logs
- **Log Aggregation**: Centralized log collection
- **Log Analysis**: Search and analysis tools

### Tracing
- **Request Tracing**: End-to-end request tracking
- **Performance Tracing**: Operation timing
- **Error Tracing**: Error propagation tracking

## 🎯 Best Practices

### Code Organization
- ✅ Follow Clean Architecture principles
- ✅ Use dependency injection
- ✅ Implement proper error handling
- ✅ Write comprehensive tests
- ✅ Use generic, reusable components

### Performance
- ✅ Optimize database queries
- ✅ Implement proper caching
- ✅ Use efficient algorithms
- ✅ Monitor performance metrics

### Security
- ✅ Validate all inputs
- ✅ Implement proper authentication
- ✅ Use HTTPS in production
- ✅ Regular security audits

### Maintainability
- ✅ Write clear, documented code
- ✅ Use consistent naming conventions
- ✅ Follow SOLID principles
- ✅ Regular code reviews

## 📚 Related Documentation

- [API Reference](../api-reference/) - Auto-generated code documentation
- [Module Structure](module-structure.md) - Module organization
- [Multi-tenancy](multi-tenancy.md) - Tenant architecture
- [Dependency Injection](dependency-injection.md) - DI patterns
