# Flutter Testing Guide

> **🧪 Comprehensive Testing Strategy for Flutter Framework**

This guide covers the complete testing strategy for the Flutter framework, including unit tests, widget tests, integration tests, and test organization.

## 📋 **Table of Contents**

1. [Testing Overview](#testing-overview)
2. [Test Types](#test-types)
3. [Test Organization](#test-organization)
4. [Test Tagging System](#test-tagging-system)
5. [Unit Testing](#unit-testing)
6. [Widget Testing](#widget-testing)
7. [Integration Testing](#integration-testing)
8. [Test Utilities](#test-utilities)
9. [Mocking](#mocking)
10. [Test Coverage](#test-coverage)
11. [Best Practices](#best-practices)
12. [Examples](#examples)

## 🧪 **Testing Overview**

The Flutter framework uses a comprehensive testing strategy that includes:

- **Unit Tests**: Test individual functions, classes, and methods
- **Widget Tests**: Test UI components and user interactions
- **Integration Tests**: Test complete feature workflows
- **No E2E Tests**: Framework doesn't use end-to-end tests

### **Testing Philosophy**

- **Test-Driven Development**: Write tests before implementation
- **Comprehensive Coverage**: Aim for high test coverage
- **Fast Feedback**: Quick test execution for rapid development
- **Reliable Tests**: Stable, deterministic test results
- **Maintainable Tests**: Easy to understand and modify

### **Testing Tools**

- **Flutter Test**: Built-in testing framework
- **Mocktail**: Mocking library for Dart
- **Test Tags**: Organize and categorize tests
- **Coverage**: Measure test coverage
- **CI/CD**: Automated testing in pipelines

## 🎯 **Test Types**

### **1. Unit Tests**
Test individual functions, classes, and methods in isolation.

**Characteristics**:
- Fast execution (< 1 second)
- No UI dependencies
- Isolated testing
- High coverage

**Example**:
```dart
// test/features/home/domain/entities/sample_entity_test.dart
void main() {
  group('SampleEntity', () {
    test('should create entity with required fields', () {
      // Arrange
      final entity = SampleEntity.sample();

      // Assert
      expect(entity.id, isNotEmpty);
      expect(entity.name, equals('Sample Entity'));
      expect(entity.tenantId, isNotEmpty);
    });
  });
}
```

### **2. Widget Tests**
Test UI components and user interactions.

**Characteristics**:
- Medium execution time (1-5 seconds)
- UI component testing
- User interaction testing
- Widget tree testing

**Example**:
```dart
// test/features/home/presentation/screens/home_screen_test.dart
void main() {
  group('HomeScreen', () {
    testWidgets('should display loading state', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeControllerProvider.overrideWithValue(
              HomeState.loading(),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### **3. Integration Tests**
Test complete feature workflows and user journeys.

**Characteristics**:
- Slower execution (5-30 seconds)
- Full feature testing
- User journey testing
- End-to-end workflows

**Example**:
```dart
// test/features/home/integration/home_flow_test.dart
void main() {
  group('Home Flow Integration', () {
    testWidgets('should complete full home workflow', (tester) async {
      // Arrange
      await tester.pumpWidget(const TestApp());

      // Act & Assert
      // Load home screen
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

      // Load entities
      await tester.tap(find.byKey(const Key('load_entities_button')));
      await tester.pumpAndSettle();
      expect(find.byType(EntityListWidget), findsOneWidget);

      // Create new entity
      await tester.tap(find.byKey(const Key('create_entity_button')));
      await tester.pumpAndSettle();
      expect(find.byType(CreateEntityDialog), findsOneWidget);
    });
  });
}
```

## 📁 **Test Organization**

### **Directory Structure**
```
test/
├── features/                    # Feature-specific tests
│   └── [feature]/              # Individual feature tests
│       ├── domain/             # Domain layer tests
│       │   └── entities/       # Entity tests
│       ├── data/               # Data layer tests
│       │   ├── data_sources/   # Data source tests
│       │   ├── mappers/        # Mapper tests
│       │   └── repositories/   # Repository tests
│       ├── presentation/       # Presentation layer tests
│       │   ├── controllers/    # Controller tests
│       │   └── screens/        # Screen tests
│       └── integration/        # Integration tests
├── helpers/                     # Test utilities
│   ├── test_base.dart          # Base test class
│   ├── mock_factories.dart     # Mock factories
│   └── test_data.dart          # Test data
├── examples/                    # Test examples
│   └── tagged_tests_example.dart
├── test_config.dart            # Test configuration
└── widget_test.dart            # Default widget test
```

### **Test File Naming**
- **Unit Tests**: `[feature]_test.dart`
- **Widget Tests**: `[widget]_test.dart`
- **Integration Tests**: `[feature]_flow_test.dart`
- **Helper Files**: `[helper_name].dart`

## 🏷️ **Test Tagging System**

### **Tag Categories**

#### **Test Categories**
- `unit`: Unit tests (fast, isolated)
- `integration`: Integration tests (medium speed)
- `widget`: Widget tests (UI components)

#### **Test Types**
- `smoke`: Smoke tests (critical functionality)
- `regression`: Regression tests
- `performance`: Performance tests
- `security`: Security tests
- `accessibility`: Accessibility tests

#### **Test Priority**
- `critical`: Critical functionality
- `high`: High priority
- `medium`: Medium priority
- `low`: Low priority

#### **Test Scope**
- `core`: Core framework functionality
- `feature`: Feature-specific tests
- `ui`: UI component tests
- `api`: API integration tests

### **Tag Usage**

#### **Individual Test Tags**
```dart
test('should perform basic calculation', () {
  // Test implementation
}, tags: TestTags.unit);

test('should handle user authentication', () {
  // Test implementation
}, tags: TestTags.smoke);
```

#### **Group Tags**
```dart
group('Authentication Feature', () {
  test('should log in with valid credentials', () {
    // Test implementation
  });
}, tags: TestTags.integration);
```

#### **Predefined Tag Combinations**
```dart
// Use predefined combinations
test('should load user data', () {
  // Test implementation
}, tags: TestTags.featureUnit);

test('should display user interface', () {
  // Test implementation
}, tags: TestTags.uiWidget);
```

### **Running Tagged Tests**

#### **Run Specific Tags**
```bash
# Run unit tests
flutter test --tags unit

# Run smoke tests
flutter test --tags smoke

# Run critical tests
flutter test --tags critical

# Run multiple tags (AND logic)
flutter test --tags "unit,fast"

# Run multiple tags (OR logic)
flutter test --tags unit --tags smoke
```

#### **Exclude Specific Tags**
```bash
# Exclude slow tests
flutter test --exclude-tags slow

# Exclude network tests
flutter test --exclude-tags network

# Exclude multiple tags
flutter test --exclude-tags slow,network
```

## 🔬 **Unit Testing**

### **Testing Domain Entities**

```dart
// test/features/home/domain/entities/sample_entity_test.dart
void main() {
  group('SampleEntity', () {
    late SampleEntity entity;

    setUp(() {
      entity = SampleEntity.sample();
    });

    test('should create entity with required fields', () {
      // Assert
      expect(entity.id, isNotEmpty);
      expect(entity.name, equals('Sample Entity'));
      expect(entity.tenantId, isNotEmpty);
      expect(entity.tenantSlug, isNotEmpty);
    });

    test('should convert to JSON correctly', () {
      // Act
      final json = entity.toJson();

      // Assert
      expect(json['id'], equals(entity.id));
      expect(json['name'], equals(entity.name));
      expect(json['tenantId'], equals(entity.tenantId));
    });

    test('should create from JSON correctly', () {
      // Arrange
      final json = entity.toJson();

      // Act
      final createdEntity = SampleEntity.fromJson(json);

      // Assert
      expect(createdEntity.id, equals(entity.id));
      expect(createdEntity.name, equals(entity.name));
      expect(createdEntity.tenantId, equals(entity.tenantId));
    });

    test('should support copyWith method', () {
      // Act
      final updatedEntity = entity.copyWith(name: 'Updated Name');

      // Assert
      expect(updatedEntity.name, equals('Updated Name'));
      expect(updatedEntity.id, equals(entity.id));
      expect(updatedEntity.tenantId, equals(entity.tenantId));
    });

    test('should implement equality correctly', () {
      // Arrange
      final sameEntity = SampleEntity.sample();
      final differentEntity = SampleEntity.sample(name: 'Different Name');

      // Assert
      expect(entity, equals(sameEntity));
      expect(entity, isNot(equals(differentEntity)));
    });
  });
}
```

### **Testing Use Cases**

```dart
// test/features/home/domain/usecases/get_entity_usecase_test.dart
void main() {
  group('GetEntityUseCase', () {
    late GetEntityUseCase useCase;
    late MockSampleEntityRepository mockRepository;

    setUp(() {
      mockRepository = MockSampleEntityRepository();
      useCase = GetEntityUseCase(mockRepository);
    });

    test('should return entity when repository returns data', () async {
      // Arrange
      final entity = SampleEntity.sample();
      when(() => mockRepository.getById('1')).thenAnswer((_) async => entity);

      // Act
      final result = await useCase.execute('1');

      // Assert
      expect(result, equals(entity));
      verify(() => mockRepository.getById('1')).called(1);
    });

    test('should throw exception when repository throws', () async {
      // Arrange
      when(() => mockRepository.getById('1')).thenThrow(Exception('Not found'));

      // Act & Assert
      expect(() => useCase.execute('1'), throwsException);
    });
  });
}
```

### **Testing Services**

```dart
// test/core/services/cache_manager_test.dart
void main() {
  group('HybridCacheManager', () {
    late HybridCacheManager cacheManager;
    late MemoryCacheManager memoryCache;
    late PersistentCacheManager persistentCache;

    setUp(() {
      memoryCache = MemoryCacheManager();
      persistentCache = PersistentCacheManager();
      cacheManager = HybridCacheManager(
        memoryCache: memoryCache,
        persistentCache: persistentCache,
      );
    });

    test('should get value from memory cache first', () async {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';
      await memoryCache.set(key, value);

      // Act
      final result = await cacheManager.get<String>(key);

      // Assert
      expect(result, equals(value));
    });

    test('should fallback to persistent cache when memory cache is empty', () async {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';
      await persistentCache.set(key, value);

      // Act
      final result = await cacheManager.get<String>(key);

      // Assert
      expect(result, equals(value));
    });

    test('should set value in both caches', () async {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';

      // Act
      await cacheManager.set(key, value);

      // Assert
      final memoryResult = await memoryCache.get<String>(key);
      final persistentResult = await persistentCache.get<String>(key);
      expect(memoryResult, equals(value));
      expect(persistentResult, equals(value));
    });
  });
}
```

## 🎨 **Widget Testing**

### **Testing State Notifiers**

```dart
// test/features/home/presentation/controllers/home_controller_test.dart
void main() {
  group('HomeController', () {
    late HomeController controller;
    late MockSampleEntityRepository mockRepository;

    setUp(() {
      mockRepository = MockSampleEntityRepository();
      controller = HomeController(mockRepository);
    });

    test('should load entities successfully', () async {
      // Arrange
      final entities = [SampleEntity.sample()];
      when(() => mockRepository.getAll()).thenAnswer((_) async => entities);

      // Act
      await controller.loadEntities();

      // Assert
      expect(controller.state.entities, equals(entities));
      expect(controller.state.isLoading, isFalse);
      expect(controller.state.error, isNull);
    });

    test('should handle error when loading entities fails', () async {
      // Arrange
      when(() => mockRepository.getAll()).thenThrow(Exception('Network error'));

      // Act
      await controller.loadEntities();

      // Assert
      expect(controller.state.entities, isEmpty);
      expect(controller.state.isLoading, isFalse);
      expect(controller.state.error, equals('Exception: Network error'));
    });

    test('should create entity successfully', () async {
      // Arrange
      final entity = SampleEntity.sample();
      final createdEntity = SampleEntity.sample(id: '2');
      when(() => mockRepository.create(entity)).thenAnswer((_) async => createdEntity);

      // Act
      await controller.createEntity(entity);

      // Assert
      expect(controller.state.entities, contains(createdEntity));
      expect(controller.state.isLoading, isFalse);
      expect(controller.state.error, isNull);
    });
  });
}
```

### **Testing UI Components**

```dart
// test/features/home/presentation/screens/home_screen_test.dart
void main() {
  group('HomeScreen', () {
    testWidgets('should display loading state', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeControllerProvider.overrideWithValue(
              HomeState.loading(),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should display loaded state with entities', (tester) async {
      // Arrange
      final entities = [SampleEntity.sample()];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeControllerProvider.overrideWithValue(
              HomeState.loaded(entities),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(EntityListWidget), findsOneWidget);
      expect(find.text('Sample Entity'), findsOneWidget);
    });

    testWidgets('should display error state', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            homeControllerProvider.overrideWithValue(
              HomeState.error('Network error'),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: Network error'), findsOneWidget);
      expect(find.byKey(const Key('retry_button')), findsOneWidget);
    });

    testWidgets('should load entities when retry button is tapped', (tester) async {
      // Arrange
      final mockRepository = MockSampleEntityRepository();
      when(() => mockRepository.getAll()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sampleEntityRepositoryProvider.overrideWithValue(mockRepository),
            homeControllerProvider.overrideWithValue(
              HomeState.error('Network error'),
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Act
      await tester.tap(find.byKey(const Key('retry_button')));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockRepository.getAll()).called(1);
    });
  });
}
```

### **Testing Custom Widgets**

```dart
// test/ui/widgets/generic_widgets_test.dart
void main() {
  group('GenericWidgets', () {
    testWidgets('EntityCard should display entity information', (tester) async {
      // Arrange
      final entity = SampleEntity.sample();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EntityCard(
              entity: entity,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(entity.name), findsOneWidget);
      expect(find.text(entity.description), findsOneWidget);
    });

    testWidgets('LoadingWidget should display loading indicator', (tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LoadingWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('ErrorWidget should display error message and retry button', (tester) async {
      // Arrange
      const errorMessage = 'Something went wrong';

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorWidget(
              message: errorMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: $errorMessage'), findsOneWidget);
      expect(find.byKey(const Key('retry_button')), findsOneWidget);
    });
  });
}
```

## 🔗 **Integration Testing**

### **Testing Complete Workflows**

```dart
// test/features/home/integration/home_flow_test.dart
void main() {
  group('Home Flow Integration', () {
    testWidgets('should complete full home workflow', (tester) async {
      // Arrange
      await tester.pumpWidget(const TestApp());

      // Act & Assert
      // Load home screen
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);

      // Load entities
      await tester.tap(find.byKey(const Key('load_entities_button')));
      await tester.pumpAndSettle();
      expect(find.byType(EntityListWidget), findsOneWidget);

      // Create new entity
      await tester.tap(find.byKey(const Key('create_entity_button')));
      await tester.pumpAndSettle();
      expect(find.byType(CreateEntityDialog), findsOneWidget);

      // Fill form
      await tester.enterText(find.byKey(const Key('name_field')), 'New Entity');
      await tester.enterText(find.byKey(const Key('description_field')), 'New Description');

      // Submit form
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle();

      // Verify entity was created
      expect(find.text('New Entity'), findsOneWidget);
      expect(find.byType(CreateEntityDialog), findsNothing);
    });

    testWidgets('should handle offline scenario', (tester) async {
      // Arrange
      await tester.pumpWidget(const TestApp());

      // Simulate offline
      // This would require mocking the connection manager

      // Act
      await tester.tap(find.byKey(const Key('load_entities_button')));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Offline mode'), findsOneWidget);
      expect(find.byType(OfflineIndicator), findsOneWidget);
    });
  });
}
```

## 🛠️ **Test Utilities**

### **Base Test Class**

```dart
// test/helpers/test_base.dart
abstract class TestBase {
  late MockSampleEntityRepository mockRepository;
  late MockCacheManager mockCacheManager;
  late MockConnectionManager mockConnectionManager;

  void setUpMocks() {
    mockRepository = MockSampleEntityRepository();
    mockCacheManager = MockCacheManager();
    mockConnectionManager = MockConnectionManager();
  }

  void tearDownMocks() {
    reset(mockRepository);
    reset(mockCacheManager);
    reset(mockConnectionManager);
  }

  SampleEntity createSampleEntity({
    String? id,
    String? name,
    String? description,
  }) {
    return SampleEntity(
      id: id ?? '1',
      name: name ?? 'Sample Entity',
      description: description ?? 'Sample Description',
      tenantId: 'tenant_1',
      tenantSlug: 'tenant-slug',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  List<SampleEntity> createSampleEntities(int count) {
    return List.generate(
      count,
      (index) => createSampleEntity(
        id: '${index + 1}',
        name: 'Sample Entity ${index + 1}',
      ),
    );
  }
}
```

### **Mock Factories**

```dart
// test/helpers/mock_factories.dart
class MockSampleEntityRepository extends Mock implements SampleEntityRepository {}
class MockCacheManager extends Mock implements CacheManager {}
class MockConnectionManager extends Mock implements ConnectionManager {}
class MockSyncManager extends Mock implements SyncManager {}

class MockSampleEntityRemoteDataSource extends Mock implements SampleEntityRemoteDataSource {}
class MockSampleEntityLocalDataSource extends Mock implements SampleEntityLocalDataSource {}
class MockSampleEntityMapper extends Mock implements SampleEntityMapper {}

// Test data factories
class TestDataFactory {
  static SampleEntity createSampleEntity({
    String? id,
    String? name,
    String? description,
  }) {
    return SampleEntity(
      id: id ?? '1',
      name: name ?? 'Sample Entity',
      description: description ?? 'Sample Description',
      tenantId: 'tenant_1',
      tenantSlug: 'tenant-slug',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static List<SampleEntity> createSampleEntities(int count) {
    return List.generate(
      count,
      (index) => createSampleEntity(
        id: '${index + 1}',
        name: 'Sample Entity ${index + 1}',
      ),
    );
  }
}
```

### **Test App Widget**

```dart
// test/helpers/test_app.dart
class TestApp extends StatelessWidget {
  final List<Override> overrides;
  final Widget child;

  const TestApp({
    super.key,
    this.overrides = const [],
    this.child = const HomeScreen(),
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        title: 'Test App',
        home: child,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
```

## 🎭 **Mocking**

### **Using Mocktail**

```dart
// test/features/home/data/repositories/sample_entity_repository_test.dart
void main() {
  group('SampleEntityRepository', () {
    late SampleEntityRepository repository;
    late MockSampleEntityRemoteDataSource mockRemoteDataSource;
    late MockSampleEntityLocalDataSource mockLocalDataSource;
    late MockSampleEntityMapper mockMapper;
    late MockCacheManager mockCacheManager;

    setUp(() {
      mockRemoteDataSource = MockSampleEntityRemoteDataSource();
      mockLocalDataSource = MockSampleEntityLocalDataSource();
      mockMapper = MockSampleEntityMapper();
      mockCacheManager = MockCacheManager();

      repository = SampleEntityRepository(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        mapper: mockMapper,
        cacheManager: mockCacheManager,
        connectionManager: MockConnectionManager(),
        syncManager: MockSyncManager(),
      );
    });

    test('should get all entities from remote when online', () async {
      // Arrange
      final entityModels = [SampleEntityModel.sample()];
      final entities = [SampleEntity.sample()];
      
      when(() => mockRemoteDataSource.getAll()).thenAnswer((_) async => entityModels);
      when(() => mockMapper.toEntityList(entityModels)).thenReturn(entities);

      // Act
      final result = await repository.getAll();

      // Assert
      expect(result, equals(entities));
      verify(() => mockRemoteDataSource.getAll()).called(1);
      verify(() => mockCacheManager.set('entities', entities)).called(1);
    });

    test('should get entity by id from cache when available', () async {
      // Arrange
      const entityId = '1';
      final entity = SampleEntity.sample(id: entityId);
      
      when(() => mockCacheManager.get<SampleEntity>('entity_$entityId'))
          .thenAnswer((_) async => entity);

      // Act
      final result = await repository.getById(entityId);

      // Assert
      expect(result, equals(entity));
      verify(() => mockCacheManager.get<SampleEntity>('entity_$entityId')).called(1);
      verifyNever(() => mockRemoteDataSource.getById(entityId));
    });
  });
}
```

### **Provider Overrides**

```dart
// test/features/home/presentation/controllers/home_controller_test.dart
void main() {
  group('HomeController', () {
    testWidgets('should load entities when provider is used', (tester) async {
      // Arrange
      final mockRepository = MockSampleEntityRepository();
      final entities = [SampleEntity.sample()];
      
      when(() => mockRepository.getAll()).thenAnswer((_) async => entities);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sampleEntityRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const TestApp(),
        ),
      );

      // Trigger loading
      final controller = tester.element(find.byType(HomeScreen))
          .read(homeControllerProvider.notifier);
      await controller.loadEntities();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Sample Entity'), findsOneWidget);
      verify(() => mockRepository.getAll()).called(1);
    });
  });
}
```

## 📊 **Test Coverage**

### **Running Coverage**

```bash
# Generate coverage report
flutter test --coverage

# Generate coverage report with thresholds
flutter test --coverage --coverage-threshold=85

# View coverage report (if lcov is installed)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### **Coverage Configuration**

```yaml
# dart_test.yaml
coverage:
  path: coverage/
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "**/generated/**"
    - "**/test/**"
    - "**/integration_test/**"
    # Exclude framework implementation files
    - "lib/core/**"
    - "lib/ui/**"
    - "lib/l10n/**"
    - "lib/main.dart"
```

**Excluded Framework Files:**
- **Core**: Framework entities, error handling, routing, services, state management
- **UI**: Shared widgets, styles, themes
- **L10n**: Localization files
- **Main**: Application entry point

### **Coverage Goals & Thresholds**

- **Business Logic Only**: Framework files are excluded from coverage
- **Unit Tests**: 90%+ coverage (business features only)
- **Widget Tests**: 80%+ coverage (business features only)
- **Integration Tests**: 70%+ coverage (business features only)
- **Overall**: 85%+ coverage (business features only)
- **Global Thresholds** (business logic only):
  - **Lines**: 85%
  - **Functions**: 85%
  - **Branches**: 80%
  - **Statements**: 85%

## ✅ **Best Practices**

### **1. Test Organization**
- Group related tests together
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Keep tests focused and single-purpose

### **2. Test Data**
- Use factories for test data creation
- Create realistic test data
- Avoid hardcoded values
- Use constants for repeated values

### **3. Mocking**
- Mock external dependencies
- Use interfaces for mocking
- Verify mock interactions
- Reset mocks between tests

### **4. Test Performance**
- Keep tests fast
- Use appropriate test types
- Avoid unnecessary setup
- Use test tags for organization

### **5. Test Maintenance**
- Keep tests up to date
- Refactor tests with code changes
- Remove obsolete tests
- Document complex test scenarios

## 📝 **Examples**

### **Complete Feature Test Suite**

```dart
// test/features/user/presentation/controllers/user_controller_test.dart
void main() {
  group('UserController', () {
    late UserController controller;
    late MockUserRepository mockRepository;

    setUp(() {
      mockRepository = MockUserRepository();
      controller = UserController(mockRepository);
    });

    group('loadUser', () {
      test('should load user successfully', () async {
        // Arrange
        const userId = '1';
        final user = UserEntity.sample(id: userId);
        when(() => mockRepository.getById(userId)).thenAnswer((_) async => user);

        // Act
        await controller.loadUser(userId);

        // Assert
        expect(controller.state.user, equals(user));
        expect(controller.state.isLoading, isFalse);
        expect(controller.state.error, isNull);
        verify(() => mockRepository.getById(userId)).called(1);
      });

      test('should handle error when loading user fails', () async {
        // Arrange
        const userId = '1';
        when(() => mockRepository.getById(userId)).thenThrow(Exception('Not found'));

        // Act
        await controller.loadUser(userId);

        // Assert
        expect(controller.state.user, isNull);
        expect(controller.state.isLoading, isFalse);
        expect(controller.state.error, equals('Exception: Not found'));
      });
    });

    group('updateUser', () {
      test('should update user successfully', () async {
        // Arrange
        final user = UserEntity.sample();
        final updatedUser = user.copyWith(name: 'Updated Name');
        when(() => mockRepository.update(user.id, user)).thenAnswer((_) async => updatedUser);

        // Act
        await controller.updateUser(user);

        // Assert
        expect(controller.state.user, equals(updatedUser));
        expect(controller.state.isLoading, isFalse);
        expect(controller.state.error, isNull);
        verify(() => mockRepository.update(user.id, user)).called(1);
      });
    });
  });
}
```

### **Widget Test with Provider Overrides**

```dart
// test/features/user/presentation/screens/user_screen_test.dart
void main() {
  group('UserScreen', () {
    testWidgets('should display user information when loaded', (tester) async {
      // Arrange
      final user = UserEntity.sample();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userControllerProvider.overrideWithValue(
              UserState.loaded(user),
            ),
          ],
          child: const MaterialApp(
            home: UserScreen(userId: '1'),
          ),
        ),
      );

      // Assert
      expect(find.text(user.name), findsOneWidget);
      expect(find.text(user.email), findsOneWidget);
      expect(find.byType(UserDetailsWidget), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userControllerProvider.overrideWithValue(
              UserState.loading(),
            ),
          ],
          child: const MaterialApp(
            home: UserScreen(userId: '1'),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should show error message when error occurs', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userControllerProvider.overrideWithValue(
              UserState.error('Network error'),
            ),
          ],
          child: const MaterialApp(
            home: UserScreen(userId: '1'),
          ),
        ),
      );

      // Assert
      expect(find.text('Error: Network error'), findsOneWidget);
      expect(find.byKey(const Key('retry_button')), findsOneWidget);
    });
  });
}
```

## 🎯 **Summary**

The Flutter testing strategy provides:

- **Comprehensive Coverage**: Unit, widget, and integration tests
- **Organized Structure**: Clear test organization and naming
- **Tagging System**: Flexible test execution and categorization
- **Mocking Support**: Easy dependency mocking with Mocktail
- **Test Utilities**: Reusable test helpers and factories
- **Coverage Tracking**: Measure and improve test coverage
- **Best Practices**: Guidelines for maintainable tests

This testing approach ensures the Flutter framework remains reliable, maintainable, and well-tested while following Flutter and Dart testing best practices.
