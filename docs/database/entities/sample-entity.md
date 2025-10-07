# SampleEntity

The `SampleEntity` is an example entity demonstrating framework patterns and multi-tenancy.

## 📋 Table Structure

**Table Name**: `sample_entities`

## 🏗️ Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `string` | `PRIMARY KEY`, `NOT NULL` | UUID v4 primary key |
| `tenantId` | `string` | `NOT NULL`, `FOREIGN KEY` | Tenant identifier |
| `tenantSlug` | `string` | `NOT NULL` | Human-readable tenant identifier |
| `name` | `string` | `NOT NULL` | Entity name |
| `description` | `string` | `NULL` | Entity description |
| `isActive` | `boolean` | `NOT NULL`, `DEFAULT true` | Entity status |
| `createdAt` | `datetime` | `NOT NULL` | Record creation timestamp |
| `updatedAt` | `datetime` | `NOT NULL` | Record last update timestamp |
| `deletedAt` | `datetime` | `NULL` | Soft delete timestamp |

## 🔧 TypeORM Configuration

```typescript
@Entity('sample_entities')
export class SampleEntity extends TenantEntity {
  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => Tenant)
  @JoinColumn({ name: 'tenantId' })
  tenant: Tenant;
}
```

## 🎯 Purpose

- **Framework Example**: Demonstrates proper entity structure
- **Multi-Tenancy**: Shows tenant-aware entity implementation
- **Pattern Reference**: Template for creating new entities
- **Testing**: Used for framework testing and validation

## 📝 Usage

```typescript
// Create a new sample entity
const sampleEntity = new SampleEntity();
sampleEntity.tenantId = 'tenant-uuid';
sampleEntity.tenantSlug = 'tenant-slug';
sampleEntity.name = 'Sample Item';
sampleEntity.description = 'This is a sample entity';
sampleEntity.isActive = true;

await sampleEntityRepository.save(sampleEntity);
```

## 🔗 Relationships

- **Tenant**: `ManyToOne` relationship with `Tenant` entity
- **Foreign Key**: `tenantId` references `tenants.id`

## 🔍 Indexes

- **Primary Key**: `id` (automatic)
- **Tenant ID**: `idx_sample_entities_tenant_id`
- **Tenant Slug**: `idx_sample_entities_tenant_slug`
- **Name**: `idx_sample_entities_name`
- **Active Status**: `idx_sample_entities_is_active`
- **Soft Delete**: `idx_sample_entities_deleted_at`

## ⚠️ Important Notes

- **Tenant Isolation**: All queries must filter by `tenantId`
- **Name Required**: Name field is required for all entities
- **Active Status**: Inactive entities are hidden from normal queries
- **Soft Deletes**: Supports soft deletion for data retention

## 🚀 Query Examples

```typescript
// Find entities by tenant
const entities = await sampleEntityRepository.find({
  where: { tenantId: 'tenant-uuid' }
});

// Find active entities by tenant
const activeEntities = await sampleEntityRepository.find({
  where: { tenantId: 'tenant-uuid', isActive: true }
});

// Find by name within tenant
const entity = await sampleEntityRepository.findOne({
  where: { 
    tenantId: 'tenant-uuid', 
    name: 'Sample Item' 
  }
});

// Soft delete entity
await sampleEntityRepository.softDelete({ 
  id: 'entity-uuid',
  tenantId: 'tenant-uuid'
});
```

## 🔄 Business Logic

### **Validation Rules**
- Name must be unique within tenant
- Description is optional but recommended
- Active status defaults to true

### **Tenant Context**
- All operations require tenant context
- Data is automatically filtered by tenant
- Cross-tenant access is prevented

## 📋 API Endpoints

- **GET** `/api/sample-entities` - List entities for current tenant
- **POST** `/api/sample-entities` - Create new entity
- **GET** `/api/sample-entities/:id` - Get entity by ID
- **PUT** `/api/sample-entities/:id` - Update entity
- **DELETE** `/api/sample-entities/:id` - Soft delete entity

## 🔒 Security Considerations

- **Tenant Isolation**: Users can only access their tenant's data
- **Input Validation**: Validate all input data
- **Authorization**: Check user permissions before operations
- **Audit Trail**: Track all changes for compliance

---

**Last Updated**: {{ current_date }}
**Entity Type**: Multi-Tenant Entity
**Extends**: TenantEntity
