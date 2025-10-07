// lib/core/services/tenant_context_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../exceptions/framework_exception.dart';

/// Service for managing tenant context across the application
class TenantContextService {
  TenantContextService._();
  static const String _tenantIdKey = 'tenant_id';
  static const String _tenantSlugKey = 'tenant_slug';

  static TenantContextService? _instance;
  static TenantContextService get instance =>
      _instance ??= TenantContextService._();

  String? _tenantId;
  String? _tenantSlug;

  /// Get current tenant ID
  String? get tenantId => _tenantId;

  /// Get current tenant slug
  String? get tenantSlug => _tenantSlug;

  /// Check if tenant context is set
  bool get hasTenantContext => _tenantId != null && _tenantSlug != null;

  /// Initialize tenant context from storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _tenantId = prefs.getString(_tenantIdKey);
      _tenantSlug = prefs.getString(_tenantSlugKey);
    } catch (e) {
      // Handle error silently for now
      _tenantId = null;
      _tenantSlug = null;
    }
  }

  /// Set tenant context
  Future<void> setTenantContext({
    required String tenantId,
    required String tenantSlug,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tenantIdKey, tenantId);
      await prefs.setString(_tenantSlugKey, tenantSlug);

      _tenantId = tenantId;
      _tenantSlug = tenantSlug;
    } catch (e) {
      throw FrameworkException(
        message: 'Failed to set tenant context',
        originalError: e,
        context: 'TenantContextService.setTenantContext',
      );
    }
  }

  /// Clear tenant context
  Future<void> clearTenantContext() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tenantIdKey);
      await prefs.remove(_tenantSlugKey);

      _tenantId = null;
      _tenantSlug = null;
    } catch (e) {
      throw FrameworkException(
        message: 'Failed to clear tenant context',
        originalError: e,
        context: 'TenantContextService.clearTenantContext',
      );
    }
  }

  /// Get tenant context for API calls
  Map<String, String> getTenantHeaders() {
    if (!hasTenantContext) {
      return {};
    }

    return {
      'X-Tenant-ID': _tenantId!,
      'X-Tenant-Slug': _tenantSlug!,
    };
  }

  /// Get tenant context for URL routing
  String getTenantRoute(String baseRoute) {
    if (_tenantSlug == null) {
      return baseRoute;
    }

    return '/tenant/$_tenantSlug$baseRoute';
  }
}
