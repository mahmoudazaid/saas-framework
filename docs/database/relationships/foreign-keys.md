# Foreign Key Constraints

This document lists all foreign key constraints in the database schema.

## 🔗 Foreign Key Overview

| Constraint Name | Table | Column | References | On Delete | On Update |
|----------------|-------|--------|------------|-----------|-----------|
| `users_tenant_id_fk` | `users` | `tenant_id` | `tenants.id` | RESTRICT | CASCADE |
| `sample_entities_tenant_id_fk` | `sample_entities` | `tenant_id` | `tenants.id` | RESTRICT | CASCADE |
| `products_tenant_id_fk` | `products` | `tenant_id` | `tenants.id` | RESTRICT | CASCADE |
| `subscriptions_tenant_id_fk` | `subscriptions` | `tenant_id` | `tenants.id` | RESTRICT | CASCADE |

## 📋 Detailed Foreign Key Information

### **1. Users → Tenants**
- **Constraint**: `users_tenant_id_fk`
- **Table**: `users`
- **Column**: `tenant_id`
- **References**: `tenants.id`
- **On Delete**: `RESTRICT` (prevents tenant deletion if users exist)
- **On Update**: `CASCADE` (updates tenant ID if tenant ID changes)

### **2. Sample Entities → Tenants**
- **Constraint**: `sample_entities_tenant_id_fk`
- **Table**: `sample_entities`
- **Column**: `tenant_id`
- **References**: `tenants.id`
- **On Delete**: `RESTRICT` (prevents tenant deletion if entities exist)
- **On Update**: `CASCADE` (updates tenant ID if tenant ID changes)

### **3. Products → Tenants**
- **Constraint**: `products_tenant_id_fk`
- **Table**: `products`
- **Column**: `tenant_id`
- **References**: `tenants.id`
- **On Delete**: `RESTRICT` (prevents tenant deletion if products exist)
- **On Update**: `CASCADE` (updates tenant ID if tenant ID changes)

### **4. Subscriptions → Tenants**
- **Constraint**: `subscriptions_tenant_id_fk`
- **Table**: `subscriptions`
- **Column**: `tenant_id`
- **References**: `tenants.id`
- **On Delete**: `RESTRICT` (prevents tenant deletion if subscriptions exist)
- **On Update**: `CASCADE` (updates tenant ID if tenant ID changes)

## 🔧 TypeORM Configuration

### **Foreign Key Definition**
```typescript
@Entity('users')
export class User extends BaseEntity {
  @Column()
  tenantId: string;

  @ManyToOne(() => Tenant, tenant => tenant.users)
  @JoinColumn({ name: 'tenantId' })
  tenant: Tenant;
}
```

### **Migration Example**
```typescript
export class CreateUsersTable1234567890 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          // ... column definitions
        ],
        foreignKeys: [
          {
            columnNames: ['tenant_id'],
            referencedTableName: 'tenants',
            referencedColumnNames: ['id'],
            onDelete: 'RESTRICT',
            onUpdate: 'CASCADE',
            name: 'users_tenant_id_fk'
          }
        ]
      }),
      true
    );
  }
}
```

## ⚠️ Important Notes

### **RESTRICT on Delete**
- Prevents accidental tenant deletion
- Ensures data integrity
- Requires manual cleanup of related data

### **CASCADE on Update**
- Updates tenant ID in related tables
- Maintains referential integrity
- Prevents orphaned records

### **Index Requirements**
- All foreign key columns must be indexed
- Improves query performance
- Required for constraint validation

## 🚀 Query Examples

### **Check Foreign Key Constraints**
```sql
-- List all foreign keys
SELECT
  tc.constraint_name,
  tc.table_name,
  kcu.column_name,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY';
```

### **Check Referential Integrity**
```sql
-- Find orphaned records
SELECT u.* FROM users u
LEFT JOIN tenants t ON u.tenant_id = t.id
WHERE t.id IS NULL;
```

## 🔒 Security Considerations

### **Data Integrity**
- Foreign keys prevent orphaned records
- RESTRICT prevents accidental deletions
- CASCADE maintains referential integrity

### **Performance Impact**
- Foreign key validation adds overhead
- Indexes are required for performance
- Consider impact on bulk operations

### **Maintenance**
- Regular integrity checks recommended
- Monitor constraint violations
- Plan for constraint changes

## 📋 Best Practices

### **Constraint Naming**
- Use descriptive names: `{table}_{column}_fk`
- Include table and column information
- Follow consistent naming convention

### **Cascade Behavior**
- Use RESTRICT for critical relationships
- Use CASCADE for dependent data
- Consider business requirements

### **Index Management**
- Create indexes on all foreign key columns
- Monitor index usage and performance
- Consider composite indexes for complex queries

---

**Last Updated**: {{ current_date }}
**Schema Version**: 1.0.0
