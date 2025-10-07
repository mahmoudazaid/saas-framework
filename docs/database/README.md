# Database Documentation

This directory contains comprehensive documentation for the database schema, relationships, and migrations.

## 📁 Directory Structure

```
docs/database/
├── README.md                    # This file - database documentation overview
├── schema-overview.md           # High-level database design and architecture
├── entities/                    # Individual entity documentation
│   ├── base-entity.md          # BaseEntity abstract class
│   ├── tenant-entity.md        # TenantEntity abstract class
│   ├── tenant.md               # Tenant entity
│   ├── user.md                 # User entity
│   └── sample-entity.md        # SampleEntity example
├── relationships/               # Table relationships and constraints
│   ├── entity-relationships.md # Entity relationship diagrams
│   └── foreign-keys.md         # Foreign key constraints
├── migrations/                  # Migration history and notes
│   ├── migration-history.md    # Migration timeline and details
│   └── migration-notes.md      # Migration guidelines and best practices
└── diagrams/                    # Visual database representations
    ├── erd-diagram.md          # Entity Relationship Diagram
    └── schema-diagram.md       # Database schema diagram
```

## 🏗️ Database Architecture

### **Multi-Tenant Design**
- **Tenant Isolation**: Complete data segregation between tenants
- **Generic Framework**: Business-agnostic entity design
- **Clean Architecture**: Separation of concerns with clear boundaries
- **Audit Trail**: Comprehensive tracking of all changes

### **Core Principles**
- **Data Integrity**: Foreign key constraints and validation
- **Performance**: Optimized indexes and query patterns
- **Scalability**: Designed for horizontal scaling
- **Maintainability**: Clear documentation and migration strategy

## 📊 Entity Overview

### **Base Classes**
- **`BaseEntity`**: Common fields for all entities (id, timestamps, soft delete)
- **`TenantEntity`**: Multi-tenant base class with tenant context

### **Core Entities**
- **`Tenant`**: Root tenant/organization entity
- **`User`**: System users within tenants

### **Framework Entities**
- **`SampleEntity`**: Example entity demonstrating patterns
- **`Product`**: Generic product/service entity
- **`Subscription`**: Generic subscription/plan entity

## 🔗 Relationships

### **Tenant Hierarchy**
- **One-to-Many**: Tenant → Users, SampleEntities, Products, Subscriptions
- **Inheritance**: BaseEntity → TenantEntity → Concrete Entities

### **Key Relationships**
- **Tenant Isolation**: All entities belong to a tenant
- **Foreign Key Constraints**: Maintain referential integrity
- **Soft Deletes**: Preserve data while hiding from queries

## 🚀 Getting Started

### **1. Review Schema Overview**
Start with [schema-overview.md](schema-overview.md) for high-level understanding.

### **2. Explore Entities**
Check individual entity documentation in [entities/](entities/) directory.

### **3. Understand Relationships**
Study [entity-relationships.md](relationships/entity-relationships.md) for table relationships.

### **4. Review Migrations**
Check [migration-history.md](migrations/migration-history.md) for schema evolution.

### **5. Visualize Schema**
View [erd-diagram.md](diagrams/erd-diagram.md) for visual representation.

## 🔧 Development Workflow

### **Schema Changes**
1. **Modify Entities**: Update TypeORM entity classes
2. **Generate Migration**: Use `npm run migration:generate`
3. **Test Migration**: Run on development database
4. **Update Documentation**: Update relevant documentation
5. **Deploy Migration**: Run migration on production

### **New Entities**
1. **Create Entity Class**: Extend appropriate base class
2. **Add Relationships**: Define foreign key relationships
3. **Generate Migration**: Create migration for new table
4. **Update Documentation**: Add entity documentation
5. **Test Thoroughly**: Verify all functionality

## 📋 Documentation Standards

### **Entity Documentation**
- **Table Structure**: Field definitions and constraints
- **TypeORM Configuration**: Code examples
- **Usage Examples**: Common operations
- **Query Patterns**: Typical queries
- **Security Considerations**: Important notes

### **Relationship Documentation**
- **Relationship Types**: One-to-many, inheritance, etc.
- **Foreign Key Details**: Constraint information
- **Query Examples**: Relationship queries
- **Performance Notes**: Index considerations

### **Migration Documentation**
- **Migration History**: Timeline and descriptions
- **Best Practices**: Guidelines and standards
- **Troubleshooting**: Common issues and solutions
- **Testing Procedures**: Validation steps

## 🔍 Tools and Commands

### **TypeORM Commands**
```bash
# Generate migration
npm run migration:generate -- --name=MigrationName

# Run migrations
npm run migration:run

# Revert migration
npm run migration:revert

# Show migration status
npm run migration:show
```

### **Database Tools**
- **PostgreSQL**: Primary database
- **pgAdmin**: Database administration
- **TypeORM**: ORM and migration tool
- **Mermaid**: Diagram generation

## ⚠️ Important Notes

### **Multi-Tenancy**
- **Tenant Context**: All queries must include tenant context
- **Data Isolation**: Complete separation between tenants
- **Security**: Tenant-based access control

### **Soft Deletes**
- **Data Preservation**: Data is hidden, not deleted
- **Query Updates**: Use appropriate soft delete queries
- **Performance**: Consider impact on query performance

### **Migration Safety**
- **Backup First**: Always backup before migration
- **Test Locally**: Verify migration on development
- **Rollback Plan**: Have rollback strategy ready

## 📚 Related Documentation

- **[Backend Documentation](../apps/backend/docs/)** - Backend implementation details
- **[API Documentation](../apps/backend/docs/api/)** - API endpoint documentation
- **[Testing Guide](../apps/backend/docs/testing/)** - Database testing procedures
- **[Development Setup](../development/development-setup.md)** - Development environment setup

## 🔄 Maintenance

### **Regular Updates**
- **Schema Changes**: Update documentation when schema changes
- **Migration Notes**: Document important migration details
- **Performance Monitoring**: Track query performance
- **Security Reviews**: Regular security assessments

### **Documentation Reviews**
- **Accuracy**: Ensure documentation matches actual schema
- **Completeness**: Verify all entities are documented
- **Clarity**: Improve documentation clarity and examples
- **Examples**: Update code examples and queries

---

**Last Updated**: {{ current_date }}
**Schema Version**: 1.0.0
**Documentation Version**: 1.0.0
