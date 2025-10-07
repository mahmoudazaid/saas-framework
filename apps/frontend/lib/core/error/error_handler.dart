// lib/core/error/error_handler.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../exceptions/framework_exception.dart';

/// Centralized error handling for the application
class ErrorHandler {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Initialize error handling
  static void initialize() {
    if (kDebugMode) {
      debugPrint('🛡️ Initializing error handling...');
    }

    // Set up global error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    }

    _logError('Flutter Error', details.exception, details.stack);
  }

  /// Handle platform errors
  static void _handlePlatformError(Object error, StackTrace stack) {
    _logError('Platform Error', error, stack);
  }

  /// Handle general errors
  static void handleError(Object error, [StackTrace? stack]) {
    _logError('General Error', error, stack);
  }

  /// Handle framework exceptions
  static void handleFrameworkException(FrameworkException exception) {
    _logError('Framework Exception', exception, null);

    // Show user-friendly error message
    _showErrorSnackBar(exception.message);
  }

  /// Show error snackbar
  static void _showErrorSnackBar(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFD32F2F), // Material Design error color
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: _getDismissText(),
          textColor: const Color(0xFFFFFFFF), // White color constant
          onPressed: () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Get dismiss text for static context
  static String _getDismissText() {
    // In a real app, you might want to use a more sophisticated approach
    // For now, we'll use the English fallback
    return 'Dismiss';
  }

  /// Log error details
  static void _logError(String type, Object error, StackTrace? stack) {
    if (kDebugMode) {
      debugPrint('❌ $type: $error');
      if (stack != null) {
        debugPrint('📍 Stack trace: $stack');
      }
    }

    // In production, you would send this to a logging service
    // Example: Sentry.captureException(error, stackTrace: stack);
  }

  /// Show error dialog
  static void showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}
