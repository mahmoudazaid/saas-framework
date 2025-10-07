# Database Schema Diagram

This document contains the database schema diagram showing table structures and relationships.

## 🏗️ Schema Overview

```mermaid
graph TB
    subgraph "Core Tables"
        T[tenants]
        U[users]
    end
    
    subgraph "Framework Tables"
        SE[sample_entities]
        P[products]
        S[subscriptions]
    end
    
    subgraph "Base Classes"
        BE[BaseEntity]
        TE[TenantEntity]
    end
    
    %% Relationships
    T -->|1:N| U
    T -->|1:N| SE
    T -->|1:N| P
    T -->|1:N| S
    
    BE -->|extends| TE
    TE -->|extends| SE
    TE -->|extends| P
    TE -->|extends| S
```

## 📊 Table Structures

### **tenants**
```mermaid
graph LR
    subgraph "tenants"
        T_id[id: string PK]
        T_name[name: string UK]
        T_slug[slug: string UK]
        T_desc[description: string]
        T_active[isActive: boolean]
        T_created[createdAt: datetime]
        T_updated[updatedAt: datetime]
        T_deleted[deletedAt: datetime]
    end
```

### **users**
```mermaid
graph LR
    subgraph "users"
        U_id[id: string PK]
        U_tenant[tenantId: string FK]
        U_email[email: string UK]
        U_first[firstName: string]
        U_last[lastName: string]
        U_role[role: string]
        U_active[isActive: boolean]
        U_created[createdAt: datetime]
        U_updated[updatedAt: datetime]
        U_deleted[deletedAt: datetime]
    end
```

### **sample_entities**
```mermaid
graph LR
    subgraph "sample_entities"
        SE_id[id: string PK]
        SE_tenant[tenantId: string FK]
        SE_slug[tenantSlug: string]
        SE_name[name: string]
        SE_desc[description: string]
        SE_active[isActive: boolean]
        SE_created[createdAt: datetime]
        SE_updated[updatedAt: datetime]
        SE_deleted[deletedAt: datetime]
    end
```

### **products**
```mermaid
graph LR
    subgraph "products"
        P_id[id: string PK]
        P_tenant[tenantId: string FK]
        P_slug[tenantSlug: string]
        P_name[name: string]
        P_desc[description: string]
        P_price[price: decimal]
        P_active[isActive: boolean]
        P_created[createdAt: datetime]
        P_updated[updatedAt: datetime]
        P_deleted[deletedAt: datetime]
    end
```

### **subscriptions**
```mermaid
graph LR
    subgraph "subscriptions"
        S_id[id: string PK]
        S_tenant[tenantId: string FK]
        S_slug[tenantSlug: string]
        S_name[name: string]
        S_desc[description: string]
        S_price[price: decimal]
        S_billing[billingCycle: string]
        S_active[isActive: boolean]
        S_created[createdAt: datetime]
        S_updated[updatedAt: datetime]
        S_deleted[deletedAt: datetime]
    end
```

## 🔗 Relationship Map

```mermaid
graph TD
    subgraph "Tenant Hierarchy"
        T[Tenant]
        U[User]
        SE[SampleEntity]
        P[Product]
        S[Subscription]
    end
    
    subgraph "Inheritance"
        BE[BaseEntity]
        TE[TenantEntity]
    end
    
    %% Tenant relationships
    T -->|1:N| U
    T -->|1:N| SE
    T -->|1:N| P
    T -->|1:N| S
    
    %% Inheritance relationships
    BE -->|extends| TE
    TE -->|extends| SE
    TE -->|extends| P
    TE -->|extends| S
    
    %% Styling
    classDef tenantClass fill:#e1f5fe
    classDef entityClass fill:#f3e5f5
    classDef baseClass fill:#e8f5e8
    
    class T tenantClass
    class U,SE,P,S entityClass
    class BE,TE baseClass
```

## 📋 Index Structure

### **Primary Indexes**
- **tenants**: `id` (PK)
- **users**: `id` (PK)
- **sample_entities**: `id` (PK)
- **products**: `id` (PK)
- **subscriptions**: `id` (PK)

### **Unique Indexes**
- **tenants**: `name`, `slug`
- **users**: `email`

### **Foreign Key Indexes**
- **users**: `tenant_id`
- **sample_entities**: `tenant_id`
- **products**: `tenant_id`
- **subscriptions**: `tenant_id`

### **Performance Indexes**
- **All tables**: `is_active`
- **All tables**: `deleted_at`
- **Tenant entities**: `tenant_slug`

## 🎯 Multi-Tenancy Architecture

```mermaid
graph TB
    subgraph "Tenant A"
        TA[Tenant A]
        UA[Users A]
        SEA[Sample Entities A]
        PA[Products A]
        SA[Subscriptions A]
    end
    
    subgraph "Tenant B"
        TB[Tenant B]
        UB[Users B]
        SEB[Sample Entities B]
        PB[Products B]
        SB[Subscriptions B]
    end
    
    subgraph "Shared Framework"
        BE[BaseEntity]
        TE[TenantEntity]
    end
    
    %% Tenant A relationships
    TA -->|1:N| UA
    TA -->|1:N| SEA
    TA -->|1:N| PA
    TA -->|1:N| SA
    
    %% Tenant B relationships
    TB -->|1:N| UB
    TB -->|1:N| SEB
    TB -->|1:N| PB
    TB -->|1:N| SB
    
    %% Framework inheritance
    BE -->|extends| TE
    TE -->|extends| SEA
    TE -->|extends| PA
    TE -->|extends| SA
    TE -->|extends| SEB
    TE -->|extends| PB
    TE -->|extends| SB
    
    %% Styling
    classDef tenantA fill:#e3f2fd
    classDef tenantB fill:#f1f8e9
    classDef framework fill:#fff3e0
    
    class TA,UA,SEA,PA,SA tenantA
    class TB,UB,SEB,PB,SB tenantB
    class BE,TE framework
```

## 🔧 Database Conventions

### **Table Naming**
- **Snake Case**: `sample_entities`, `user_roles`
- **Plural Forms**: `users`, `products`, `subscriptions`
- **Descriptive Names**: Clear, meaningful table names

### **Column Naming**
- **Snake Case**: `created_at`, `tenant_id`
- **Descriptive Names**: `firstName`, `billingCycle`
- **Consistent Patterns**: `isActive`, `tenantSlug`

### **Constraint Naming**
- **Primary Keys**: `{table}_pkey`
- **Foreign Keys**: `{table}_{column}_fk`
- **Unique Keys**: `{table}_{column}_key`
- **Check Constraints**: `{table}_{column}_check`

## 🚀 Query Patterns

### **Tenant-Scoped Queries**
```sql
-- Find all entities for a tenant
SELECT * FROM sample_entities 
WHERE tenant_id = 'tenant-uuid' 
AND deleted_at IS NULL;

-- Find by tenant slug
SELECT * FROM sample_entities 
WHERE tenant_slug = 'tenant-slug' 
AND deleted_at IS NULL;
```

### **Relationship Queries**
```sql
-- Find tenant with all related data
SELECT t.*, u.*, se.*, p.*, s.*
FROM tenants t
LEFT JOIN users u ON t.id = u.tenant_id
LEFT JOIN sample_entities se ON t.id = se.tenant_id
LEFT JOIN products p ON t.id = p.tenant_id
LEFT JOIN subscriptions s ON t.id = s.tenant_id
WHERE t.id = 'tenant-uuid';
```

---

**Last Updated**: {{ current_date }}
**Schema Version**: 1.0.0
**Diagram Version**: 1.0.0
