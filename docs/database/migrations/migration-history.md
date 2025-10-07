# Migration History

This document tracks the migration history for the database schema.

## 📋 Migration Timeline

| Version | Migration | Description | Date | Status |
|---------|-----------|-------------|------|--------|
| 1.0.0 | `CreateTenantsTable` | Initial tenants table | 2024-01-01 | ✅ Applied |
| 1.0.1 | `CreateUsersTable` | Initial users table | 2024-01-01 | ✅ Applied |
| 1.0.2 | `CreateSampleEntitiesTable` | Initial sample entities table | 2024-01-01 | ✅ Applied |
| 1.0.3 | `CreateProductsTable` | Initial products table | 2024-01-01 | ✅ Applied |
| 1.0.4 | `CreateSubscriptionsTable` | Initial subscriptions table | 2024-01-01 | ✅ Applied |
| 1.0.5 | `AddIndexes` | Add performance indexes | 2024-01-01 | ✅ Applied |
| 1.0.6 | `AddConstraints` | Add foreign key constraints | 2024-01-01 | ✅ Applied |

## 🔧 Migration Commands

### **Generate Migration**
```bash
# Generate new migration
npm run migration:generate -- --name=MigrationName

# Generate migration from entity changes
npm run migration:generate -- --name=AddNewField
```

### **Run Migrations**
```bash
# Run all pending migrations
npm run migration:run

# Run specific migration
npm run migration:run -- --name=MigrationName
```

### **Revert Migration**
```bash
# Revert last migration
npm run migration:revert

# Revert specific migration
npm run migration:revert -- --name=MigrationName
```

### **Check Migration Status**
```bash
# Show migration status
npm run migration:show

# Show pending migrations
npm run migration:pending
```

## 📊 Migration Details

### **1.0.0 - CreateTenantsTable**
- **File**: `CreateTenantsTable1234567890.ts`
- **Description**: Creates the initial tenants table
- **Tables**: `tenants`
- **Indexes**: `idx_tenants_name_unique`, `idx_tenants_slug_unique`

### **1.0.1 - CreateUsersTable**
- **File**: `CreateUsersTable1234567891.ts`
- **Description**: Creates the initial users table
- **Tables**: `users`
- **Indexes**: `idx_users_tenant_id`, `idx_users_email_unique`

### **1.0.2 - CreateSampleEntitiesTable**
- **File**: `CreateSampleEntitiesTable1234567892.ts`
- **Description**: Creates the initial sample entities table
- **Tables**: `sample_entities`
- **Indexes**: `idx_sample_entities_tenant_id`

### **1.0.3 - CreateProductsTable**
- **File**: `CreateProductsTable1234567893.ts`
- **Description**: Creates the initial products table
- **Tables**: `products`
- **Indexes**: `idx_products_tenant_id`

### **1.0.4 - CreateSubscriptionsTable**
- **File**: `CreateSubscriptionsTable1234567894.ts`
- **Description**: Creates the initial subscriptions table
- **Tables**: `subscriptions`
- **Indexes**: `idx_subscriptions_tenant_id`

### **1.0.5 - AddIndexes**
- **File**: `AddIndexes1234567895.ts`
- **Description**: Adds performance indexes
- **Indexes**: Various performance indexes

### **1.0.6 - AddConstraints**
- **File**: `AddConstraints1234567896.ts`
- **Description**: Adds foreign key constraints
- **Constraints**: All foreign key relationships

## 🚀 Migration Best Practices

### **Before Creating Migration**
1. Review entity changes
2. Test changes locally
3. Backup production data
4. Plan rollback strategy

### **Migration Naming**
- Use descriptive names
- Include version number
- Follow naming convention
- Include date if needed

### **Migration Content**
- Include up and down methods
- Test both directions
- Add proper error handling
- Document complex changes

### **Testing Migrations**
- Test on development database
- Test rollback scenarios
- Verify data integrity
- Check performance impact

## ⚠️ Important Notes

### **Production Migrations**
- Always backup before running
- Test on staging first
- Monitor performance impact
- Have rollback plan ready

### **Data Migration**
- Handle data transformation carefully
- Test with production-like data
- Consider downtime requirements
- Plan for large datasets

### **Schema Changes**
- Review impact on existing queries
- Update indexes as needed
- Consider application compatibility
- Test thoroughly

## 🔍 Troubleshooting

### **Common Issues**
1. **Migration fails**: Check database connection
2. **Constraint violations**: Review data integrity
3. **Performance issues**: Check index usage
4. **Rollback fails**: Manual intervention may be needed

### **Recovery Steps**
1. Check migration status
2. Review error logs
3. Fix data issues
4. Retry migration
5. Contact DBA if needed

---

**Last Updated**: {{ current_date }}
**Current Version**: 1.0.6
**Next Version**: 1.0.7
