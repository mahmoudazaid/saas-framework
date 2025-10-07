// lib/features/home/domain/entities/sample_entity.dart

import '../../../../core/entities/tenant_entity.dart';

/// Sample entity for demonstration purposes
class SampleEntity extends TenantEntity {
  const SampleEntity({
    required super.id,
    required super.tenantId,
    required super.tenantSlug,
    required this.name,
    required this.description,
    super.createdAt,
    super.updatedAt,
  });

  final String name;
  final String description;

  @override
  SampleEntity copyWith({
    String? id,
    String? tenantId,
    String? tenantSlug,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SampleEntity(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      tenantSlug: tenantSlug ?? this.tenantSlug,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SampleEntity &&
        other.id == id &&
        other.tenantId == tenantId &&
        other.tenantSlug == tenantSlug &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => Object.hash(id, tenantId, tenantSlug, name, description);

  @override
  String toString() {
    return 'SampleEntity(id: $id, tenantId: $tenantId, tenantSlug: $tenantSlug, name: $name, description: $description)';
  }
}
