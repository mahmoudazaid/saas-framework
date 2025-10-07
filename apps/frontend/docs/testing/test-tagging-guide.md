# Flutter Test Tagging Guide

## 🏷️ **Overview**

This comprehensive guide explains how to use the test tagging system in our Flutter framework. The tagging system allows you to organize, categorize, and selectively run tests based on various criteria such as test type, priority, scope, and dependencies.

## 🎯 **Why Use Test Tags?**

- **Selective Testing**: Run only the tests you need
- **CI/CD Optimization**: Run fast tests first, slow tests later
- **Development Efficiency**: Focus on specific features or components
- **Environment Control**: Run tests appropriate for your environment
- **Performance Management**: Separate fast from slow tests

## 📋 **Available Test Tags**

### **Test Categories**
- `unit` - Unit tests (fast, isolated)
- `integration` - Integration tests (medium speed)
- `widget` - Widget tests (UI components)

### **Test Types**
- `smoke` - Smoke tests (critical functionality)
- `regression` - Regression tests
- `performance` - Performance tests
- `security` - Security tests
- `accessibility` - Accessibility tests

### **Priority Levels**
- `critical` - Critical functionality
- `high` - High priority
- `medium` - Medium priority
- `low` - Low priority

### **Test Scope**
- `core` - Core framework functionality
- `feature` - Feature-specific tests
- `ui` - UI component tests
- `api` - API integration tests

### **Environment**
- `local` - Local development only
- `ci` - CI/CD environment
- `staging` - Staging environment
- `production` - Production environment

### **Speed**
- `fast` - Fast tests (< 1 second)
- `slow` - Slow tests (1-10 seconds)
- `very-slow` - Very slow tests (> 10 seconds)

### **Dependencies**
- `network` - Requires network connection
- `database` - Requires database
- `file-system` - Requires file system access
- `external` - Requires external services

## 🚀 **Running Tests by Tags**

### **Basic Commands**
```bash
# Run all tests
flutter test

# Run tests with specific tags (AND logic - all tags must match)
flutter test --tags unit
flutter test --tags smoke
flutter test --tags critical
flutter test --tags "unit,fast"        # Tests with BOTH unit AND fast tags
flutter test --tags "smoke,critical"   # Tests with BOTH smoke AND critical tags

# Run tests excluding specific tags
flutter test --exclude-tags slow
flutter test --exclude-tags network
flutter test --exclude-tags "slow,network"  # Exclude tests with slow OR network tags

# Run tests with any of the tags (OR logic - any tag can match)
flutter test --tags unit --tags smoke  # Tests with unit OR smoke tags
```

### **Understanding Tag Logic**
- **`--tags "a,b"`**: Tests must have BOTH tag `a` AND tag `b` (AND logic)
- **`--tags a --tags b`**: Tests can have tag `a` OR tag `b` (OR logic)
- **`--exclude-tags "a,b"`**: Exclude tests that have tag `a` OR tag `b`

### **Common Test Scenarios**

#### **Fast Tests (CI/CD)**
```bash
# Run only fast tests for quick feedback
flutter test --tags fast

# Run core unit tests
flutter test --tags "core,unit"

# Run smoke tests
flutter test --tags smoke
```

#### **Feature Development**
```bash
# Run feature-specific tests
flutter test --tags feature

# Run UI widget tests
flutter test --tags widget

# Run integration tests
flutter test --tags integration
```

#### **Performance Testing**
```bash
# Run performance tests
flutter test --tags performance

# Run slow tests
flutter test --tags slow

# Run very slow tests
flutter test --tags very-slow
```

#### **Security Testing**
```bash
# Run security tests
flutter test --tags security

# Run critical security tests
flutter test --tags "security,critical"
```

#### **Accessibility Testing**
```bash
# Run accessibility tests
flutter test --tags accessibility

# Run UI accessibility tests
flutter test --tags "ui,accessibility"
```

#### **Environment-Specific Testing**
```bash
# Run local-only tests
flutter test --tags local

# Run CI-only tests
flutter test --tags ci

# Run tests excluding local-only
flutter test --exclude-tags local
```

#### **Network-Dependent Tests**
```bash
# Run tests that require network
flutter test --tags network

# Run offline tests only
flutter test --exclude-tags network

# Run tests that don't require external services
flutter test --exclude-tags external
```

## 📊 **Test Tag Combinations**

### **Predefined Combinations**
The framework provides predefined tag combinations in `test/test_config.dart`:

```dart
// Core Framework Tests
TestTags.coreUnit        // [core, unit, fast]
TestTags.coreIntegration // [core, integration, medium]

// Feature Tests
TestTags.featureUnit     // [feature, unit, fast]
TestTags.featureWidget   // [feature, widget, medium]
TestTags.featureIntegration // [feature, integration, medium]

// UI Tests
TestTags.uiWidget        // [ui, widget, fast]
TestTags.uiAccessibility // [ui, accessibility, medium]

// Smoke Tests
TestTags.smokeCritical   // [smoke, critical, fast]
TestTags.smokeRegression // [smoke, regression, medium]

// Performance Tests
TestTags.performanceSlow     // [performance, slow]
TestTags.performanceVerySlow // [performance, very-slow]

// Security Tests
TestTags.securityCritical // [security, critical, medium]

// Environment Specific
TestTags.ciOnly      // [ci, slow]
TestTags.localOnly   // [local, fast]
TestTags.stagingOnly // [staging, integration]

// Network Tests
TestTags.networkRequired // [network, external, slow]
TestTags.offline         // [unit, fast] (no network)
```

### **Using Predefined Combinations**
```dart
import '../test_config.dart';

test('should validate user input', () {
  // Test implementation
}, tags: TestTags.featureUnit);

group('Authentication Widget Tests', () {
  test('should render login form', () {
    // Test implementation
  }, tags: TestTags.uiWidget);
  
  test('should handle login errors', () {
    // Test implementation
  }, tags: TestTags.featureIntegration);
});
```

## 🎯 **Best Practices**

### **1. Tag Every Test**
```dart
test('should validate input', () {
  // test implementation
}, tags: TestTags.featureUnit);
```

### **2. Use Predefined Combinations**
```dart
// Good - Use predefined combinations
test('should render button', () {
  // test implementation
}, tags: TestTags.uiWidget);

// Avoid - Manual tag arrays
test('should render button', () {
  // test implementation
}, tags: ['ui', 'widget', 'fast']);
```

### **3. Tag by Test Type**
- **Unit Tests**: `TestTags.featureUnit`
- **Widget Tests**: `TestTags.uiWidget`
- **Integration Tests**: `TestTags.featureIntegration`

### **4. Tag by Priority**
- **Critical**: Always include `critical` tag
- **High Priority**: Include `high` tag
- **Low Priority**: Include `low` tag

### **5. Tag by Dependencies**
- **Network Required**: Include `network` tag
- **Database Required**: Include `database` tag
- **External Services**: Include `external` tag

## 🔧 **CI/CD Integration**

### **GitHub Actions Example**
```yaml
name: Test Suite
on: [push, pull_request]

jobs:
  fast-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --tags fast

  smoke-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --tags smoke

  integration-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --tags integration

  performance-tests:
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter test --tags performance
```

### **Local Development**
```bash
# Quick feedback during development
flutter test --tags "fast,unit"

# Full feature testing
flutter test --tags feature

# Complete test suite
flutter test
```

## 📈 **Test Metrics**

### **Test Coverage by Category**
```bash
# Unit test coverage
flutter test --tags unit --coverage

# Widget test coverage
flutter test --tags widget --coverage

# Integration test coverage
flutter test --tags integration --coverage
```

### **Test Performance**
```bash
# Run fast tests only
time flutter test --tags fast

# Run slow tests
time flutter test --tags slow

# Run all tests with timing
time flutter test
```

This tagging system provides comprehensive test organization and allows for flexible test execution based on different scenarios and requirements.
