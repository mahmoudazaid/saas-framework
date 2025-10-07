# Code Quality Checkers

This document provides comprehensive information about the automated code quality checkers available in this project.

## 📋 Overview

The project includes several automated checkers to maintain code quality and enforce design patterns:

1. **Backend Framework Checker** - Ensures NestJS backend follows Clean Architecture and generic patterns
2. **Frontend Framework Checker** - Ensures Flutter frontend follows Clean Architecture and framework patterns
3. **Hardcoded Content Checker** - Detects hardcoded text and styling violations in Flutter

## 🚀 Quick Start

### Run All Checkers
```bash
# Run all framework compliance checkers
npm run check:all

# Run all checkers including hardcoded content
npm run check:all && npm run check:hardcoded:frontend
```

### Individual Checkers
```bash
# Backend framework compliance
npm run check:framework:backend

# Frontend framework compliance
npm run check:framework:frontend

# Hardcoded content violations
npm run check:hardcoded:frontend
```

## 🔧 Backend Framework Checker

### Purpose
Ensures the NestJS backend follows Clean Architecture principles, uses generic terminology, and implements proper multi-tenancy patterns.

### Usage
```bash
# Check entire backend
npm run check:framework:backend

# Check specific module
npm run check:framework:backend -- apps/backend/src/modules/user

# Watch mode (auto-check on file changes)
npm run check:framework:watch
```

### What It Checks

#### 1. Clean Architecture Violations
- **Business logic in framework code** - Ensures no domain-specific logic in framework
- **Dependency direction** - Verifies dependencies flow inward
- **Layer separation** - Checks proper separation between Domain, Application, Infrastructure, and Presentation

#### 2. Generic Terminology
- **Business-specific terms** - Flags terms like "gym", "member", "class" in framework code
- **Generic alternatives** - Suggests generic terms like "entity", "tenant", "user"
- **Framework patterns** - Ensures consistent use of framework terminology

#### 3. Multi-tenancy Patterns
- **Tenant context** - Verifies proper use of `tenantId` and `tenantSlug`
- **Entity inheritance** - Checks entities extend `BaseEntity` or `TenantEntity`
- **Repository patterns** - Ensures repositories support multi-tenancy

#### 4. Error Handling
- **Async functions** - Verifies all async functions have proper error handling
- **Exception types** - Checks use of appropriate exception types
- **Error logging** - Ensures errors are properly logged

#### 5. Type Safety
- **TypeScript strict mode** - Verifies strict type usage
- **Any types** - Flags inappropriate use of `any` type
- **Type assertions** - Checks for unsafe type assertions

### Sample Output
```
📊 BACKEND FRAMEWORK VIOLATION CHECK RESULTS
================================================================================
📁 Files checked: 45
❌ Violations found: 0
⚠️  Warnings: 0
⏱️  Duration: 234ms

✅ Backend: 100% compliant with framework design patterns!
```

## 🎨 Frontend Framework Checker

### Purpose
Ensures the Flutter frontend follows Clean Architecture principles, proper state management, and framework patterns.

### Usage
```bash
# Check entire frontend
npm run check:framework:frontend

# Check specific feature
npm run check:framework:frontend -- apps/frontend/lib/features/home

# Watch mode (auto-check on file changes)
npm run check:framework:frontend:watch
```

### What It Checks

#### 1. Clean Architecture Patterns
- **Layer separation** - Verifies proper separation between Domain, Application, Infrastructure, and Presentation
- **Dependency direction** - Ensures dependencies flow inward
- **Entity usage** - Checks proper use of domain entities

#### 2. State Management
- **Riverpod patterns** - Verifies proper use of Riverpod providers
- **State notifiers** - Checks state management implementation
- **Provider usage** - Ensures correct provider patterns

#### 3. Error Handling
- **FrameworkException** - Verifies use of custom exception types
- **Error boundaries** - Checks proper error handling in widgets
- **Async operations** - Ensures async functions have error handling

#### 4. Multi-tenancy
- **Tenant context** - Verifies proper use of tenant context
- **Entity inheritance** - Checks entities extend `TenantEntity`
- **Tenant-aware routing** - Ensures routing supports multi-tenancy

#### 5. Accessibility
- **Semantic labels** - Checks for proper accessibility labels
- **Screen reader support** - Verifies accessibility compliance
- **User interaction** - Ensures proper interaction patterns

### Sample Output
```
📊 FRONTEND FRAMEWORK VIOLATION CHECK RESULTS
================================================================================
📁 Files checked: 38
❌ Violations found: 0
⚠️  Warnings: 0
⏱️  Duration: 156ms

✅ Frontend: 100% compliant with framework design patterns!
```

## 🎯 Hardcoded Content Checker

### Purpose
Detects hardcoded text and styling violations in Flutter code to ensure proper localization and theming.

### Usage
```bash
# Check for hardcoded violations
npm run check:hardcoded:frontend

# Watch mode (auto-check on file changes)
npm run check:hardcoded:frontend:watch

# Check specific path
npm run check:hardcoded:frontend -- apps/frontend/lib/features/home
```

### What It Checks

#### 1. Hardcoded Text
- **User-facing strings** - Flags hardcoded text in `Text()` widgets
- **Button labels** - Checks for hardcoded button text
- **Semantic labels** - Verifies accessibility labels are localized
- **Error messages** - Ensures error messages use localization

#### 2. Hardcoded Colors
- **Color constants** - Flags use of `Colors.red`, `Colors.blue`, etc.
- **Theme alternatives** - Suggests theme-based colors
- **Consistent theming** - Ensures proper theme usage

#### 3. Hardcoded Sizes
- **Font sizes** - Flags hardcoded `fontSize` values
- **Dimensions** - Checks for hardcoded `width`, `height` values
- **Spacing** - Verifies use of `AppStyles` constants

#### 4. Missing Localization
- **Import checks** - Verifies `AppLocalizations` imports
- **ARB file usage** - Ensures text comes from ARB files
- **Localization patterns** - Checks proper localization usage

### Sample Output
```
📊 FRONTEND HARDCODED VIOLATION CHECK RESULTS
================================================================================
📁 Files checked: 18
❌ Violations found: 24
⚠️  Warnings: 5
⏱️  Duration: 22ms

📄 apps/frontend/lib/features/home/presentation/screens/home_screen.dart
────────────────────────────────────────────────────────────────────────────────
⚠️ Line 96: Hardcoded color found: color: Colors.grey
   💡 Use theme colors: Theme.of(context).colorScheme.primary
   📝 color: Colors.grey,

ℹ️ Line 80: Hardcoded size found: size: 64
   💡 Use AppStyles constants or theme-based sizing
   📝 size: 64,
```

## 🔄 Watch Mode

All checkers support watch mode for real-time feedback during development:

```bash
# Backend watch mode
npm run check:framework:watch

# Frontend framework watch mode
npm run check:framework:frontend:watch

# Hardcoded content watch mode
npm run check:hardcoded:frontend:watch
```

### Watch Mode Features
- **Automatic re-checking** when files change
- **Fast incremental checking** (only changed files)
- **Real-time feedback** during development
- **Configurable file patterns** (TypeScript, Dart, etc.)

## 🛠️ Configuration

### Checker Configuration
Each checker can be configured by modifying the respective TypeScript files:

- **Backend**: `scripts/backend/check-framework-violations.ts`
- **Frontend**: `scripts/frontend/check-framework-violations.ts`
- **Hardcoded**: `scripts/frontend/check-hardcoded-violations.ts`

### Customization Options
- **Pattern matching** - Modify regex patterns for detection
- **File exclusions** - Add files/directories to skip
- **Violation levels** - Adjust ERROR/WARNING/INFO thresholds
- **Output format** - Customize output formatting

## 🚀 Integration

### Pre-commit Hooks
```bash
# Install pre-commit hook
cp scripts/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### CI/CD Integration
```yaml
# GitHub Actions example
- name: Run Code Quality Checkers
  run: |
    npm run check:all
    npm run check:hardcoded:frontend
```

### IDE Integration
- **VS Code** - Use tasks.json for integrated checking
- **IntelliJ** - Configure external tools for checkers
- **Terminal** - Use watch mode for continuous checking

## 📊 Understanding Output

### Violation Types
- **ERROR** - Critical issues that must be fixed
- **WARNING** - Important issues that should be addressed
- **INFO** - Suggestions for improvement

### Output Format
- **File location** - Exact file and line number
- **Violation description** - What was found
- **Suggestion** - How to fix the issue
- **Code snippet** - Relevant code context

### Statistics
- **Files checked** - Total number of files analyzed
- **Violations found** - Total violations by type
- **Duration** - Time taken to complete check
- **Compliance percentage** - Overall compliance score

## 🔧 Troubleshooting

### Common Issues

#### Checker Not Found
```bash
# Ensure dependencies are installed
npm install

# Check if scripts exist
ls scripts/backend/
ls scripts/frontend/
```

#### TypeScript Errors
```bash
# Install TypeScript dependencies
npm install -D typescript @types/node ts-node

# Check TypeScript configuration
npx tsc --noEmit
```

#### Permission Issues
```bash
# Make shell scripts executable
chmod +x scripts/backend/check-framework.sh
chmod +x scripts/frontend/check-framework.sh
chmod +x scripts/frontend/check-hardcoded.sh
```

### Performance Issues
- **Large codebases** - Use specific paths instead of entire project
- **Slow checking** - Enable file exclusions for generated files
- **Memory usage** - Process files in smaller batches

## 📈 Best Practices

### Development Workflow
1. **Start with watch mode** for real-time feedback
2. **Fix violations immediately** as they appear
3. **Run all checkers** before committing
4. **Use specific paths** for focused checking

### Team Collaboration
1. **Document violations** in pull requests
2. **Set up pre-commit hooks** for automatic checking
3. **Include checkers in CI/CD** for automated validation
4. **Regular compliance reviews** to maintain standards

### Maintenance
1. **Update patterns** as framework evolves
2. **Review exclusions** periodically
3. **Monitor performance** and optimize as needed
4. **Document customizations** for team knowledge

## 🎯 Next Steps

- **Add more checkers** for specific patterns
- **Integrate with IDE** for better developer experience
- **Create custom rules** for project-specific requirements
- **Automate fixes** where possible
- **Generate reports** for compliance tracking
