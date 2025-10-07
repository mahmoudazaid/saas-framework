// lib/core/entities/tenant_entity.dart

/// Base entity class for multi-tenancy support
abstract class TenantEntity {
  const TenantEntity({
    required this.id,
    required this.tenantId,
    required this.tenantSlug,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String tenantId;
  final String tenantSlug;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Create a copy of this entity with updated fields
  TenantEntity copyWith({
    String? id,
    String? tenantId,
    String? tenantSlug,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TenantEntity &&
        other.id == id &&
        other.tenantId == tenantId &&
        other.tenantSlug == tenantSlug;
  }

  @override
  int get hashCode => Object.hash(id, tenantId, tenantSlug);

  @override
  String toString() {
    return 'TenantEntity(id: $id, tenantId: $tenantId, tenantSlug: $tenantSlug)';
  }
}
