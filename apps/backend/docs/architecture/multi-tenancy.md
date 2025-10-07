# Multi-tenancy Architecture

This document describes the multi-tenancy implementation in the backend framework.

## 🏢 Multi-tenancy Overview

The backend framework is designed with **multi-tenancy** as a core architectural principle, allowing a single application instance to serve multiple tenants (organizations) with complete data isolation.

### Key Concepts
- **Tenant**: An organization or customer using the system
- **Tenant ID**: Unique identifier for data isolation
- **Tenant Slug**: Human-readable identifier for URLs
- **Data Isolation**: Complete separation of tenant data
- **Tenant Context**: Information about the current tenant in each request

## 🏗️ Multi-tenancy Architecture

### Tenant Identification
Tenants are identified through multiple sources:

```
Request Sources:
├── HTTP Headers
│   └── x-tenant-slug: acme-corp
├── URL Parameters
│   └── /api/v1/tenants/acme-corp/entities
├── Query Parameters
│   └── ?tenantSlug=acme-corp
└── JWT Token
    └── tenantId: tenant-123
```

### Tenant Context Flow
```
Request → Tenant Middleware → Tenant Guard → Service → Repository → Database
   ↓              ↓              ↓           ↓          ↓
Extract      Validate        Check       Filter    Query with
Tenant       Tenant          Access      by        tenantId
Context      Context         Rights      Tenant
```

## 🔧 Implementation Details

### 1. Tenant Middleware
Extracts tenant information from requests:

```typescript
// src/presentation/middleware/tenant.middleware.ts
@Injectable()
export class TenantMiddleware implements NestMiddleware {
  use(req: Request, _res: Response, next: NextFunction): void {
    // Extract tenant from multiple sources
    const tenantSlug = (req.headers['x-tenant-slug'] as string) ??
                      (req.params['tenantSlug'] as string) ??
                      (req.query['tenantSlug'] as string);

    if (tenantSlug) {
      (req as Request & { tenantSlug?: string }).tenantSlug = tenantSlug;
    }

    next();
  }
}
```

### 2. Tenant Guard
Validates tenant access and context:

```typescript
// src/presentation/guards/tenant.guard.ts
@Injectable()
export class TenantGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request & { tenantSlug?: string }>();
    const tenantSlug = request.tenantSlug;

    if (!tenantSlug) {
      throw new ForbiddenException('Tenant context required');
    }

    // Validate tenant exists and is active
    return this.validateTenant(tenantSlug);
  }
}
```

### 3. Tenant Decorator
Provides easy access to tenant context:

```typescript
// src/presentation/decorators/tenant.decorator.ts
export const CurrentTenant = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string | undefined => {
    const request = ctx.switchToHttp().getRequest<Request & { tenantSlug?: string }>();
    return request.tenantSlug;
  },
);
```

### 4. Tenant Entity
Base class for tenant-aware entities:

```typescript
// src/core/entities/base.entity.ts
export abstract class TenantEntity extends BaseEntity {
  @Column('uuid')
  tenantId!: string;
}
```

## 🗄️ Database Design

### Data Isolation Strategy
All tenant data is isolated at the database level:

```sql
-- All tables include tenantId
CREATE TABLE entities (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  is_deleted BOOLEAN DEFAULT FALSE
);

-- Index for tenant-based queries
CREATE INDEX idx_entities_tenant_id ON entities(tenant_id);
```

### Repository Pattern
Repositories automatically filter by tenant:

```typescript
// src/core/repositories/base.repository.ts
export abstract class BaseRepository<T extends TenantEntity> {
  async findByTenantId(tenantId: string): Promise<T[]> {
    return this.repository.find({
      where: { tenantId, isDeleted: false }
    });
  }

  async findByIdAndTenantId(id: string, tenantId: string): Promise<T | null> {
    return this.repository.findOne({
      where: { id, tenantId, isDeleted: false }
    });
  }
}
```

## 🔒 Security Implementation

### Tenant Validation
Every request validates tenant access:

```typescript
// src/core/services/domain.service.ts
export class TenantService {
  async validateTenantAccess(tenantId: string): Promise<void> {
    const tenant = await this.tenantRepository.findById(tenantId);
    
    if (!tenant) {
      throw new ForbiddenException('Tenant not found');
    }
    
    if (tenant.status !== 'active') {
      throw new ForbiddenException('Tenant is not active');
    }
  }
}
```

### Cross-tenant Protection
Prevents access to other tenants' data:

```typescript
// In service methods
async findById(id: string, tenantId: string): Promise<Entity | null> {
  const entity = await this.repository.findById(id);
  
  if (entity && entity.tenantId !== tenantId) {
    throw new ForbiddenException('Entity not found');
  }
  
  return entity;
}
```

## 🚀 API Design

### Tenant-aware Endpoints
All API endpoints are designed with tenant context:

```typescript
// src/presentation/controllers/base.controller.ts
@Controller('entities')
@UseGuards(TenantGuard)
export class EntityController {
  @Get()
  async findAll(@CurrentTenant() tenantId: string): Promise<Entity[]> {
    return this.service.findByTenantId(tenantId);
  }

  @Post()
  async create(
    @Body() dto: CreateEntityDto,
    @CurrentTenant() tenantId: string,
  ): Promise<Entity> {
    return this.service.create(dto, tenantId);
  }
}
```

### URL Patterns
Support multiple URL patterns for tenant identification:

```
# Header-based
GET /api/v1/entities
Headers: x-tenant-slug: acme-corp

# Path-based
GET /api/v1/tenants/acme-corp/entities

# Query-based
GET /api/v1/entities?tenantSlug=acme-corp
```

## 📊 Logging and Monitoring

### Tenant-aware Logging
All logs include tenant context:

```typescript
// src/common/services/logger.service.ts
export class LoggerService {
  log(message: string, context?: LogContext): void {
    // Context includes tenantId
    this.logger.log(message, {
      tenantId: context?.tenantId,
      userId: context?.userId,
      // ... other context
    });
  }
}
```

### Usage Tracking
Track tenant usage and performance:

```typescript
// Track tenant-specific metrics
this.logger.businessEvent('Entity created', {
  tenantId,
  entityType: 'entity',
  action: 'create',
  duration: 150,
});
```

## 🧪 Testing Multi-tenancy

### Unit Testing
Test tenant isolation in unit tests:

```typescript
describe('EntityService', () => {
  it('should only return entities for specific tenant', async () => {
    const tenant1Id = 'tenant-1';
    const tenant2Id = 'tenant-2';
    
    // Create entities for different tenants
    await service.create({ name: 'Entity 1' }, tenant1Id);
    await service.create({ name: 'Entity 2' }, tenant2Id);
    
    // Query for tenant 1
    const tenant1Entities = await service.findByTenantId(tenant1Id);
    expect(tenant1Entities).toHaveLength(1);
    expect(tenant1Entities[0].name).toBe('Entity 1');
  });
});
```

### Integration Testing
Test tenant context in API calls:

```typescript
describe('EntityController (Integration)', () => {
  it('should create entity with tenant context', async () => {
    const dto = { name: 'Test Entity' };
    
    const response = await request(app.getHttpServer())
      .post('/entities')
      .send(dto)
      .set('x-tenant-slug', 'test-tenant')
      .expect(201);
    
    expect(response.body.tenantId).toBeDefined();
    expect(response.body.name).toBe('Test Entity');
  });
});
```

## 🔄 Tenant Management

### Tenant Creation
Process for creating new tenants:

```typescript
// src/modules/tenant/tenant.service.ts
export class TenantService {
  async createTenant(dto: CreateTenantDto): Promise<Tenant> {
    // Validate tenant data
    await this.validateTenantData(dto);
    
    // Create tenant
    const tenant = new Tenant();
    tenant.slug = dto.slug;
    tenant.name = dto.name;
    tenant.status = 'active';
    
    return this.tenantRepository.create(tenant);
  }
}
```

### Tenant Configuration
Tenant-specific configuration:

```typescript
// src/modules/tenant/tenant-config.service.ts
export class TenantConfigService {
  async getTenantConfig(tenantId: string): Promise<TenantConfig> {
    return this.configRepository.findByTenantId(tenantId);
  }
  
  async updateTenantConfig(tenantId: string, config: Partial<TenantConfig>): Promise<void> {
    await this.configRepository.updateByTenantId(tenantId, config);
  }
}
```

## 📈 Performance Considerations

### Database Optimization
Optimize queries for multi-tenant scenarios:

```sql
-- Composite index for tenant + common queries
CREATE INDEX idx_entities_tenant_status ON entities(tenant_id, status);

-- Partial index for active entities
CREATE INDEX idx_entities_active ON entities(tenant_id) 
WHERE is_deleted = false;
```

### Caching Strategy
Implement tenant-aware caching:

```typescript
// Cache with tenant context
@Cacheable('entities', 300)
async findByTenantId(tenantId: string): Promise<Entity[]> {
  return this.repository.findByTenantId(tenantId);
}

// Cache key includes tenant ID
const cacheKey = `entities:${tenantId}`;
```

## 🚨 Security Best Practices

### Data Isolation
- ✅ Always validate tenant context
- ✅ Use tenant-aware queries
- ✅ Prevent cross-tenant data access
- ✅ Log tenant-specific actions

### Input Validation
- ✅ Validate tenant slugs
- ✅ Sanitize tenant input
- ✅ Check tenant permissions
- ✅ Validate tenant status

### Error Handling
- ✅ Don't expose tenant information in errors
- ✅ Log security violations
- ✅ Implement rate limiting per tenant
- ✅ Monitor suspicious activity

## 🎯 Best Practices

### Development
- ✅ Always include tenant context in service methods
- ✅ Use tenant-aware repositories
- ✅ Validate tenant access
- ✅ Test tenant isolation

### Performance
- ✅ Optimize tenant-based queries
- ✅ Use appropriate indexes
- ✅ Implement tenant-aware caching
- ✅ Monitor tenant-specific metrics

### Security
- ✅ Validate tenant context
- ✅ Prevent data leakage
- ✅ Implement proper access controls
- ✅ Monitor tenant activities

## 📚 Related Documentation

- [Clean Architecture](clean-architecture.md) - Overall architecture patterns
- [Module Structure](module-structure.md) - Module organization
- [API Reference](../api-reference/) - Auto-generated code documentation
- [Security Architecture](security-architecture.md) - Security patterns
