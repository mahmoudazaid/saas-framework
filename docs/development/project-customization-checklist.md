# Project Customization Checklist

This document lists all places in the generic framework that need to be changed when implementing a specific business project.

> **📋 For a comprehensive list of all entities, classes, and documentation that need to be updated or deleted, see: [Framework Customization Checklist](framework-customization-checklist.md)**

## 🎯 **Critical Changes (Must Change)**

### **1. Project Identity & Branding**

#### **Frontend (Flutter)**
- **`apps/frontend/pubspec.yaml`**
  - `name: generic_framework_app` → `name: your_project_app`
- **`apps/frontend/lib/main.dart`**
  - `title: 'Generic Framework'` → `title: 'Your Project Name'`
- **`apps/frontend/lib/l10n/app_en.arb`**
  - `"appTitle": "Generic Framework App"` → `"appTitle": "Your Project App"`
  - `"appSubtitle": "Multi-tenant Application Framework"` → `"appSubtitle": "Your Project Description"`
  - `"welcomeToFramework": "Welcome to Generic Framework"` → `"welcomeToFramework": "Welcome to Your Project"`

#### **Backend (NestJS)**
- **`apps/backend/package.json`**
  - `"name": "generic-framework-backend"` → `"name": "your-project-backend"`
  - `"description": "Generic Framework Backend"` → `"description": "Your Project Backend"`

#### **Root Project**
- **`package.json`**
  - `"name": "gym-manager"` → `"name": "your-project"`
  - `"description": "Gym Manager - Generic Multi-Tenant Framework"` → `"description": "Your Project - Multi-Tenant Application"`

### **2. Database Configuration**

#### **Docker Configuration**
- **`docker/docker-compose.yml`**
  - `POSTGRES_DB: generic_framework` → `POSTGRES_DB: your_project_db`
  - `DB_NAME: generic_framework` → `DB_NAME: your_project_db`
  - `PGADMIN_DEFAULT_EMAIL: admin@genericframework.com` → `PGADMIN_DEFAULT_EMAIL: admin@yourproject.com`

#### **Environment Files**
- **`apps/backend/env.example`**
  - `DATABASE_NAME=generic_framework` → `DATABASE_NAME=your_project_db`
- **`docs/development/development-setup.md`**
  - All database references: `generic_framework` → `your_project_db`

### **3. Container & Service Names**

#### **Docker Configuration**
- **`docker/docker-compose.yml`**
  - `container_name: generic-framework-postgres` → `container_name: your-project-postgres`
  - `container_name: generic-framework-pgadmin` → `container_name: your-project-pgadmin`
  - `container_name: generic-framework-backend` → `container_name: your-project-backend`
  - `generic-framework-network` → `your-project-network`

### **4. Documentation**

#### **Main Documentation**
- **`README.md`**
  - Title: `"Gym Manager - Generic Multi-Tenant Framework"` → `"Your Project - Multi-Tenant Application"`
  - All references to "Generic Framework" → "Your Project"
  - All references to "gym-manager" → "your-project"

#### **Docker Documentation**
- **`docker/README.md`**
  - `"Generic Framework"` → `"Your Project"`
  - All service references and descriptions

### **5. Platform-Specific Configuration**

#### **Android (Flutter)**
- **`apps/frontend/android/app/build.gradle.kts`**
  - `applicationId "com.example.generic_framework_app"` → `applicationId "com.yourcompany.yourproject"`
- **`apps/frontend/android/app/src/main/AndroidManifest.xml`**
  - Package references and app name
- **`apps/frontend/android/app/src/main/kotlin/com/gymmanager/...`**
  - Package structure: `com.gymmanager` → `com.yourcompany.yourproject`

#### **iOS (Flutter)**
- **`apps/frontend/ios/Runner/Info.plist`**
  - `CFBundleDisplayName` and `CFBundleName`
- **`apps/frontend/ios/Runner.xcodeproj/project.pbxproj`**
  - Project references and bundle identifiers

#### **Web (Flutter)**
- **`apps/frontend/web/index.html`**
  - `<title>Generic Framework App</title>` → `<title>Your Project App</title>`
  - Meta descriptions and app names
- **`apps/frontend/web/manifest.json`**
  - `"name": "Generic Framework App"` → `"name": "Your Project App"`
  - `"short_name": "Generic Framework"` → `"short_name": "Your Project"`

#### **Desktop (Flutter)**
- **`apps/frontend/linux/CMakeLists.txt`**
  - Project name references
- **`apps/frontend/windows/CMakeLists.txt`**
  - Project name references
- **`apps/frontend/macos/Runner/Configs/AppInfo.xcconfig`**
  - Bundle identifiers and display names

## 🔧 **Optional Changes (Framework-Specific)**

### **6. Business Domain Terminology**

#### **Multi-Tenancy (Keep Generic)**
- **`tenant`** - Keep as is (generic multi-tenancy concept)
- **`TenantEntity`** - Keep as is (generic base class)
- **`TenantContextService`** - Keep as is (generic service)

#### **Sample Entities (Customize)**
- **`apps/frontend/lib/features/home/domain/entities/sample_entity.dart`**
  - Rename to your business entity (e.g., `product_entity.dart`)
  - Update entity properties to match your business domain
- **`apps/frontend/lib/features/home/presentation/controllers/home_controller.dart`**
  - Update to work with your business entities
- **`apps/frontend/lib/features/home/presentation/screens/home_screen.dart`**
  - Update UI to display your business data

### **7. Backend Modules (Customize)**

#### **Generic Modules (Keep)**
- **`tenant`** - Keep as is (generic multi-tenancy)
- **`health`** - Keep as is (generic health checks)
- **`logger`** - Keep as is (generic logging)

#### **Business Modules (Customize)**
- **`apps/backend/src/modules/`**
  - Replace generic modules with your business modules
  - Update module names and functionality
  - Update DTOs, entities, and services

### **8. Localization (Customize)**

#### **ARB Files**
- **`apps/frontend/lib/l10n/app_en.arb`**
  - Update all user-facing text to match your business domain
  - Add business-specific terminology
  - Update error messages and UI text

### **9. Framework Checkers (Customize)**

#### **Frontend Framework Checker**
- **`scripts/frontend/check-framework-violations.ts`**
  - Update `businessTerms` array with your business-specific terms
  - Add terms that should be avoided in your domain
  - Example: `['product', 'order', 'customer', 'inventory', 'sales']`

#### **Backend Framework Checker**
- **`scripts/backend/check-framework-violations.ts`**
  - Update `businessTerms` array with your business-specific terms
  - Add terms that should be avoided in your domain
  - Example: `['product', 'order', 'customer', 'inventory', 'sales']`

## 📋 **Change Priority**

### **🔴 High Priority (Must Change)**
1. Project identity and branding
2. Database configuration
3. Container names
4. Platform-specific configuration
5. Main documentation

### **🟡 Medium Priority (Should Change)**
1. Business domain terminology
2. Sample entities and controllers
3. Backend business modules
4. Localization content

### **🟢 Low Priority (Optional)**
1. Framework-specific terminology
2. Generic service names
3. Multi-tenancy concepts

## 🚀 **Automated Setup Script**

The framework includes a comprehensive setup script that handles all customization automatically:

```bash
# Run the complete setup and customization script
./setup.sh

# Or update Node.js versions in configuration files only
./setup.sh --update-node

# Show help and available options
./setup.sh --help
```

This script will:
1. ✅ Check and install all prerequisites (Node.js, Flutter, Docker)
2. ✅ **Automatically manage Node.js versions** (latest LTS or user-specified)
3. ✅ **Update all configuration files** with correct Node.js versions
4. ✅ Prompt for project details (name, description, package, etc.)
5. ✅ Customize all project files automatically
6. ✅ Remove git connection to framework repository
7. ✅ Check and update outdated dependencies
8. ✅ Install all dependencies
9. ✅ Set up environment configuration
10. ✅ Start the database

### **Manual Customization (Alternative)**

If you prefer to customize manually, follow the detailed checklist below:

## 📚 **Related Documentation**

- [Development Setup](development-setup.md)
- [Monorepo Architecture](../architecture/monorepo-architecture.md)
- [Backend Setup](../../apps/backend/docs/development/setup.md)
- [Frontend Setup](../../apps/frontend/docs/development/setup.md)
