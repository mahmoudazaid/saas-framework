# API Integration Guide

## 🌐 **Overview**

This guide explains how to integrate with backend APIs in our Flutter framework. The framework provides a clean, type-safe way to communicate with REST APIs.

## 🏗️ **Architecture**

### **API Layer Structure**
```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart          # HTTP client wrapper
│   │   ├── api_endpoints.dart       # API endpoint definitions
│   │   └── api_interceptors.dart    # Request/response interceptors
│   └── models/
│       ├── api_response.dart        # Generic API response wrapper
│       └── pagination.dart          # Pagination models
├── features/
│   └── [feature]/
│       ├── data/
│       │   ├── models/              # API data models
│       │   └── repositories/        # API repository implementations
│       └── domain/
│           └── entities/            # Domain entities
```

## 🔧 **API Client Setup**

### **Base API Client**
```dart
// lib/core/api/api_client.dart
class ApiClient {
  final Dio _dio;
  final String baseUrl;
  
  ApiClient({
    required this.baseUrl,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      LogInterceptor(),
      AuthInterceptor(),
      ErrorInterceptor(),
    ]);
  }
  
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      
      return ApiResponse<T>.fromJson(
        response.data,
        fromJson: fromJson,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }
  
  // Similar methods for POST, PUT, DELETE...
}
```

### **API Endpoints**
```dart
// lib/core/api/api_endpoints.dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com';
  
  // Entity endpoints
  static const String entities = '/entities';
  static String entity(String id) => '/entities/$id';
  
  // Health check
  static const String health = '/health';
  
  // Authentication
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
}
```

## 📊 **Data Models**

### **Generic API Response**
```dart
// lib/core/models/api_response.dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final Map<String, dynamic>? errors;
  final Pagination? pagination;
  
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.errors,
    this.pagination,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    {T Function(Map<String, dynamic>)? fromJson}
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      data: json['data'] != null && fromJson != null 
          ? fromJson(json['data']) 
          : null,
      message: json['message'],
      errors: json['errors'],
      pagination: json['pagination'] != null 
          ? Pagination.fromJson(json['pagination']) 
          : null,
    );
  }
}
```

### **Pagination Model**
```dart
// lib/core/models/pagination.dart
class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  
  const Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
  
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}
```

## 🔄 **Repository Pattern**

### **Base Repository Interface**
```dart
// lib/core/repositories/base_repository.dart
abstract class BaseRepository<T> {
  Future<List<T>> getAll({
    int page = 1,
    int limit = 10,
    Map<String, dynamic>? filters,
  });
  
  Future<T?> getById(String id);
  Future<T> create(T entity);
  Future<T> update(String id, T entity);
  Future<void> delete(String id);
}
```

### **API Repository Implementation**
```dart
// lib/features/entity/data/repositories/entity_api_repository.dart
class EntityApiRepository implements BaseRepository<Entity> {
  final ApiClient _apiClient;
  
  EntityApiRepository(this._apiClient);
  
  @override
  Future<List<Entity>> getAll({
    int page = 1,
    int limit = 10,
    Map<String, dynamic>? filters,
  }) async {
    final response = await _apiClient.get<List<Entity>>(
      ApiEndpoints.entities,
      queryParameters: {
        'page': page,
        'limit': limit,
        ...?filters,
      },
      fromJson: (json) => Entity.fromJson(json),
    );
    
    if (!response.success || response.data == null) {
      throw ApiException('Failed to fetch entities');
    }
    
    return response.data!;
  }
  
  @override
  Future<Entity?> getById(String id) async {
    final response = await _apiClient.get<Entity>(
      ApiEndpoints.entity(id),
      fromJson: (json) => Entity.fromJson(json),
    );
    
    if (!response.success) {
      return null;
    }
    
    return response.data;
  }
  
  // Implement other methods...
}
```

## 🚨 **Error Handling**

### **API Exceptions**
```dart
// lib/core/exceptions/api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  
  const ApiException(
    this.message, {
    this.statusCode,
    this.errors,
  });
  
  @override
  String toString() => 'ApiException: $message';
}

class NetworkException extends ApiException {
  const NetworkException(super.message) : super(statusCode: 0);
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode});
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message) : super(statusCode: 401);
}
```

### **Error Interceptor**
```dart
// lib/core/api/api_interceptors.dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiException apiException;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiException = const NetworkException('Connection timeout');
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) {
          apiException = const UnauthorizedException('Unauthorized');
        } else if (statusCode != null && statusCode >= 500) {
          apiException = ServerException('Server error', statusCode: statusCode);
        } else {
          apiException = ApiException(
            'Request failed',
            statusCode: statusCode,
          );
        }
        break;
      default:
        apiException = const NetworkException('Network error');
    }
    
    handler.reject(DioException(
      requestOptions: err.requestOptions,
      error: apiException,
    ));
  }
}
```

## 🔐 **Authentication**

### **Auth Interceptor**
```dart
// lib/core/api/api_interceptors.dart
class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  
  AuthInterceptor(this._authService);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _authService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _authService.refreshToken();
      if (refreshed) {
        // Retry the request
        final response = await _apiClient.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      }
    }
    handler.next(err);
  }
}
```

## 📱 **Usage Examples**

### **Using in State Management**
```dart
// lib/features/entity/presentation/controllers/entity_controller.dart
class EntityController extends BaseStateNotifier<EntityState> {
  final BaseRepository<Entity> _repository;
  
  EntityController(this._repository) : super(EntityState.initial());
  
  Future<void> loadEntities() async {
    setLoading();
    
    try {
      final entities = await _repository.getAll();
      setSuccess(entities);
    } on ApiException catch (e) {
      setError(e.message);
    } catch (e) {
      setError('An unexpected error occurred');
    }
  }
  
  Future<void> createEntity(Entity entity) async {
    try {
      final createdEntity = await _repository.create(entity);
      final currentEntities = state.entities;
      setSuccess([...currentEntities, createdEntity]);
    } on ApiException catch (e) {
      setError(e.message);
    }
  }
}
```

### **Dependency Injection**
```dart
// lib/core/di/api_providers.dart
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiEndpoints.baseUrl,
  );
});

final entityRepositoryProvider = Provider<BaseRepository<Entity>>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return EntityApiRepository(apiClient);
});
```

## 🧪 **Testing API Integration**

### **Mock API Client**
```dart
// test/mocks/mock_api_client.dart
class MockApiClient implements ApiClient {
  @override
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    // Mock implementation
    return ApiResponse<T>(
      success: true,
      data: mockData,
    );
  }
}
```

### **API Integration Tests**
```dart
// test/integration/api_integration_test.dart
group('API Integration Tests', () {
  late ApiClient apiClient;
  
  setUp(() {
    apiClient = ApiClient(
      baseUrl: 'https://api.test.com',
      dio: DioAdapterMock(),
    );
  });
  
  test('should fetch entities successfully', () async {
    // Test implementation
  });
  
  test('should handle network errors', () async {
    // Test implementation
  });
}, tags: TestTags.apiIntegration);
```

## 📚 **Best Practices**

1. **Always use the repository pattern** for API calls
2. **Handle errors consistently** using custom exceptions
3. **Use type-safe models** for API responses
4. **Implement proper authentication** with token refresh
5. **Add request/response logging** for debugging
6. **Use interceptors** for cross-cutting concerns
7. **Test API integration** with mocks and real endpoints
8. **Handle pagination** for large datasets
9. **Implement retry logic** for network failures
10. **Cache responses** when appropriate

This API integration guide provides a solid foundation for building robust, maintainable API integrations in your Flutter applications.
