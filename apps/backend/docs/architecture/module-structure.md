# Module Structure

This document describes how modules are organized and structured in the backend framework.

## 🏗️ Module Organization

### Core Modules
The backend follows a modular architecture where each module represents a specific domain or functionality:

```
src/modules/
├── auth/                    # Authentication module
├── tenant/                  # Tenant management module
├── user/                    # User management module
├── product/                 # Product management module
├── subscription/            # Subscription management module
├── analytics/               # Analytics module
├── health/                  # Health check module
├── media/                   # Media management module
└── notification/            # Notification module
```

### Module Structure Pattern
Each module follows a consistent structure:

```
module-name/
├── module-name.module.ts    # Module definition
├── controllers/             # REST controllers
│   └── module-name.controller.ts
├── services/                # Business logic services
│   └── module-name.service.ts
├── dto/                     # Data Transfer Objects
│   ├── create-module-name.dto.ts
│   ├── update-module-name.dto.ts
│   └── module-name.dto.ts
├── entities/                # Domain entities
│   └── module-name.entity.ts
├── repositories/            # Data access layer
│   └── module-name.repository.ts
└── tests/                   # Module-specific tests
    ├── unit/
    └── integration/
```

## 🔧 Module Definition Pattern

### Basic Module Structure
```typescript
// module-name.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ModuleNameController } from './controllers/module-name.controller';
import { ModuleNameService } from './services/module-name.service';
import { ModuleNameRepository } from './repositories/module-name.repository';
import { ModuleNameEntity } from './entities/module-name.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([ModuleNameEntity]),
  ],
  controllers: [ModuleNameController],
  providers: [
    ModuleNameService,
    {
      provide: 'IModuleNameRepository',
      useClass: ModuleNameRepository,
    },
  ],
  exports: [ModuleNameService],
})
export class ModuleNameModule {}
```

### Module Dependencies
Modules can depend on other modules through imports:

```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([ModuleNameEntity]),
    TenantModule, // Import tenant module for multi-tenancy
    UserModule,   // Import user module for user context
  ],
  // ... rest of module definition
})
export class ModuleNameModule {}
```

## 🏢 Multi-tenant Module Pattern

### Tenant-aware Modules
All modules should be designed with multi-tenancy in mind:

```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([ModuleNameEntity]),
    TenantModule, // Required for tenant context
  ],
  controllers: [ModuleNameController],
  providers: [
    ModuleNameService,
    {
      provide: 'IModuleNameRepository',
      useClass: ModuleNameRepository,
    },
  ],
  exports: [ModuleNameService],
})
export class ModuleNameModule {}
```

### Tenant Context Injection
Services should inject tenant context:

```typescript
@Injectable()
export class ModuleNameService {
  constructor(
    @Inject('IModuleNameRepository')
    private readonly repository: IModuleNameRepository,
    private readonly tenantService: TenantService,
  ) {}

  async create(dto: CreateModuleNameDto, tenantId: string): Promise<ModuleName> {
    // Validate tenant access
    await this.tenantService.validateTenantAccess(tenantId);
    
    // Create entity with tenant context
    const entity = new ModuleNameEntity();
    entity.tenantId = tenantId;
    // ... set other properties
    
    return this.repository.create(entity);
  }
}
```

## 📊 Module Communication

### Inter-module Communication
Modules communicate through:

1. **Service Injection**: Direct service injection
2. **Event Bus**: Domain events for loose coupling
3. **Shared Services**: Common services in the `common/` directory

### Service Injection Example
```typescript
// In ModuleNameService
constructor(
  private readonly userService: UserService, // Injected from UserModule
  private readonly tenantService: TenantService, // Injected from TenantModule
) {}
```

### Event Bus Communication
```typescript
// Publishing events
@Injectable()
export class ModuleNameService {
  constructor(
    private readonly eventBus: EventBus,
  ) {}

  async create(dto: CreateModuleNameDto): Promise<ModuleName> {
    const entity = await this.repository.create(dto);
    
    // Publish domain event
    await this.eventBus.publish(new ModuleNameCreatedEvent(entity));
    
    return entity;
  }
}

// Handling events
@EventHandler(ModuleNameCreatedEvent)
export class ModuleNameCreatedHandler {
  async handle(event: ModuleNameCreatedEvent): Promise<void> {
    // Handle the event
  }
}
```

## 🔒 Module Security

### Authentication and Authorization
Each module should implement proper security:

```typescript
@Controller('module-name')
@UseGuards(AuthGuard, TenantGuard) // Apply guards
export class ModuleNameController {
  @Post()
  @Roles('admin', 'user') // Role-based access
  async create(
    @Body() dto: CreateModuleNameDto,
    @CurrentTenant() tenantId: string,
    @CurrentUser() user: User,
  ): Promise<ModuleName> {
    return this.service.create(dto, tenantId, user.id);
  }
}
```

### Input Validation
All modules should validate inputs:

```typescript
export class CreateModuleNameDto {
  @IsString()
  @IsNotEmpty()
  @Length(1, 100)
  name!: string;

  @IsString()
  @IsOptional()
  @Length(0, 500)
  description?: string;

  @IsUUID()
  tenantId!: string;
}
```

## 🧪 Module Testing

### Unit Testing
Each module should have comprehensive unit tests:

```typescript
// module-name.service.test.ts
describe('ModuleNameService', () => {
  let service: ModuleNameService;
  let repository: jest.Mocked<IModuleNameRepository>;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ModuleNameService,
        {
          provide: 'IModuleNameRepository',
          useValue: createMock<IModuleNameRepository>(),
        },
      ],
    }).compile();

    service = module.get<ModuleNameService>(ModuleNameService);
    repository = module.get('IModuleNameRepository');
  });

  it('should create module name', async () => {
    const dto = { name: 'Test Name', tenantId: 'tenant-123' };
    const expectedEntity = { id: 'entity-123', ...dto };

    repository.create.mockResolvedValue(expectedEntity as ModuleName);

    const result = await service.create(dto, 'tenant-123');

    expect(result).toEqual(expectedEntity);
    expect(repository.create).toHaveBeenCalledWith(
      expect.objectContaining(dto)
    );
  });
});
```

### Integration Testing
Test module interactions:

```typescript
// module-name.integration.test.ts
describe('ModuleNameController (Integration)', () => {
  let app: INestApplication;
  let repository: TypeOrmModuleNameRepository;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    repository = moduleFixture.get<TypeOrmModuleNameRepository>(TypeOrmModuleNameRepository);
  });

  afterAll(async () => {
    await app.close();
  });

  it('should create module name via API', async () => {
    const dto = { name: 'Test Name' };

    const response = await request(app.getHttpServer())
      .post('/module-name')
      .send(dto)
      .set('x-tenant-slug', 'test-tenant')
      .expect(201);

    expect(response.body).toHaveProperty('id');
    expect(response.body.name).toBe('Test Name');
  });
});
```

## 📈 Module Performance

### Lazy Loading
Modules can be lazy-loaded for better performance:

```typescript
// app.module.ts
@Module({
  imports: [
    // Lazy load modules
    LazyModuleLoader.forRoot({
      imports: [
        ModuleNameModule,
        AnotherModule,
      ],
    }),
  ],
})
export class AppModule {}
```

### Caching
Implement caching at module level:

```typescript
@Injectable()
export class ModuleNameService {
  constructor(
    @Inject('IModuleNameRepository')
    private readonly repository: IModuleNameRepository,
    @Inject('CACHE_MANAGER')
    private readonly cacheManager: Cache,
  ) {}

  @Cacheable('module-name', 300) // 5 minutes cache
  async findById(id: string): Promise<ModuleName | null> {
    return this.repository.findById(id);
  }
}
```

## 🔄 Module Lifecycle

### Module Initialization
Modules are initialized in dependency order:

1. **Core modules** (entities, repositories)
2. **Infrastructure modules** (database, external services)
3. **Application modules** (services, use cases)
4. **Presentation modules** (controllers, middleware)

### Module Destruction
Modules are destroyed in reverse order:

1. **Presentation modules**
2. **Application modules**
3. **Infrastructure modules**
4. **Core modules**

## 🎯 Best Practices

### Module Design
- ✅ Keep modules focused and cohesive
- ✅ Minimize inter-module dependencies
- ✅ Use interfaces for module boundaries
- ✅ Implement proper error handling
- ✅ Add comprehensive logging

### Module Testing
- ✅ Write unit tests for all services
- ✅ Write integration tests for controllers
- ✅ Test error scenarios
- ✅ Mock external dependencies
- ✅ Test multi-tenant scenarios

### Module Documentation
- ✅ Document module purpose and responsibilities
- ✅ Document module dependencies
- ✅ Document API endpoints
- ✅ Document configuration options
- ✅ Update documentation when changing modules

## 📚 Related Documentation

- [Clean Architecture](clean-architecture.md) - Overall architecture patterns
- [Multi-tenancy](multi-tenancy.md) - Tenant architecture
- [Dependency Injection](dependency-injection.md) - DI patterns
- [API Reference](../api-reference/) - Auto-generated code documentation
