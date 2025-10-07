// lib/features/splash/presentation/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/exceptions/framework_exception.dart';
import '../../../../core/services/tenant_context_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../ui/styles/app_styles.dart';

/// Splash screen displayed on app launch
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeTenantContext();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _initializeTenantContext() async {
    try {
      // Initialize tenant context service
      await TenantContextService.instance.initialize();

      // For demo purposes, set a default tenant if none exists
      if (!TenantContextService.instance.hasTenantContext) {
        await TenantContextService.instance.setTenantContext(
          tenantId: 'default-tenant-id',
          tenantSlug: 'default-tenant',
        );
      }

      // Navigate to home after initialization
      _navigateToHome();
    } catch (e) {
      // Handle tenant context initialization error
      final error = e is FrameworkException
          ? e
          : FrameworkException(
              message: 'Failed to initialize tenant context',
              originalError: e,
              context: 'SplashScreen._initializeTenantContext',
            );
      debugPrint('Failed to initialize tenant context: ${error.message}');
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Use tenant-aware routing
        final tenantService = TenantContextService.instance;
        final homeRoute = tenantService.getTenantRoute('/home');
        context.go(homeRoute);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.apps,
                size: AppStyles.iconXL * 2,
                color: Theme.of(context).colorScheme.onPrimary,
                semanticLabel: AppLocalizations.of(context)!.applicationLogo,
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                AppLocalizations.of(context)!.appSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withValues(alpha: 0.8),
                    ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Semantics(
                label: AppLocalizations.of(context)!.loadingApplication,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
