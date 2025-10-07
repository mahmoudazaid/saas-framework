# Error Handling Architecture

## 🚨 **Overview**

This guide explains the comprehensive error handling system in our Flutter framework. The framework provides a robust, type-safe way to handle errors at all levels of the application.

## 🏗️ **Architecture**

### **Error Handling Layers**
```
lib/
├── core/
│   ├── error/
│   │   ├── error_boundary.dart      # UI error boundary
│   │   ├── error_handler.dart       # Central error handler
│   │   └── error_interceptor.dart   # Error interceptor
│   ├── exceptions/
│   │   ├── framework_exception.dart # Base exceptions
│   │   ├── api_exception.dart       # API exceptions
│   │   └── validation_exception.dart # Validation exceptions
│   └── state/
│       └── base_state_notifier.dart # State error handling
├── features/
│   └── [feature]/
│       ├── presentation/
│       │   └── controllers/         # Feature error handling
│       └── domain/
│           └── entities/            # Domain error handling
```

## 🎯 **Error Types**

### **Framework Exceptions**
```dart
// lib/core/exceptions/framework_exception.dart
abstract class FrameworkException implements Exception {
  const FrameworkException({
    required this.message,
    this.code,
    this.details,
  });

  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  @override
  String toString() => 'FrameworkException: $message';
}

// Specific exception types
class ValidationException extends FrameworkException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkException extends FrameworkException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

class AuthenticationException extends FrameworkException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.details,
  });
}

class EntityNotFoundException extends FrameworkException {
  const EntityNotFoundException({
    required super.message,
    super.code,
    super.details,
  });
}

class OperationFailedException extends FrameworkException {
  const OperationFailedException({
    required super.message,
    super.code,
    super.details,
  });
}
```

### **API Exceptions**
```dart
// lib/core/exceptions/api_exception.dart
class ApiException extends FrameworkException {
  final int? statusCode;
  final String? endpoint;
  
  const ApiException({
    required super.message,
    this.statusCode,
    this.endpoint,
    super.code,
    super.details,
  });
  
  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timeout',
          statusCode: 0,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return const ApiException(
            message: 'Unauthorized',
            statusCode: 401,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ApiException(
            message: 'Server error',
            statusCode: statusCode,
          );
        } else {
          return ApiException(
            message: 'Request failed',
            statusCode: statusCode,
          );
        }
      default:
        return const ApiException(
          message: 'Network error',
          statusCode: 0,
        );
    }
  }
}
```

## 🛡️ **Error Boundary**

### **UI Error Boundary**
```dart
// lib/core/error/error_boundary.dart
class ErrorBoundary extends StatefulWidget {
  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  final Widget child;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = _handleFlutterError;
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    setState(() {
      _error = details.exception;
    });
    
    // Log the error
    ErrorHandler.handleError(details.exception, details.stack);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ?? 
             _DefaultErrorWidget(error: _error.toString());
    }
    
    return widget.child;
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  const _DefaultErrorWidget({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingM,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: AppSpacing.m),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: () {
                  // Restart the app or navigate to home
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Restart App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🔧 **Central Error Handler**

### **Error Handler Service**
```dart
// lib/core/error/error_handler.dart
class ErrorHandler {
  static final _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  static void handleError(Object error, StackTrace? stackTrace) {
    _instance._handleError(error, stackTrace);
  }

  static void handleFrameworkException(FrameworkException exception) {
    _instance._handleFrameworkException(exception);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _instance._showErrorSnackBar(context, message);
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    // Log the error
    _logError(error, stackTrace);
    
    // Report to crash analytics
    _reportToAnalytics(error, stackTrace);
    
    // Handle specific error types
    if (error is FrameworkException) {
      _handleFrameworkException(error);
    } else if (error is DioException) {
      _handleDioException(error);
    } else {
      _handleUnknownError(error);
    }
  }

  void _handleFrameworkException(FrameworkException exception) {
    // Log framework exception
    _logError(exception, null);
    
    // Handle specific exception types
    switch (exception.runtimeType) {
      case ValidationException:
        _handleValidationException(exception as ValidationException);
        break;
      case NetworkException:
        _handleNetworkException(exception as NetworkException);
        break;
      case AuthenticationException:
        _handleAuthenticationException(exception as AuthenticationException);
        break;
      case EntityNotFoundException:
        _handleEntityNotFoundException(exception as EntityNotFoundException);
        break;
      case OperationFailedException:
        _handleOperationFailedException(exception as OperationFailedException);
        break;
      default:
        _handleUnknownFrameworkException(exception);
    }
  }

  void _handleDioException(DioException e) {
    final apiException = ApiException.fromDioException(e);
    _handleFrameworkException(apiException);
  }

  void _handleValidationException(ValidationException exception) {
    // Show validation error to user
    _showValidationError(exception);
  }

  void _handleNetworkException(NetworkException exception) {
    // Show network error to user
    _showNetworkError(exception);
  }

  void _handleAuthenticationException(AuthenticationException exception) {
    // Navigate to login screen
    _navigateToLogin();
  }

  void _handleEntityNotFoundException(EntityNotFoundException exception) {
    // Show entity not found error
    _showEntityNotFoundError(exception);
  }

  void _handleOperationFailedException(OperationFailedException exception) {
    // Show operation failed error
    _showOperationFailedError(exception);
  }

  void _logError(Object error, StackTrace? stackTrace) {
    // Log to console in debug mode
    if (kDebugMode) {
      print('Error: $error');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
    
    // Log to crash reporting service
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  void _reportToAnalytics(Object error, StackTrace? stackTrace) {
    // Report to analytics service
    // AnalyticsService.trackError(error, stackTrace);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Additional helper methods...
}
```

## 🔄 **State Error Handling**

### **Base State Notifier with Error Handling**
```dart
// lib/core/state/base_state_notifier.dart
abstract class BaseStateNotifier<T extends BaseState> extends StateNotifier<T> {
  BaseStateNotifier(T initialState) : super(initialState);

  void setLoading() {
    state = state.copyWith(isLoading: true, error: null) as T;
  }

  void setError(String error) {
    state = state.copyWith(isLoading: false, error: error) as T;
  }

  void setSuccess([dynamic data]) {
    state = state.copyWith(
      isLoading: false,
      error: null,
      lastUpdated: DateTime.now(),
    ) as T;
  }

  Future<void> handleOperation<T>(
    Future<T> Function() operation, {
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      setLoading();
      await operation();
      setSuccess();
      if (successMessage != null) {
        _showSuccessMessage(successMessage);
      }
    } on FrameworkException catch (e) {
      setError(e.message);
      if (errorMessage != null) {
        _showErrorMessage(errorMessage);
      }
    } catch (e) {
      setError('An unexpected error occurred');
      _showErrorMessage('An unexpected error occurred');
    }
  }

  void refresh() {
    // Override in subclasses to refresh data
  }

  void retry() {
    clearError();
    refresh();
  }

  void clearError() {
    state = state.copyWith(error: null) as T;
  }

  void _showSuccessMessage(String message) {
    // Show success message
  }

  void _showErrorMessage(String message) {
    // Show error message
  }
}
```

## 🎨 **UI Error Handling**

### **Error State Widgets**
```dart
// lib/core/widgets/error_widgets.dart
class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final String? retryText;

  const ErrorStateWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingM,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryText ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingStateWidget extends StatelessWidget {
  final String? message;

  const LoadingStateWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.m),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
```

## 🧪 **Testing Error Handling**

### **Error Handling Tests**
```dart
// test/error/error_handling_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generic_framework_app/core/error/error_handler.dart';
import 'package:generic_framework_app/core/exceptions/framework_exception.dart';

void main() {
  group('Error Handling Tests', () {
    test('should handle validation exception', () {
      const exception = ValidationException(
        message: 'Invalid input',
        code: 'VALIDATION_ERROR',
      );
      
      expect(() => ErrorHandler.handleFrameworkException(exception), 
             returnsNormally);
    });
    
    test('should handle network exception', () {
      const exception = NetworkException(
        message: 'Network error',
        code: 'NETWORK_ERROR',
      );
      
      expect(() => ErrorHandler.handleFrameworkException(exception), 
             returnsNormally);
    });
    
    testWidgets('should display error boundary', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorBoundary(
            child: Builder(
              builder: (context) {
                throw Exception('Test error');
              },
            ),
          ),
        ),
      );
      
      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });
}
```

## 📚 **Best Practices**

1. **Always handle errors gracefully** with user-friendly messages
2. **Use specific exception types** for different error scenarios
3. **Log errors appropriately** for debugging and monitoring
4. **Provide retry mechanisms** for recoverable errors
5. **Show loading states** during async operations
6. **Use error boundaries** to catch unexpected errors
7. **Test error scenarios** in your test suite
8. **Report errors** to crash analytics services
9. **Provide fallback UI** for error states
10. **Handle network errors** with appropriate messaging

This error handling architecture provides a robust foundation for building reliable Flutter applications that gracefully handle all types of errors.
