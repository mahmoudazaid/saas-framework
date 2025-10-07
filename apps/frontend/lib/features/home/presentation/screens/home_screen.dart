// lib/features/home/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../ui/styles/app_styles.dart';
import '../controllers/home_controller.dart';

/// Home screen with state management
/// TODO: Implement your business-specific home screen content
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize home screen data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);
    final homeController = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: homeController.refresh,
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.refresh,
          ),
        ],
      ),
      body: _buildBody(context, homeState, homeController),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state, HomeController controller) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return Center(
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
              AppLocalizations.of(context)!.errorOccurred,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.l),
            ElevatedButton(
              onPressed: controller.refresh,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home,
            size: AppStyles.iconXXL,
            color: Theme.of(context).colorScheme.primary,
            semanticLabel: AppLocalizations.of(context)!.homeTitle,
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            AppLocalizations.of(context)!.welcomeToFramework,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            AppLocalizations.of(context)!.createEntityNotImplemented,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
          if (controller.currentTenantSlug != null) ...[
            const SizedBox(height: AppSpacing.l),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.s),
              ),
              child: Text(
                'Tenant: ${controller.currentTenantSlug}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
