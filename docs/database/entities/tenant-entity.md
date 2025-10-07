# TenantEntity

The `TenantEntity` is the base class for all multi-tenant entities in the framework.

## 📋 Table Structure

**Table Name**: `tenant_entities` (abstract - not a real table)

## 🏗️ Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `string` | `PRIMARY KEY`, `NOT NULL` | UUID v4 primary key (inherited) |
| `createdAt` | `datetime` | `NOT NULL` | Record creation timestamp (inherited) |
| `updatedAt` | `datetime` | `NOT NULL` | Record last update timestamp (inherited) |
| `deletedAt` | `datetime` | `NULL` | Soft delete timestamp (inherited) |
| `tenantId` | `string` | `NOT NULL`, `FOREIGN KEY` | Tenant identifier |
| `tenantSlug` | `string` | `NOT NULL` | Human-readable tenant identifier |

## 🔧 TypeORM Configuration

```typescript
@Entity()
export abstract class TenantEntity extends BaseEntity {
  @Column()
  tenantId: string;

  @Column()
  tenantSlug: string;

  @ManyToOne(() => Tenant)
  @JoinColumn({ name: 'tenantId' })
  tenant: Tenant;
}
```

## 🎯 Purpose

- **Multi-Tenancy**: Enables tenant isolation for all entities
- **Tenant Context**: Provides tenant identification fields
- **Data Segregation**: Ensures data belongs to specific tenants
- **Framework Pattern**: Standard pattern for tenant-aware entities

## 📝 Usage

```typescript
// All tenant-aware entities extend TenantEntity
@Entity('sample_entities')
export class SampleEntity extends TenantEntity {
  @Column()
  name: string;

  @Column()
  description: string;
}
```

## 🔗 Relationships

- **Tenant**: `ManyToOne` relationship with `Tenant` entity
- **Foreign Key**: `tenantId` references `tenants.id`

## 🔍 Indexes

- **Tenant ID**: `idx_{table}_tenant_id` (for efficient tenant queries)
- **Tenant Slug**: `idx_{table}_tenant_slug` (for human-readable queries)
- **Composite**: `idx_{table}_tenant_id_deleted_at` (for soft delete queries)

## ⚠️ Important Notes

- **Abstract Class**: Cannot be instantiated directly
- **Tenant Isolation**: All queries must filter by `tenantId`
- **Required Fields**: Both `tenantId` and `tenantSlug` are required
- **Data Integrity**: Foreign key constraint ensures valid tenant references

## 🚀 Query Examples

```typescript
// Find all entities for a specific tenant
const entities = await repository.find({
  where: { tenantId: 'tenant-uuid' }
});

// Find by tenant slug
const entities = await repository.find({
  where: { tenantSlug: 'tenant-slug' }
});

// Soft delete with tenant context
await repository.softDelete({
  id: 'entity-uuid',
  tenantId: 'tenant-uuid'
});
```

---

**Last Updated**: {{ current_date }}
**Entity Type**: Abstract Multi-Tenant Base Class
**Extends**: BaseEntity
