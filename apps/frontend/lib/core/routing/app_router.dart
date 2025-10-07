// lib/core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/styles/app_styles.dart';

/// Application router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppStyles.iconXXL,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              AppLocalizations.of(context)!.pageNotFound,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              AppLocalizations.of(context)!.pageNotFoundDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text(AppLocalizations.of(context)!.goHome),
            ),
          ],
        ),
      ),
    ),
  );
}
