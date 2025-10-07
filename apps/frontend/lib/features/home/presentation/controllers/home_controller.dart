// lib/features/home/presentation/controllers/home_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/framework_exception.dart';
import '../../../../core/services/tenant_context_service.dart';
import '../../../../core/state/base_state_notifier.dart';

/// Home screen state
class HomeState extends BaseState {
  const HomeState({
    super.isLoading,
    super.error,
    super.lastUpdated,
  });

  factory HomeState.initial() => const HomeState();
  factory HomeState.loading() => const HomeState(isLoading: true);
  factory HomeState.error(String error) => HomeState(error: error);

  @override
  HomeState copyWith({
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Home screen controller
/// TODO: Add business-specific logic when implementing your entities
class HomeController extends BaseStateNotifier<HomeState> {
  HomeController() : super(HomeState.initial());

  /// Initialize home screen data
  Future<void> initialize() async {
    try {
      setLoading();

      // TODO: Add your business logic here
      // Example: Load user data, fetch entities, etc.

      // For now, just simulate initialization
      await Future.delayed(const Duration(milliseconds: 500));

      setSuccess(HomeState.initial());
    } catch (error) {
      if (error is FrameworkException) {
        setError(error.message);
      } else {
        setError(FrameworkException(
          message: 'Failed to initialize home screen',
          originalError: error,
          context: 'HomeController.initialize',
        ).message);
      }
    }
  }

  /// Refresh home screen data
  Future<void> refresh() async {
    try {
      await initialize();
    } catch (error) {
      if (error is FrameworkException) {
        setError(error.message);
      } else {
        setError(FrameworkException(
          message: 'Failed to refresh home screen',
          originalError: error,
          context: 'HomeController.refresh',
        ).message);
      }
    }
  }

  /// Get current tenant context
  String? get currentTenantId => TenantContextService.instance.tenantId;
  String? get currentTenantSlug => TenantContextService.instance.tenantSlug;
}

/// Home controller provider
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) => HomeController(),
);
