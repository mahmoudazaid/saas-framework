// lib/core/config/bootstrap.dart

import 'package:flutter/foundation.dart';
import '../exceptions/framework_exception.dart';

/// Bootstrap class for initializing the framework
class Bootstrap {
  /// Initialize the framework
  static Future<void> initialize() async {
    try {
      if (kDebugMode) {
        debugPrint('🚀 Initializing Gym Manager...');
      }

      // Initialize logging
      _initializeLogging();

      // Initialize services
      await _initializeServices();

      if (kDebugMode) {
        debugPrint('✅ Generic Framework initialized successfully');
      }
    } catch (e) {
      throw FrameworkException(
        message: 'Failed to initialize framework',
        originalError: e,
        context: 'Bootstrap.initialize',
      );
    }
  }

  /// Initialize logging
  static void _initializeLogging() {
    if (kDebugMode) {
      debugPrint('📝 Initializing logging...');
    }
  }

  /// Initialize core services
  static Future<void> _initializeServices() async {
    try {
      if (kDebugMode) {
        debugPrint('🔧 Initializing services...');
      }

      // Add service initialization here
      // Example: await CacheManager.initialize();
      // Example: await ConnectionManager.initialize();
    } catch (e) {
      throw FrameworkException(
        message: 'Failed to initialize services',
        originalError: e,
        context: 'Bootstrap._initializeServices',
      );
    }
  }
}
