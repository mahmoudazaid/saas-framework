// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/bootstrap.dart';
import 'core/error/error_boundary.dart';
import 'core/error/error_handler.dart';
import 'core/exceptions/framework_exception.dart';
import 'core/routing/app_router.dart';
import 'l10n/app_localizations.dart';
import 'ui/styles/app_theme.dart';

/// Main application entry point
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize framework
    await Bootstrap.initialize();

    // Initialize error handling
    ErrorHandler.initialize();

    runApp(const ProviderScope(child: MyApp()));
  } catch (error) {
    // Handle initialization errors
    if (error is FrameworkException) {
      debugPrint('Framework initialization failed: ${error.message}');
    } else {
      debugPrint('Unexpected error during initialization: $error');
    }
    // Still run the app with error boundary
    runApp(const ProviderScope(child: MyApp()));
  }
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: MaterialApp.router(
        title: 'SaaS Framework',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        scaffoldMessengerKey: ErrorHandler.scaffoldMessengerKey,
      ),
    );
  }
}
