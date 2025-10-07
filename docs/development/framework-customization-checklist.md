# Framework Customization Checklist

This document provides a comprehensive list of all entities, classes, and documentation that need to be updated or deleted when customizing the generic framework for a specific business project.

## 🚨 Critical Priority (Must Update/Delete)

### **Backend Entities & Classes**

#### **Sample Entities (DELETE)**
- **`apps/backend/src/core/entities/sample.entity.ts`** - DELETE (example entity)
- **`apps/backend/src/application/dto/sample-entity.dto.ts`** - DELETE (example DTOs)
- **`apps/backend/src/application/use-cases/sample-entity.use-case.ts`** - DELETE (example use case)
- **`apps/backend/src/infrastructure/repositories/sample-entity.repository.ts`** - DELETE (example repository)
- **`apps/backend/src/presentation/controllers/sample-entity.controller.ts`** - DELETE (example controller)
- **`apps/backend/src/presentation/modules/sample-entity.module.ts`** - DELETE (example module)

#### **Frontend Entities & Classes**

#### **Sample Entities (DELETE)**
- **`apps/frontend/lib/features/home/domain/entities/sample_entity.dart`** - DELETE (example entity)
- **`apps/frontend/lib/features/home/data/models/sample_entity_model.dart`** - DELETE (example model)
- **`apps/frontend/lib/features/home/data/repositories/sample_entity_repository.dart`** - DELETE (example repository)
- **`apps/frontend/lib/features/home/data/datasources/sample_entity_remote_datasource.dart`** - DELETE (example remote datasource)
- **`apps/frontend/lib/features/home/data/datasources/sample_entity_local_datasource.dart`** - DELETE (example local datasource)
- **`apps/frontend/lib/features/home/data/mappers/sample_entity_mapper.dart`** - DELETE (example mapper)
- **`apps/frontend/lib/features/home/domain/repositories/sample_entity_repository_interface.dart`** - DELETE (example interface)

#### **Sample Controllers & Screens (DELETE)**
- **`apps/frontend/lib/features/home/presentation/controllers/home_controller.dart`** - DELETE (contains SampleEntity references)
- **`apps/frontend/lib/features/home/presentation/screens/home_screen.dart`** - DELETE (contains SampleEntity references)
- **`apps/frontend/lib/features/home/presentation/widgets/home_widgets.dart`** - DELETE (contains SampleEntity references)

### **Documentation Files (UPDATE)**

#### **Database Documentation**
- **`docs/database/entities/sample-entity.md`** - DELETE (example entity documentation)
- **`docs/database/schema-overview.md`** - UPDATE (remove SampleEntity references)
- **`docs/database/relationships/entity-relationships.md`** - UPDATE (remove SampleEntity relationships)
- **`docs/database/relationships/foreign-keys.md`** - UPDATE (remove SampleEntity foreign keys)
- **`docs/database/migrations/migration-history.md`** - UPDATE (remove SampleEntity migrations)
- **`docs/database/diagrams/erd-diagram.md`** - UPDATE (remove SampleEntity from diagrams)
- **`docs/database/diagrams/schema-diagram.md`** - UPDATE (remove SampleEntity from schema)

#### **API Documentation**
- **`docs/api/entity-apis.md`** - UPDATE (remove SampleEntity API examples)
- **`apps/backend/docs/api/endpoints/entity-endpoints.md`** - UPDATE (remove SampleEntity endpoints)

#### **Frontend Documentation**
- **`apps/frontend/docs/architecture/clean-architecture.md`** - UPDATE (remove SampleEntity examples)
- **`apps/frontend/docs/architecture/state-management.md`** - UPDATE (remove SampleEntity examples)
- **`apps/frontend/docs/testing/testing-guide.md`** - UPDATE (remove SampleEntity test examples)
- **`apps/frontend/docs/testing/test-tagging-guide.md`** - UPDATE (remove SampleEntity test examples)

## 🔄 Medium Priority (Update Content)

### **Configuration Files**

#### **Backend Configuration**
- **`apps/backend/src/config/database.config.ts`** - UPDATE (database name, connection settings)
- **`apps/backend/src/config/app.config.ts`** - UPDATE (app name, description)
- **`apps/backend/package.json`** - UPDATE (name, description, keywords)

#### **Frontend Configuration**
- **`apps/frontend/pubspec.yaml`** - UPDATE (name, description, applicationId)
- **`apps/frontend/lib/l10n/app_en.arb`** - UPDATE (all text content)
- **`apps/frontend/lib/core/config/bootstrap.dart`** - UPDATE (app initialization)

#### **Platform Configuration**
- **`apps/frontend/android/app/src/main/AndroidManifest.xml`** - UPDATE (app name, package)
- **`apps/frontend/ios/Runner/Info.plist`** - UPDATE (app name, bundle identifier)
- **`apps/frontend/web/index.html`** - UPDATE (title, meta tags)
- **`apps/frontend/windows/runner/main.cpp`** - UPDATE (app name)

### **Docker Configuration**
- **`docker/docker-compose.yml`** - UPDATE (container names, database name, network names)
- **`docker/Dockerfile.backend`** - UPDATE (if needed for specific requirements)

### **Project Configuration**
- **`package.json`** - UPDATE (name, description, keywords)
- **`README.md`** - UPDATE (project name, description, all references)

## 📝 Low Priority (Update References)

### **Documentation References**
- **`docs/development/project-customization-checklist.md`** - UPDATE (this file with project-specific examples)
- **`docs/development/development-setup.md`** - UPDATE (project-specific setup instructions)
- **`docs/architecture/monorepo-architecture.md`** - UPDATE (project-specific architecture examples)

### **Test Files**
- **`apps/frontend/test/features/home/domain/entities/sample_entity_test.dart`** - DELETE (example tests)
- **`apps/frontend/test/features/home/data/repositories/sample_entity_repository_test.dart`** - DELETE (example tests)
- **`apps/frontend/test/features/home/presentation/controllers/home_controller_test.dart`** - DELETE (example tests)
- **`apps/frontend/test/features/home/presentation/screens/home_screen_test.dart`** - DELETE (example tests)

### **Framework Checker Scripts**
- **`scripts/backend/check-framework-violations.ts`** - UPDATE (configure business terms)
- **`scripts/frontend/check-framework-violations.ts`** - UPDATE (configure business terms)

## 🎯 Framework Classes (KEEP - These are Generic)

### **Backend Framework Classes (KEEP)**
- **`apps/backend/src/core/entities/base.entity.ts`** - KEEP (generic base entity)
- **`apps/backend/src/core/entities/tenant.entity.ts`** - KEEP (generic tenant entity)
- **`apps/backend/src/core/repositories/base.repository.ts`** - KEEP (generic repository)
- **`apps/backend/src/infrastructure/database/typeorm.repository.ts`** - KEEP (generic TypeORM repository)
- **`apps/backend/src/application/dto/base.dto.ts`** - KEEP (generic DTOs)
- **`apps/backend/src/application/use-cases/base.use-case.ts`** - KEEP (generic use case)
- **`apps/backend/src/common/base.service.ts`** - KEEP (generic service)
- **`apps/backend/src/common/filters/global-exception.filter.ts`** - KEEP (generic error handling)
- **`apps/backend/src/common/interceptors/`** - KEEP (generic interceptors)

### **Frontend Framework Classes (KEEP)**
- **`apps/frontend/lib/core/entities/tenant_entity.dart`** - KEEP (generic tenant entity)
- **`apps/frontend/lib/core/error/error_boundary.dart`** - KEEP (generic error handling)
- **`apps/frontend/lib/core/error/error_handler.dart`** - KEEP (generic error handling)
- **`apps/frontend/lib/core/exceptions/framework_exception.dart`** - KEEP (generic exception)
- **`apps/frontend/lib/core/routing/app_router.dart`** - KEEP (generic routing)
- **`apps/frontend/lib/core/services/tenant_context_service.dart`** - KEEP (generic tenant service)
- **`apps/frontend/lib/ui/widgets/`** - KEEP (generic UI widgets)
- **`apps/frontend/lib/ui/styles/app_styles.dart`** - KEEP (generic styling)

## 🔧 Customization Steps

### **Step 1: Delete Sample Entities**
1. Delete all SampleEntity files from backend and frontend
2. Remove SampleEntity references from modules and imports
3. Update app.module.ts to remove sample entity modules

### **Step 2: Update Configuration**
1. Update all configuration files with project-specific values
2. Update Docker configuration with project names
3. Update package.json and pubspec.yaml

### **Step 3: Update Documentation**
1. Delete sample entity documentation
2. Update all documentation with project-specific examples
3. Update database diagrams and relationships

### **Step 4: Create Business Entities**
1. Create new entities extending BaseEntity or TenantEntity
2. Create corresponding DTOs, repositories, and controllers
3. Create frontend entities, models, and screens

### **Step 5: Update Tests**
1. Delete sample entity tests
2. Create tests for new business entities
3. Update test configuration if needed

### **Step 6: Configure Framework Checkers**
1. Update business terms in framework checker scripts
2. Test framework compliance with new entities

## ⚠️ Important Notes

### **What NOT to Delete**
- **Base Classes**: BaseEntity, TenantEntity, BaseRepository, etc.
- **Framework Services**: Error handling, logging, routing, etc.
- **Generic UI Components**: Loading widgets, error boundaries, etc.
- **Configuration Framework**: Bootstrap, app configuration, etc.

### **What to Always Update**
- **Project Names**: All references to "Generic Framework"
- **Database Names**: Update to project-specific names
- **Container Names**: Update Docker container names
- **Package Names**: Update application package identifiers

### **Testing After Customization**
1. Run framework compliance checkers
2. Run all tests to ensure nothing is broken
3. Test database migrations
4. Test Docker setup
5. Verify documentation links work

---

**Last Updated**: {{ current_date }}
**Framework Version**: 1.0.0
**Customization Version**: 1.0.0
