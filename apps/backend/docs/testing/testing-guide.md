# Backend Testing Guide

This document provides a comprehensive guide for testing the backend framework.

## 🧪 Testing Strategy

### Test Pyramid
We follow the test pyramid approach with three levels:

```
    /\
   /  \     E2E Tests (Few)
  /____\    
 /      \   Integration Tests (Some)
/________\  
            Unit Tests (Many)
```

### Testing Principles
- **Fast**: Unit tests should run quickly
- **Reliable**: Tests should be deterministic
- **Isolated**: Tests should not depend on each other
- **Comprehensive**: Cover all critical paths
- **Maintainable**: Easy to understand and update

## 📁 Test Structure

### Directory Organization
```
test/
├── unit/                    # Unit tests
│   ├── entities/           # Entity tests
│   ├── services/           # Service tests
│   ├── use-cases/          # Use case tests
│   └── utilities/          # Utility tests
├── integration/            # Integration tests
│   ├── repositories/       # Repository tests
│   ├── controllers/        # Controller tests
│   └── services/           # Service integration tests
├── e2e/                   # End-to-end tests
│   ├── api/               # API tests
│   └── workflows/         # Workflow tests
└── config/                # Test configuration
    ├── jest.setup.unit.ts
    ├── jest.setup.integration.ts
    └── test-config.ts
```

## 🔧 Test Configuration

### Jest Configuration
```typescript
// jest.config.ts
export default {
  projects: [
    {
      displayName: 'backend-unit',
      testMatch: ['<rootDir>/test/unit/**/*.test.ts'],
      setupFilesAfterEnv: ['<rootDir>/test/config/jest.setup.unit.ts'],
    },
    {
      displayName: 'backend-integration',
      testMatch: ['<rootDir>/test/integration/**/*.test.ts'],
      setupFilesAfterEnv: ['<rootDir>/test/config/jest.setup.integration.ts'],
    },
  ],
};
```

### Unit Test Setup
```typescript
// test/config/jest.setup.unit.ts
import 'reflect-metadata';

// Clear all mocks before each test
beforeEach(() => {
  jest.clearAllMocks();
});

// Global test utilities
global.createMock = <T>(overrides: Partial<T> = {}): T => {
  return {
    ...overrides,
  } as T;
};
```

### Integration Test Setup
```typescript
// test/config/jest.setup.integration.ts
import { DataSource } from 'typeorm';
import { PostgreSqlContainer } from '@testcontainers/postgresql';

let dataSource: DataSource;
let container: PostgreSqlContainer;

beforeAll(async () => {
  // Start test database
  container = await new PostgreSqlContainer('postgres:16-alpine')
    .withDatabase('test_db')
    .withUsername('test')
    .withPassword('test')
    .start();

  // Create data source
  dataSource = new DataSource({
    type: 'postgres',
    url: container.getConnectionUri(),
    entities: [/* entity classes */],
    synchronize: true,
  });

  await dataSource.initialize();
});

afterAll(async () => {
  await dataSource.destroy();
  await container.stop();
});

beforeEach(async () => {
  // Clean database before each test
  await dataSource.synchronize(true);
});
```

## 🧪 Unit Testing

### Entity Testing
Test domain entities and their business logic:

```typescript
// test/unit/entities/entity.test.ts
import { Entity } from '../../../src/core/entities/entity';

describe('Entity', () => {
  it('should create entity with valid data', () => {
    const entity = new Entity();
    entity.name = 'Test Entity';
    entity.tenantId = 'tenant-123';
    
    expect(entity.name).toBe('Test Entity');
    expect(entity.tenantId).toBe('tenant-123');
    expect(entity.id).toBeDefined();
  });
  
  it('should update name correctly', () => {
    const entity = new Entity();
    entity.name = 'Original Name';
    
    entity.updateName('Updated Name');
    
    expect(entity.name).toBe('Updated Name');
    expect(entity.updatedAt).toBeDefined();
  });
  
  it('should validate business rules', () => {
    const entity = new Entity();
    
    expect(() => entity.setInvalidData()).toThrow('Invalid data');
  });
});
```

### Service Testing
Test business logic services:

```typescript
// test/unit/services/entity.service.test.ts
import { Test, TestingModule } from '@nestjs/testing';
import { EntityService } from '../../../src/application/services/entity.service';
import { IEntityRepository } from '../../../src/application/interfaces/repository.interface';
import { createMock } from 'jest-mock-extended';

describe('EntityService', () => {
  let service: EntityService;
  let repository: jest.Mocked<IEntityRepository>;
  
  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EntityService,
        {
          provide: 'IEntityRepository',
          useValue: createMock<IEntityRepository>(),
        },
      ],
    }).compile();
    
    service = module.get<EntityService>(EntityService);
    repository = module.get('IEntityRepository');
  });
  
  it('should create entity', async () => {
    const dto = { name: 'Test Entity', tenantId: 'tenant-123' };
    const expectedEntity = { id: 'entity-123', ...dto };
    
    repository.create.mockResolvedValue(expectedEntity as Entity);
    
    const result = await service.create(dto, 'tenant-123');
    
    expect(result).toEqual(expectedEntity);
    expect(repository.create).toHaveBeenCalledWith(
      expect.objectContaining(dto)
    );
  });
  
  it('should handle creation errors', async () => {
    const dto = { name: 'Test Entity', tenantId: 'tenant-123' };
    const error = new Error('Database error');
    
    repository.create.mockRejectedValue(error);
    
    await expect(service.create(dto, 'tenant-123')).rejects.toThrow('Database error');
  });
});
```

### Use Case Testing
Test application use cases:

```typescript
// test/unit/use-cases/create-entity.use-case.test.ts
import { CreateEntityUseCase } from '../../../src/application/use-cases/create-entity.use-case';
import { IEntityRepository } from '../../../src/application/interfaces/repository.interface';
import { IEventBus } from '../../../src/core/events/event-bus.interface';

describe('CreateEntityUseCase', () => {
  let useCase: CreateEntityUseCase;
  let repository: jest.Mocked<IEntityRepository>;
  let eventBus: jest.Mocked<IEventBus>;
  
  beforeEach(() => {
    repository = createMock<IEntityRepository>();
    eventBus = createMock<IEventBus>();
    useCase = new CreateEntityUseCase(repository, eventBus);
  });
  
  it('should create entity and publish event', async () => {
    const dto = { name: 'Test Entity' };
    const tenantId = 'tenant-123';
    const entity = { id: 'entity-123', ...dto, tenantId };
    
    repository.create.mockResolvedValue(entity as Entity);
    eventBus.publish.mockResolvedValue();
    
    const result = await useCase.execute(dto, tenantId);
    
    expect(result).toEqual(entity);
    expect(repository.create).toHaveBeenCalledWith(
      expect.objectContaining(dto)
    );
    expect(eventBus.publish).toHaveBeenCalledWith(
      expect.objectContaining({ type: 'EntityCreated' })
    );
  });
});
```

## 🔗 Integration Testing

### Repository Testing
Test database operations:

```typescript
// test/integration/repositories/entity.repository.test.ts
import { TypeOrmEntityRepository } from '../../../src/infrastructure/database/typeorm.repository';
import { Entity } from '../../../src/core/entities/entity';
import { DataSource } from 'typeorm';

describe('EntityRepository (Integration)', () => {
  let repository: TypeOrmEntityRepository;
  let dataSource: DataSource;
  
  beforeAll(async () => {
    // Setup test database
    dataSource = await createTestDataSource();
    repository = new TypeOrmEntityRepository(
      dataSource.getRepository(Entity)
    );
  });
  
  afterAll(async () => {
    await dataSource.destroy();
  });
  
  it('should create and find entity', async () => {
    const entity = new Entity();
    entity.name = 'Test Entity';
    entity.tenantId = 'tenant-123';
    
    const created = await repository.create(entity);
    const found = await repository.findById(created.id);
    
    expect(found).toBeDefined();
    expect(found?.name).toBe('Test Entity');
    expect(found?.tenantId).toBe('tenant-123');
  });
  
  it('should find entities by tenant', async () => {
    const tenantId = 'tenant-123';
    
    // Create entities for different tenants
    await repository.create({ name: 'Entity 1', tenantId } as Entity);
    await repository.create({ name: 'Entity 2', tenantId: 'tenant-456' } as Entity);
    
    const tenantEntities = await repository.findByTenantId(tenantId);
    
    expect(tenantEntities).toHaveLength(1);
    expect(tenantEntities[0].name).toBe('Entity 1');
  });
});
```

### Controller Testing
Test API endpoints:

```typescript
// test/integration/controllers/entity.controller.test.ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { AppModule } from '../../../src/app.module';
import * as request from 'supertest';

describe('EntityController (Integration)', () => {
  let app: INestApplication;
  let repository: TypeOrmEntityRepository;
  
  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    
    app = moduleFixture.createNestApplication();
    await app.init();
    
    repository = moduleFixture.get<TypeOrmEntityRepository>(TypeOrmEntityRepository);
  });
  
  afterAll(async () => {
    await app.close();
  });
  
  it('should create entity via API', async () => {
    const dto = { name: 'Test Entity' };
    
    const response = await request(app.getHttpServer())
      .post('/entities')
      .send(dto)
      .set('x-tenant-slug', 'test-tenant')
      .expect(201);
    
    expect(response.body).toHaveProperty('id');
    expect(response.body.name).toBe('Test Entity');
    expect(response.body.tenantId).toBeDefined();
  });
  
  it('should get entities for tenant', async () => {
    const response = await request(app.getHttpServer())
      .get('/entities')
      .set('x-tenant-slug', 'test-tenant')
      .expect(200);
    
    expect(Array.isArray(response.body)).toBe(true);
  });
});
```

## 🚀 End-to-End Testing

### API Workflow Testing
Test complete user workflows:

```typescript
// test/e2e/api/entity-workflow.e2e.test.ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { AppModule } from '../../../src/app.module';
import * as request from 'supertest';

describe('Entity Workflow (E2E)', () => {
  let app: INestApplication;
  
  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    
    app = moduleFixture.createNestApplication();
    await app.init();
  });
  
  afterAll(async () => {
    await app.close();
  });
  
  it('should complete entity lifecycle', async () => {
    const tenantSlug = 'test-tenant';
    const dto = { name: 'Test Entity' };
    
    // Create entity
    const createResponse = await request(app.getHttpServer())
      .post('/entities')
      .send(dto)
      .set('x-tenant-slug', tenantSlug)
      .expect(201);
    
    const entityId = createResponse.body.id;
    
    // Get entity
    const getResponse = await request(app.getHttpServer())
      .get(`/entities/${entityId}`)
      .set('x-tenant-slug', tenantSlug)
      .expect(200);
    
    expect(getResponse.body.name).toBe('Test Entity');
    
    // Update entity
    const updateDto = { name: 'Updated Entity' };
    const updateResponse = await request(app.getHttpServer())
      .put(`/entities/${entityId}`)
      .send(updateDto)
      .set('x-tenant-slug', tenantSlug)
      .expect(200);
    
    expect(updateResponse.body.name).toBe('Updated Entity');
    
    // Delete entity
    await request(app.getHttpServer())
      .delete(`/entities/${entityId}`)
      .set('x-tenant-slug', tenantSlug)
      .expect(200);
  });
});
```

## 🧪 Test Utilities

### Mock Factories
Create reusable mock objects:

```typescript
// test/utils/mock-factory.ts
import { createMock } from 'jest-mock-extended';
import { IEntityRepository } from '../../src/application/interfaces/repository.interface';
import { Entity } from '../../src/core/entities/entity';

export const createMockEntityRepository = (): jest.Mocked<IEntityRepository> => {
  const mock = createMock<IEntityRepository>();
  
  // Setup common mock behaviors
  mock.findById.mockResolvedValue(null);
  mock.findByTenantId.mockResolvedValue([]);
  mock.create.mockImplementation((entity) => Promise.resolve({ ...entity, id: 'mock-id' }));
  
  return mock;
};

export const createMockEntity = (overrides: Partial<Entity> = {}): Entity => {
  return {
    id: 'mock-id',
    name: 'Mock Entity',
    tenantId: 'mock-tenant',
    createdAt: new Date(),
    updatedAt: new Date(),
    isDeleted: false,
    ...overrides,
  } as Entity;
};
```

### Test Data Builders
Build test data with fluent interface:

```typescript
// test/utils/entity-builder.ts
import { Entity } from '../../src/core/entities/entity';

export class EntityBuilder {
  private entity: Partial<Entity> = {};
  
  withId(id: string): EntityBuilder {
    this.entity.id = id;
    return this;
  }
  
  withName(name: string): EntityBuilder {
    this.entity.name = name;
    return this;
  }
  
  withTenantId(tenantId: string): EntityBuilder {
    this.entity.tenantId = tenantId;
    return this;
  }
  
  build(): Entity {
    return {
      id: 'default-id',
      name: 'Default Name',
      tenantId: 'default-tenant',
      createdAt: new Date(),
      updatedAt: new Date(),
      isDeleted: false,
      ...this.entity,
    } as Entity;
  }
}

// Usage
const entity = new EntityBuilder()
  .withName('Test Entity')
  .withTenantId('tenant-123')
  .build();
```

## 📊 Test Coverage

### Coverage Goals & Thresholds
- **Business Logic Only**: Framework files are excluded from coverage
- **Unit Tests**: 90%+ coverage (business modules only)
- **Integration Tests**: 80%+ coverage (business modules only)
- **Global Thresholds** (business logic only):
  - **Lines**: 85%
  - **Functions**: 85%
  - **Branches**: 80%
  - **Statements**: 85%
- **E2E Tests**: Critical paths covered

### Coverage Reports
```bash
# Generate coverage report
npm run test:cov

# Generate coverage report with thresholds
npm run test:cov:threshold

# View coverage in browser
open coverage/lcov-report/index.html
```

### Coverage Exclusions
```typescript
// jest.config.ts
export default {
  collectCoverageFrom: [
    'src/**/*.ts',
    '!**/*.test.ts',
    '!**/*.spec.ts',
    // Exclude framework implementation files
    '!src/common/**/*.ts',
    '!src/core/**/*.ts',
    '!src/infrastructure/**/*.ts',
    '!src/presentation/**/*.ts',
    '!src/application/dto/**/*.ts',
    '!src/application/interfaces/**/*.ts',
    '!src/application/services/**/*.ts',
    '!src/application/use-cases/**/*.ts',
    '!src/config/**/*.ts',
    '!src/main.ts',
    '!src/app.module.ts',
  ],
};
```

**Excluded Framework Files:**
- **Common**: Base classes, utilities, shared services
- **Core**: Domain entities, repositories, services
- **Infrastructure**: Database, external services, messaging
- **Presentation**: Controllers, decorators, guards, middleware
- **Application**: DTOs, interfaces, base services, use cases
- **Config**: Configuration files
- **Main**: Application entry points

## 🚀 Running Tests

### Test Commands
```bash
# Run all tests
npm run test

# Run unit tests only
npm run test:unit

# Run integration tests only
npm run test:integration

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run specific test file
npm run test -- entity.service.test.ts
```

### CI/CD Integration
```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run test:coverage
      - uses: codecov/codecov-action@v3
```

## 🎯 Best Practices

### Test Naming
- Use descriptive test names
- Follow the pattern: "should [expected behavior] when [condition]"
- Group related tests using `describe` blocks

### Test Data
- Use generic test data
- Avoid hardcoded business-specific values
- Create reusable test fixtures

### Test Isolation
- Each test should be independent
- Clean up after each test
- Use mocks for external dependencies

### Test Performance
- Keep unit tests fast (< 100ms each)
- Use parallel test execution
- Optimize database operations in integration tests

### Test Maintenance
- Update tests when code changes
- Remove obsolete tests
- Keep tests simple and readable
- Document complex test scenarios

## 🚨 Common Pitfalls

### ❌ Don't Do
- Test implementation details
- Create flaky tests
- Skip error case testing
- Use real external services in unit tests
- Write tests that depend on each other

### ✅ Do
- Test behavior, not implementation
- Write deterministic tests
- Test both success and error cases
- Use mocks for external dependencies
- Keep tests independent

## 📚 Related Documentation

- [Clean Architecture](../architecture/clean-architecture.md) - Overall architecture patterns
- [Module Structure](../architecture/module-structure.md) - Module organization
- [API Reference](../api-reference/) - Auto-generated code documentation
