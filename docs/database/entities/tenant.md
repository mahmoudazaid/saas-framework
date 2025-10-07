# Tenant

The `Tenant` entity represents a tenant/organization in the multi-tenant system.

## 📋 Table Structure

**Table Name**: `tenants`

## 🏗️ Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `string` | `PRIMARY KEY`, `NOT NULL` | UUID v4 primary key |
| `name` | `string` | `NOT NULL`, `UNIQUE` | Tenant display name |
| `slug` | `string` | `NOT NULL`, `UNIQUE` | URL-friendly identifier |
| `description` | `string` | `NULL` | Tenant description |
| `isActive` | `boolean` | `NOT NULL`, `DEFAULT true` | Tenant status |
| `createdAt` | `datetime` | `NOT NULL` | Record creation timestamp |
| `updatedAt` | `datetime` | `NOT NULL` | Record last update timestamp |
| `deletedAt` | `datetime` | `NULL` | Soft delete timestamp |

## 🔧 TypeORM Configuration

```typescript
@Entity('tenants')
export class Tenant extends BaseEntity {
  @Column({ unique: true })
  name: string;

  @Column({ unique: true })
  slug: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: true })
  isActive: boolean;

  @OneToMany(() => User, user => user.tenant)
  users: User[];

  @OneToMany(() => SampleEntity, entity => entity.tenant)
  sampleEntities: SampleEntity[];
}
```

## 🎯 Purpose

- **Tenant Management**: Central tenant information storage
- **Multi-Tenancy**: Enables data isolation between tenants
- **Tenant Context**: Provides tenant identification for all operations
- **Organization Data**: Stores tenant-specific configuration

## 📝 Usage

```typescript
// Create a new tenant
const tenant = new Tenant();
tenant.name = 'Acme Corporation';
tenant.slug = 'acme-corp';
tenant.description = 'Software development company';
tenant.isActive = true;

await tenantRepository.save(tenant);
```

## 🔗 Relationships

- **Users**: `OneToMany` relationship with `User` entity
- **Sample Entities**: `OneToMany` relationship with `SampleEntity`
- **Products**: `OneToMany` relationship with `Product`
- **Subscriptions**: `OneToMany` relationship with `Subscription`

## 🔍 Indexes

- **Primary Key**: `id` (automatic)
- **Unique Name**: `idx_tenants_name_unique`
- **Unique Slug**: `idx_tenants_slug_unique`
- **Active Status**: `idx_tenants_is_active`
- **Soft Delete**: `idx_tenants_deleted_at`

## ⚠️ Important Notes

- **Unique Constraints**: Both `name` and `slug` must be unique
- **Slug Format**: Should be URL-friendly (lowercase, hyphens)
- **Active Status**: Inactive tenants cannot be used for new operations
- **Soft Deletes**: Supports soft deletion for data retention

## 🚀 Query Examples

```typescript
// Find active tenant by slug
const tenant = await tenantRepository.findOne({
  where: { slug: 'acme-corp', isActive: true }
});

// Find all active tenants
const tenants = await tenantRepository.find({
  where: { isActive: true }
});

// Soft delete tenant
await tenantRepository.softDelete({ id: 'tenant-uuid' });
```

## 🔒 Security Considerations

- **Tenant Isolation**: All data must be filtered by tenant
- **Slug Validation**: Ensure slug is URL-safe and unique
- **Access Control**: Only authorized users can manage tenants
- **Data Integrity**: Prevent orphaned data when deleting tenants

---

**Last Updated**: {{ current_date }}
**Entity Type**: Multi-Tenant Root Entity
**Extends**: BaseEntity
