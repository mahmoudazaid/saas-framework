# Development Scripts

This directory contains development and testing scripts for the Gym Manager monorepo. These scripts help maintain and enforce our generic framework design patterns across both backend and frontend code.

## 📁 Directory Structure

```
scripts/
├── backend/                           # Backend-specific scripts
│   ├── check-framework-violations.ts  # Backend framework checker
│   └── check-framework.sh             # Backend checker wrapper
├── frontend/                          # Frontend-specific scripts
│   ├── check-framework-violations.ts  # Frontend framework checker
│   ├── check-framework.sh             # Frontend checker wrapper
│   ├── check-hardcoded-violations.ts  # Hardcoded content checker
│   └── check-hardcoded.sh             # Hardcoded checker wrapper
├── package.json                       # Scripts dependencies
├── tsconfig.json                      # TypeScript configuration
└── README.md                          # This file
```

## 🔧 Available Scripts

### Backend Framework Checker

Checks TypeScript/Node.js code for compliance with the generic framework design patterns.

```bash
# Check backend code
npm run check:framework

# Check specific path
npm run check:framework -- apps/backend/src

# Watch mode (continuous checking)
npm run check:framework:watch

# Using shell script
./scripts/backend/check-framework.sh
./scripts/backend/check-framework.sh --watch
```

### Frontend Framework Checker

Checks Flutter/Dart code for compliance with the generic framework design patterns.

```bash
# Check frontend code
npm run check:framework:frontend

# Check specific path
npm run check:framework:frontend -- apps/frontend/lib

# Watch mode (continuous checking)
npm run check:framework:frontend:watch

# Using shell script
./scripts/frontend/check-framework.sh
./scripts/frontend/check-framework.sh --watch
```

### Frontend Hardcoded Content Checker

Checks Flutter/Dart code for hardcoded text, colors, and styling that should be centralized.

```bash
# Check for hardcoded content
npm run check:hardcoded:frontend

# Check specific path
npm run check:hardcoded:frontend -- apps/frontend/lib

# Watch mode (continuous checking)
npm run check:hardcoded:frontend:watch

# Using shell script
./scripts/frontend/check-hardcoded.sh
./scripts/frontend/check-hardcoded.sh --watch
```

### Combined Checks

```bash
# Check both backend and frontend
npm run check:all

# Check with linting and testing
npm run check:all && npm run lint:backend && npm run test:backend
```

## 🎯 What the Checkers Look For

### Backend Framework Violations

#### 🚫 Business Terminology Violations
- Detects business-specific terms like `gym`, `member`, `trainer`, `workout`
- Suggests generic alternatives like `entity`, `tenant`, `user`, `product`

#### 🏗️ Clean Architecture Violations
- **Domain Layer**: No external dependencies except `@nestjs/common`, `typeorm`
- **Application Layer**: No direct database or HTTP dependencies
- **Infrastructure Layer**: Can import from domain and application
- **Presentation Layer**: Can import from all other layers

#### 🏢 Multi-tenancy Pattern Violations
- Entities extending `TenantEntity` must have `tenantId` field
- No hardcoded `gymId` or `gymSlug` references
- Proper use of `tenantId` and `tenantSlug`

#### 📝 Generic Framework Violations
- Missing JSDoc comments on public methods
- Missing error handling in async functions
- Proper use of generic terminology
- Logging patterns and error handling

### Frontend Framework Violations

#### 🚫 Business Terminology Violations
- Detects business-specific terms like `gym`, `member`, `trainer`, `workout`
- Suggests generic alternatives like `entity`, `tenant`, `user`, `product`

#### 🏗️ Clean Architecture Violations
- **Presentation Layer**: UI components and screens
- **Domain Layer**: Business entities and models
- **Application Layer**: Use cases and controllers
- **Infrastructure Layer**: Services and repositories

#### 🎨 State Management Violations
- Proper Riverpod patterns and providers
- State notifier implementation
- Error state handling

#### 🌐 Localization Violations
- Hardcoded text that should be in ARB files
- Missing `AppLocalizations.of(context)` usage
- Proper fallback handling

#### ♿ Accessibility Violations
- Missing `semanticLabel` on widgets
- Proper accessibility patterns
- Screen reader compatibility

#### 🎨 Styling Violations
- Hardcoded colors that should use theme
- Hardcoded sizes that should use `AppStyles`
- Inconsistent spacing and styling

### Frontend Hardcoded Content Violations

#### 📝 Hardcoded Text
- User-facing text not in ARB files
- Missing localization imports
- Fallback strings in UI components

#### 🎨 Hardcoded Colors
- `Colors.red`, `Colors.blue` instead of theme colors
- Hardcoded color values instead of theme-based colors

#### 📏 Hardcoded Sizing
- Hardcoded `fontSize`, `width`, `height` values
- Missing `AppStyles` constants usage
- Inconsistent spacing values

## 🚀 Quick Start

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Check backend code**:
   ```bash
   npm run check:framework
   ```

3. **Check frontend code**:
   ```bash
   npm run check:framework:frontend
   ```

4. **Check everything**:
   ```bash
   npm run check:all
   ```

## 📊 Violation Types

### Error Level
- **Breaks framework patterns**: Must be fixed immediately
- **Architecture violations**: Clean Architecture violations
- **Missing required patterns**: Essential framework components

### Warning Level
- **Code quality issues**: Should be addressed
- **Best practice violations**: Recommended improvements
- **Performance concerns**: Optimization opportunities

### Info Level
- **Suggestions**: Nice-to-have improvements
- **Documentation**: Missing documentation
- **Accessibility**: Accessibility improvements

## 🔧 Configuration

### Backend Configuration

The backend checker can be configured by modifying `scripts/backend/check-framework-violations.ts`:

```typescript
const CONFIG = {
  // Business terms to avoid
  businessTerms: ['gym', 'fitness', 'workout', ...],
  
  // Required patterns
  requiredPatterns: {
    cleanArchitecture: { ... },
    errorHandling: { ... },
    multiTenancy: { ... }
  }
};
```

### Frontend Configuration

The frontend checker can be configured by modifying `scripts/frontend/check-framework-violations.ts`:

```typescript
const CONFIG = {
  // Business terms to avoid
  businessTerms: ['gym', 'fitness', 'workout', ...],
  
  // Required patterns
  requiredPatterns: {
    cleanArchitecture: { ... },
    stateManagement: { ... },
    errorHandling: { ... },
    multiTenancy: { ... }
  }
};
```

## 📝 Code Examples

### ✅ Good Backend Code
```typescript
// src/core/entities/user.entity.ts
@Entity('users')
export class User extends TenantEntity {
  @Column()
  name!: string;

  @Column()
  email!: string;
}
```

### ❌ Bad Backend Code
```typescript
// src/core/entities/member.entity.ts
@Entity('members')
export class Member extends BaseEntity {  // Should extend TenantEntity
  @Column()
  name!: string;

  @Column()
  gymId!: string;  // Should be tenantId
}
```

### ✅ Good Frontend Code
```dart
// lib/features/home/presentation/screens/home_screen.dart
Text(
  AppLocalizations.of(context)!.welcomeMessage,
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### ❌ Bad Frontend Code
```dart
// lib/features/home/presentation/screens/home_screen.dart
Text(
  'Welcome to Gym Manager',  // Should be localized
  style: TextStyle(
    fontSize: 24,  // Should use AppStyles
    color: Colors.blue,  // Should use theme
  ),
)
```

## 🐛 Troubleshooting

### Common Issues

1. **ts-node not found**:
   ```bash
   npm install -g ts-node
   ```

2. **Permission denied** (shell scripts):
   ```bash
   chmod +x scripts/*/check-framework.sh
   chmod +x scripts/*/check-hardcoded.sh
   ```

3. **TypeScript errors**:
   ```bash
   npm install
   ```

4. **"Business-specific term found"**:
   - Replace with generic terminology
   - Use `entity` instead of `member`
   - Use `tenantId` instead of `gymId`

5. **"Forbidden import in layer"**:
   - Check Clean Architecture layer rules
   - Move code to appropriate layer
   - Use proper dependency injection

6. **"Missing tenantId field"**:
   - Add `tenantId` field to tenant-aware entities
   - Extend `TenantEntity` instead of `BaseEntity`

7. **"Hardcoded text found"**:
   - Move text to ARB files
   - Use `AppLocalizations.of(context)`
   - Remove fallback strings

### Debug Mode

Run with verbose output to see detailed information:

```bash
./scripts/backend/check-framework.sh --verbose
./scripts/frontend/check-framework.sh --verbose
./scripts/frontend/check-hardcoded.sh --verbose
```

## 📚 Integration

### Pre-commit Hook

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Run all framework and hardcoded checks
npm run check:all
if [ $? -ne 0 ]; then
  echo "❌ Framework compliance check failed. Please fix violations before committing."
  exit 1
fi

# Run hardcoded content check
npm run check:hardcoded:frontend
if [ $? -ne 0 ]; then
  echo "❌ Hardcoded content check failed. Please fix violations before committing."
  exit 1
fi

echo "✅ All checks passed!"
```

### CI/CD Integration

Add to your CI/CD pipeline:

```yaml
- name: Check Framework Compliance
  run: npm run check:all

- name: Check Hardcoded Content
  run: npm run check:hardcoded:frontend
```

### IDE Integration

Configure your IDE to run the checkers on file save or as a task.

## 🤝 Contributing

When adding new checks:

### Backend Framework Checker
1. **Add violation types** to the `violationTypes` object in `scripts/backend/check-framework-violations.ts`
2. **Implement check methods** following the existing pattern
3. **Update configuration** as needed
4. **Test thoroughly** with various TypeScript patterns

### Frontend Framework Checker
1. **Add violation types** to the `violationTypes` object in `scripts/frontend/check-framework-violations.ts`
2. **Implement check methods** following the existing pattern
3. **Update configuration** as needed
4. **Test thoroughly** with various Dart/Flutter patterns

### Frontend Hardcoded Checker
1. **Add patterns** to the `patterns` object in `scripts/frontend/check-hardcoded-violations.ts`
2. **Implement check methods** following the existing pattern
3. **Update filtering logic** for better accuracy
4. **Test thoroughly** with various hardcoded content patterns

### General Guidelines
- **Update documentation** to reflect new checks
- **Add examples** of good and bad code
- **Update troubleshooting** section with new common issues
- **Test with real codebase** before deploying

## 📄 License

MIT License - see the main project LICENSE file for details.
