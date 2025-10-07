# Flutter Clean Architecture

> **🏗️ Clean Architecture Implementation for Flutter Framework**

This document explains how Clean Architecture is implemented in the Flutter frontend framework, ensuring separation of concerns, testability, and maintainability.

## 📋 **Table of Contents**

1. [Architecture Overview](#architecture-overview)
2. [Layer Structure](#layer-structure)
3. [Dependency Flow](#dependency-flow)
4. [Implementation Details](#implementation-details)
5. [Best Practices](#best-practices)
6. [Examples](#examples)

## 🏗️ **Architecture Overview**

The Flutter framework follows Clean Architecture principles with clear separation between:

- **Domain Layer**: Business logic and entities
- **Application Layer**: Use cases and application services
- **Infrastructure Layer**: Data sources and external services
- **Presentation Layer**: UI components and state management

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   Controllers   │  │     Screens     │  │   Widgets   │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                   Application Layer                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   Use Cases     │  │   Services      │  │   DTOs      │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │    Entities     │  │   Value Objects │  │ Repositories│  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                 Infrastructure Layer                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │  Data Sources   │  │   External APIs │  │   Storage   │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📁 **Layer Structure**

### **Domain Layer** (`lib/core/` + `lib/features/*/domain/`)

**Purpose**: Contains business logic and entities that are independent of any framework.

**Components**:
- **Entities**: Core business objects
- **Value Objects**: Immutable objects representing concepts
- **Repository Interfaces**: Abstract contracts for data access
- **Domain Services**: Business logic services

**Example**:
```dart
// lib/core/entities/base_entity.dart
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;

  const BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson();
  BaseEntity fromJson(Map<String, dynamic> json);
  BaseEntity copyWith();
}
```

### **Application Layer** (`lib/features/*/presentation/`)

**Purpose**: Contains use cases and application-specific business rules.

**Components**:
- **Use Cases**: Application-specific business rules
- **DTOs**: Data Transfer Objects
- **Application Services**: Orchestrate use cases
- **State Management**: Riverpod providers and notifiers

**Example**:
```dart
// lib/features/home/presentation/controllers/home_controller.dart
class HomeController extends BaseStateNotifier<HomeState> {
  final SampleEntityRepository _repository;

  HomeController(this._repository) : super(HomeState.initial());

  Future<void> loadEntities() async {
    await handleOperation(
      operation: () async {
        setLoading();
        final entities = await _repository.getAll();
        setSuccess(HomeState.loaded(entities));
      },
    );
  }
}
```

### **Infrastructure Layer** (`lib/features/*/data/`)

**Purpose**: Contains data access implementations and external service integrations.

**Components**:
- **Data Sources**: Remote and local data sources
- **Repositories**: Concrete implementations of domain interfaces
- **Mappers**: Convert between domain and data models
- **External Services**: API clients, storage, etc.

**Example**:
```dart
// lib/features/home/data/repositories/sample_entity_repository.dart
class SampleEntityRepository extends BaseRepository<SampleEntity> {
  final SampleEntityRemoteDataSource _remoteDataSource;
  final SampleEntityLocalDataSource _localDataSource;
  final SampleEntityMapper _mapper;
  final CacheManager _cacheManager;
  final ConnectionManager _connectionManager;
  final SyncManager _syncManager;

  SampleEntityRepository({
    required SampleEntityRemoteDataSource remoteDataSource,
    required SampleEntityLocalDataSource localDataSource,
    required SampleEntityMapper mapper,
    required CacheManager cacheManager,
    required ConnectionManager connectionManager,
    required SyncManager syncManager,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _mapper = mapper,
       _cacheManager = cacheManager,
       _connectionManager = connectionManager,
       _syncManager = syncManager;

  @override
  Future<List<SampleEntity>> getAll() async {
    // Implementation with caching and offline support
  }
}
```

### **Presentation Layer** (`lib/features/*/presentation/` + `lib/ui/`)

**Purpose**: Contains UI components and user interface logic.

**Components**:
- **Screens**: Full-screen UI components
- **Widgets**: Reusable UI components
- **Controllers**: State management controllers
- **Routing**: Navigation logic

**Example**:
```dart
// lib/features/home/presentation/screens/home_screen.dart
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: homeState.when(
        initial: () => const EmptyStateWidget(),
        loading: () => const LoadingWidget(),
        loaded: (entities) => EntityListWidget(entities: entities),
        error: (error) => ErrorWidget(message: error.toString()),
      ),
    );
  }
}
```

## 🔄 **Dependency Flow**

### **Dependency Rule**
Dependencies can only point inward:
- **Presentation** → **Application** → **Domain** ← **Infrastructure**

### **Dependency Injection**
Using Riverpod for dependency injection:

```dart
// lib/features/home/presentation/providers/home_providers.dart
final sampleEntityRepositoryProvider = Provider<SampleEntityRepository>((ref) {
  return SampleEntityRepository(
    remoteDataSource: ref.watch(sampleEntityRemoteDataSourceProvider),
    localDataSource: ref.watch(sampleEntityLocalDataSourceProvider),
    mapper: ref.watch(sampleEntityMapperProvider),
    cacheManager: ref.watch(cacheManagerProvider),
    connectionManager: ref.watch(connectionManagerProvider),
    syncManager: ref.watch(syncManagerProvider),
  );
});

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref.watch(sampleEntityRepositoryProvider));
});
```

## 🛠️ **Implementation Details**

### **State Management with Riverpod**

**Base State Classes**:
```dart
// lib/core/state/base_state_notifier.dart
abstract class BaseStateNotifier<T extends BaseState> extends StateNotifier<T> {
  BaseStateNotifier(T initialState) : super(initialState);

  Future<void> handleOperation({
    required Future<void> Function() operation,
  }) async {
    try {
      setLoading();
      await operation();
    } catch (error) {
      setError(error.toString());
    }
  }

  void setLoading() {
    state = state.copyWith(isLoading: true, error: null);
  }

  void setError(String error) {
    state = state.copyWith(isLoading: false, error: error);
  }

  void setSuccess(T newState) {
    state = newState.copyWith(isLoading: false, error: null);
  }
}
```

### **Error Handling**

**Framework Exceptions**:
```dart
// lib/core/exceptions/framework_exception.dart
abstract class FrameworkException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const FrameworkException({
    required this.message,
    this.code,
    this.details,
  });
}

class ValidationException extends FrameworkException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}
```

### **Caching Strategy**

**Cache Manager**:
```dart
// lib/core/cache/cache_manager.dart
abstract class CacheManager {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value, {Duration? ttl});
  Future<void> remove(String key);
  Future<void> clear();
}

class HybridCacheManager implements CacheManager {
  final MemoryCacheManager _memoryCache;
  final PersistentCacheManager _persistentCache;

  @override
  Future<T?> get<T>(String key) async {
    // Try memory first, then persistent
    T? value = await _memoryCache.get<T>(key);
    if (value != null) return value;

    value = await _persistentCache.get<T>(key);
    if (value != null) {
      await _memoryCache.set(key, value);
    }
    return value;
  }
}
```

## ✅ **Best Practices**

### **1. Layer Separation**
- Keep domain layer pure (no Flutter dependencies)
- Use interfaces for repository contracts
- Implement dependency inversion principle

### **2. State Management**
- Use `StateNotifier` for complex state
- Use `Provider` for simple state
- Implement proper error handling
- Use `Consumer` widgets efficiently

### **3. Error Handling**
- Use framework-specific exceptions
- Implement error boundaries
- Show user-friendly error messages
- Log errors for debugging

### **4. Testing**
- Write unit tests for domain layer
- Write widget tests for UI components
- Write integration tests for use cases
- Use dependency injection for testing

### **5. Performance**
- Use `const` constructors where possible
- Implement proper caching
- Use lazy loading for large lists
- Optimize widget rebuilding

## 📝 **Examples**

### **Complete Feature Example**

**Domain Entity**:
```dart
// lib/features/user/domain/entities/user_entity.dart
class UserEntity extends TenantEntity {
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;

  const UserEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.tenantId,
    required super.tenantSlug,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    super.isDeleted = false,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'role': role.name,
    'tenantId': tenantId,
    'tenantSlug': tenantSlug,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isDeleted': isDeleted,
  };
}
```

**Use Case**:
```dart
// lib/features/user/domain/usecases/get_user_usecase.dart
class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<UserEntity> execute(String userId) async {
    return await _repository.getById(userId);
  }
}
```

**Repository Implementation**:
```dart
// lib/features/user/data/repositories/user_repository.dart
class UserRepository extends BaseRepository<UserEntity> {
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  final UserMapper _mapper;
  final CacheManager _cacheManager;

  UserRepository({
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
    required UserMapper mapper,
    required CacheManager cacheManager,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _mapper = mapper,
       _cacheManager = cacheManager;

  @override
  Future<UserEntity> getById(String id) async {
    // Check cache first
    final cached = await _cacheManager.get<UserEntity>('user_$id');
    if (cached != null) return cached;

    // Fetch from remote
    final userModel = await _remoteDataSource.getById(id);
    final user = _mapper.toEntity(userModel);

    // Cache the result
    await _cacheManager.set('user_$id', user);

    return user;
  }
}
```

**Controller**:
```dart
// lib/features/user/presentation/controllers/user_controller.dart
class UserController extends BaseStateNotifier<UserState> {
  final GetUserUseCase _getUserUseCase;

  UserController(this._getUserUseCase) : super(UserState.initial());

  Future<void> loadUser(String userId) async {
    await handleOperation(
      operation: () async {
        setLoading();
        final user = await _getUserUseCase.execute(userId);
        setSuccess(UserState.loaded(user));
      },
    );
  }
}
```

**Screen**:
```dart
// lib/features/user/presentation/screens/user_screen.dart
class UserScreen extends ConsumerWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.userDetails)),
      body: userState.when(
        initial: () => const EmptyStateWidget(),
        loading: () => const LoadingWidget(),
        loaded: (user) => UserDetailsWidget(user: user),
        error: (error) => ErrorWidget(message: error),
      ),
    );
  }
}
```

## 🎯 **Summary**

The Flutter Clean Architecture implementation provides:

- **Clear separation of concerns** between layers
- **Testable code** with dependency injection
- **Maintainable structure** with consistent patterns
- **Scalable architecture** for growing applications
- **Generic framework** reusable across domains

This architecture ensures the Flutter framework remains maintainable, testable, and scalable while following Flutter and Clean Architecture best practices.
