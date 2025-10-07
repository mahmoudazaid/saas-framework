# BaseEntity

The `BaseEntity` is the abstract base class for all entities in the framework.

## 📋 Table Structure

**Table Name**: `base_entities` (abstract - not a real table)

## 🏗️ Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `string` | `PRIMARY KEY`, `NOT NULL` | UUID v4 primary key |
| `createdAt` | `datetime` | `NOT NULL` | Record creation timestamp |
| `updatedAt` | `datetime` | `NOT NULL` | Record last update timestamp |
| `deletedAt` | `datetime` | `NULL` | Soft delete timestamp |

## 🔧 TypeORM Configuration

```typescript
@Entity()
export abstract class BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @DeleteDateColumn()
  deletedAt?: Date;
}
```

## 🎯 Purpose

- **Common Fields**: Provides standard fields for all entities
- **Audit Trail**: Tracks creation and modification times
- **Soft Deletes**: Enables soft deletion without data loss
- **Consistency**: Ensures all entities follow the same pattern

## 📝 Usage

```typescript
// All entities extend BaseEntity
@Entity('sample_entities')
export class SampleEntity extends BaseEntity {
  // Entity-specific fields
}
```

## 🔍 Indexes

- **Primary Key**: `id` (automatic)
- **Soft Delete**: `deleted_at` (for efficient soft delete queries)

## ⚠️ Important Notes

- **Abstract Class**: Cannot be instantiated directly
- **Soft Deletes**: Use `@DeleteDateColumn()` for soft deletion
- **Timestamps**: Automatically managed by TypeORM
- **UUID**: Uses UUID v4 for better distribution and security

---

**Last Updated**: {{ current_date }}
**Entity Type**: Abstract Base Class
**Extends**: None
