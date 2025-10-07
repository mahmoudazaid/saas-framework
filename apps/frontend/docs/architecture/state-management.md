# Flutter State Management with Riverpod

> **🔄 Comprehensive State Management Guide for Flutter Framework**

This document explains how state management is implemented using Riverpod in the Flutter framework, providing reactive, testable, and maintainable state management patterns.

## 📋 **Table of Contents**

1. [State Management Overview](#state-management-overview)
2. [Riverpod Patterns](#riverpod-patterns)
3. [Base State Classes](#base-state-classes)
4. [State Notifiers](#state-notifiers)
5. [Providers](#providers)
6. [Error Handling](#error-handling)
7. [Testing State](#testing-state)
8. [Best Practices](#best-practices)
9. [Examples](#examples)

## 🔄 **State Management Overview**

The Flutter framework uses **Riverpod** as the primary state management solution, providing:

- **Reactive State**: Automatic UI updates when state changes
- **Dependency Injection**: Clean dependency management
- **Testability**: Easy mocking and testing
- **Performance**: Efficient rebuilds and caching
- **Type Safety**: Compile-time type checking

### **State Management Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                    UI Layer (Widgets)                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   Consumer      │  │  ConsumerWidget │  │   Listenable│  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                 State Management Layer                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │ StateNotifier   │  │    Provider     │  │   Future    │  │
│  │                 │  │                 │  │   Provider  │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                   Business Logic Layer                      │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   Use Cases     │  │   Services      │  │ Repositories│  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 **Riverpod Patterns**

### **1. StateNotifier Pattern**
For complex state that changes over time:

```dart
// Controller with complex state
class HomeController extends StateNotifier<HomeState> {
  HomeController() : super(HomeState.initial());

  void loadData() {
    state = state.copyWith(isLoading: true);
    // Load data logic
  }
}

// Provider for the controller
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController();
});
```

### **2. Provider Pattern**
For simple, read-only state:

```dart
// Simple provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});

// Computed provider
final filteredItemsProvider = Provider<List<Item>>((ref) {
  final items = ref.watch(itemsProvider);
  final filter = ref.watch(filterProvider);
  return items.where((item) => item.name.contains(filter)).toList();
});
```

### **3. FutureProvider Pattern**
For async data that loads once:

```dart
// Future provider
final userProvider = FutureProvider<User>((ref) async {
  final userService = ref.watch(userServiceProvider);
  return await userService.getCurrentUser();
});
```

### **4. StreamProvider Pattern**
For real-time data streams:

```dart
// Stream provider
final messagesProvider = StreamProvider<List<Message>>((ref) {
  final messageService = ref.watch(messageServiceProvider);
  return messageService.messageStream;
});
```

## 🏗️ **Base State Classes**

### **BaseState Abstract Class**

```dart
// lib/core/state/base_state_notifier.dart
abstract class BaseState {
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const BaseState({
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  BaseState copyWith({
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  });

  bool get hasError => error != null;
  bool get isSuccess => !isLoading && !hasError;
}
```

### **AsyncState for Async Operations**

```dart
// lib/core/state/base_state_notifier.dart
class AsyncState<T> extends BaseState {
  final T? data;

  const AsyncState({
    required this.data,
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  factory AsyncState.initial() => const AsyncState(data: null);
  factory AsyncState.loading() => const AsyncState(data: null, isLoading: true);
  factory AsyncState.success(T data) => AsyncState(data: data, lastUpdated: DateTime.now());
  factory AsyncState.error(String error) => AsyncState(data: null, error: error);

  @override
  AsyncState<T> copyWith({
    T? data,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return AsyncState<T>(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
```

### **BaseStateNotifier Abstract Class**

```dart
// lib/core/state/base_state_notifier.dart
abstract class BaseStateNotifier<T extends BaseState> extends StateNotifier<T> {
  BaseStateNotifier(T initialState) : super(initialState);

  /// Handle async operations with automatic loading and error states
  Future<void> handleOperation({
    required Future<void> Function() operation,
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) setLoading();
      await operation();
    } catch (error) {
      setError(error.toString());
    }
  }

  /// Set loading state
  void setLoading() {
    state = state.copyWith(isLoading: true, error: null);
  }

  /// Set error state
  void setError(String error) {
    state = state.copyWith(isLoading: false, error: error);
  }

  /// Set success state
  void setSuccess(T newState) {
    state = newState.copyWith(
      isLoading: false,
      error: null,
      lastUpdated: DateTime.now(),
    );
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh data
  Future<void> refresh() async {
    // Override in subclasses
  }

  /// Retry failed operation
  Future<void> retry() async {
    clearError();
    await refresh();
  }
}
```

## 🎮 **State Notifiers**

### **Feature-Specific State Notifiers**

```dart
// lib/features/home/presentation/controllers/home_controller.dart
class HomeController extends BaseStateNotifier<HomeState> {
  final SampleEntityRepository _repository;

  HomeController(this._repository) : super(HomeState.initial());

  Future<void> loadEntities() async {
    await handleOperation(
      operation: () async {
        final entities = await _repository.getAll();
        setSuccess(HomeState.loaded(entities));
      },
    );
  }

  Future<void> createEntity(SampleEntity entity) async {
    await handleOperation(
      operation: () async {
        final createdEntity = await _repository.create(entity);
        final currentEntities = state.entities;
        setSuccess(HomeState.loaded([...currentEntities, createdEntity]));
      },
    );
  }

  Future<void> updateEntity(String id, SampleEntity entity) async {
    await handleOperation(
      operation: () async {
        final updatedEntity = await _repository.update(id, entity);
        final currentEntities = state.entities;
        final updatedEntities = currentEntities.map((e) => e.id == id ? updatedEntity : e).toList();
        setSuccess(HomeState.loaded(updatedEntities));
      },
    );
  }

  Future<void> deleteEntity(String id) async {
    await handleOperation(
      operation: () async {
        await _repository.delete(id);
        final currentEntities = state.entities;
        final filteredEntities = currentEntities.where((e) => e.id != id).toList();
        setSuccess(HomeState.loaded(filteredEntities));
      },
    );
  }

  @override
  Future<void> refresh() async {
    await loadEntities();
  }
}
```

### **State Classes**

```dart
// lib/features/home/presentation/controllers/home_controller.dart
class HomeState extends BaseState {
  final List<SampleEntity> entities;

  const HomeState({
    required this.entities,
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  factory HomeState.initial() => const HomeState(entities: []);
  factory HomeState.loaded(List<SampleEntity> entities) => HomeState(
    entities: entities,
    lastUpdated: DateTime.now(),
  );

  @override
  HomeState copyWith({
    List<SampleEntity>? entities,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return HomeState(
      entities: entities ?? this.entities,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        listEquals(other.entities, entities) &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode => Object.hash(entities, isLoading, error, lastUpdated);
}
```

## 🔌 **Providers**

### **Dependency Injection Providers**

```dart
// lib/features/home/presentation/providers/home_providers.dart

// Repository providers
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

// Controller providers
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref.watch(sampleEntityRepositoryProvider));
});

// Service providers
final cacheManagerProvider = Provider<CacheManager>((ref) {
  return HybridCacheManager(
    memoryCache: MemoryCacheManager(),
    persistentCache: PersistentCacheManager(),
  );
});

final connectionManagerProvider = Provider<ConnectionManager>((ref) {
  return ConnectionManager();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  return SyncManager(
    connectionManager: ref.watch(connectionManagerProvider),
  );
});
```

### **Computed Providers**

```dart
// lib/features/home/presentation/providers/home_providers.dart

// Filtered entities provider
final filteredEntitiesProvider = Provider<List<SampleEntity>>((ref) {
  final entities = ref.watch(homeControllerProvider).entities;
  final searchQuery = ref.watch(searchQueryProvider);
  
  if (searchQuery.isEmpty) return entities;
  
  return entities.where((entity) => 
    entity.name.toLowerCase().contains(searchQuery.toLowerCase())
  ).toList();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected entity provider
final selectedEntityProvider = StateProvider<SampleEntity?>((ref) => null);
```

## ⚠️ **Error Handling**

### **Error State Management**

```dart
// lib/core/error/error_handler.dart
class ErrorHandler {
  static void handleError(Object error, StackTrace stackTrace) {
    // Log error
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // Show user-friendly error message
    // This would typically show a snackbar or dialog
  }

  static void handleFrameworkException(FrameworkException exception) {
    debugPrint('Framework Exception: ${exception.message}');
    debugPrint('Code: ${exception.code}');
    debugPrint('Details: ${exception.details}');
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
```

### **Error Boundary Widget**

```dart
// lib/core/error/error_boundary.dart
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ?? 
        ErrorWidget(message: _error.toString());
    }
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _error = details.exception;
      });
    };
  }
}
```

## 🧪 **Testing State**

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
  });
}
```

### **Testing Providers**

```dart
// test/features/home/presentation/providers/home_providers_test.dart
void main() {
  group('Home Providers', () {
    test('homeControllerProvider should provide HomeController', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          sampleEntityRepositoryProvider.overrideWithValue(MockSampleEntityRepository()),
        ],
      );

      // Act
      final controller = container.read(homeControllerProvider.notifier);

      // Assert
      expect(controller, isA<HomeController>());
    });

    test('filteredEntitiesProvider should filter entities by search query', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          homeControllerProvider.overrideWithValue(
            HomeState.loaded([
              SampleEntity.sample(name: 'Apple'),
              SampleEntity.sample(name: 'Banana'),
            ]),
          ),
          searchQueryProvider.overrideWithValue('Apple'),
        ],
      );

      // Act
      final filteredEntities = container.read(filteredEntitiesProvider);

      // Assert
      expect(filteredEntities, hasLength(1));
      expect(filteredEntities.first.name, equals('Apple'));
    });
  });
}
```

## ✅ **Best Practices**

### **1. State Design**
- Keep state immutable
- Use `copyWith` methods for updates
- Implement proper equality and hashCode
- Separate loading, error, and data states

### **2. State Notifiers**
- Use `BaseStateNotifier` for common patterns
- Handle errors consistently
- Implement proper loading states
- Use `handleOperation` for async operations

### **3. Providers**
- Use appropriate provider types
- Implement proper dependency injection
- Use computed providers for derived state
- Keep providers focused and single-purpose

### **4. Error Handling**
- Use framework-specific exceptions
- Implement error boundaries
- Show user-friendly error messages
- Log errors for debugging

### **5. Testing**
- Test state changes
- Mock dependencies
- Test error scenarios
- Use provider overrides for testing

## 📝 **Examples**

### **Complete Feature State Management**

```dart
// lib/features/user/presentation/controllers/user_controller.dart
class UserController extends BaseStateNotifier<UserState> {
  final UserRepository _repository;

  UserController(this._repository) : super(UserState.initial());

  Future<void> loadUser(String userId) async {
    await handleOperation(
      operation: () async {
        final user = await _repository.getById(userId);
        setSuccess(UserState.loaded(user));
      },
    );
  }

  Future<void> updateUser(UserEntity user) async {
    await handleOperation(
      operation: () async {
        final updatedUser = await _repository.update(user.id, user);
        setSuccess(UserState.loaded(updatedUser));
      },
    );
  }
}

// lib/features/user/presentation/controllers/user_controller.dart
class UserState extends BaseState {
  final UserEntity? user;

  const UserState({
    this.user,
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  factory UserState.initial() => const UserState();
  factory UserState.loaded(UserEntity user) => UserState(
    user: user,
    lastUpdated: DateTime.now(),
  );

  @override
  UserState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// lib/features/user/presentation/providers/user_providers.dart
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    remoteDataSource: ref.watch(userRemoteDataSourceProvider),
    localDataSource: ref.watch(userLocalDataSourceProvider),
    mapper: ref.watch(userMapperProvider),
    cacheManager: ref.watch(cacheManagerProvider),
  );
});

final userControllerProvider = StateNotifierProvider<UserController, UserState>((ref) {
  return UserController(ref.watch(userRepositoryProvider));
});

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

The Flutter state management implementation provides:

- **Reactive State**: Automatic UI updates with Riverpod
- **Clean Architecture**: Separation of concerns
- **Error Handling**: Comprehensive error management
- **Testing**: Easy mocking and testing
- **Performance**: Efficient rebuilds and caching
- **Type Safety**: Compile-time type checking

This state management system ensures the Flutter framework remains maintainable, testable, and performant while following Flutter and Riverpod best practices.
