# User

The `User` entity represents system users within a tenant.

## 📋 Table Structure

**Table Name**: `users`

## 🏗️ Fields

| Field | Type | Constraints | Description |
|-------|------|-------------|-------------|
| `id` | `string` | `PRIMARY KEY`, `NOT NULL` | UUID v4 primary key |
| `tenantId` | `string` | `NOT NULL`, `FOREIGN KEY` | Tenant identifier |
| `email` | `string` | `NOT NULL`, `UNIQUE` | User email address |
| `firstName` | `string` | `NOT NULL` | User first name |
| `lastName` | `string` | `NOT NULL` | User last name |
| `role` | `string` | `NOT NULL` | User role (admin, staff, user) |
| `isActive` | `boolean` | `NOT NULL`, `DEFAULT true` | User status |
| `createdAt` | `datetime` | `NOT NULL` | Record creation timestamp |
| `updatedAt` | `datetime` | `NOT NULL` | Record last update timestamp |
| `deletedAt` | `datetime` | `NULL` | Soft delete timestamp |

## 🔧 TypeORM Configuration

```typescript
@Entity('users')
export class User extends BaseEntity {
  @Column()
  tenantId: string;

  @Column({ unique: true })
  email: string;

  @Column()
  firstName: string;

  @Column()
  lastName: string;

  @Column()
  role: string;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => Tenant, tenant => tenant.users)
  @JoinColumn({ name: 'tenantId' })
  tenant: Tenant;
}
```

## 🎯 Purpose

- **User Management**: Central user information storage
- **Tenant Association**: Links users to specific tenants
- **Authentication**: Provides user identity for system access
- **Authorization**: Role-based access control

## 📝 Usage

```typescript
// Create a new user
const user = new User();
user.tenantId = 'tenant-uuid';
user.email = 'john.doe@acme.com';
user.firstName = 'John';
user.lastName = 'Doe';
user.role = 'admin';
user.isActive = true;

await userRepository.save(user);
```

## 🔗 Relationships

- **Tenant**: `ManyToOne` relationship with `Tenant` entity
- **Foreign Key**: `tenantId` references `tenants.id`

## 🔍 Indexes

- **Primary Key**: `id` (automatic)
- **Tenant ID**: `idx_users_tenant_id`
- **Unique Email**: `idx_users_email_unique`
- **Role**: `idx_users_role`
- **Active Status**: `idx_users_is_active`
- **Soft Delete**: `idx_users_deleted_at`

## ⚠️ Important Notes

- **Email Uniqueness**: Email must be unique across all tenants
- **Tenant Association**: Every user must belong to a tenant
- **Role Validation**: Role should be validated against allowed values
- **Active Status**: Inactive users cannot authenticate

## 🚀 Query Examples

```typescript
// Find user by email
const user = await userRepository.findOne({
  where: { email: 'john.doe@acme.com' }
});

// Find users by tenant
const users = await userRepository.find({
  where: { tenantId: 'tenant-uuid' }
});

// Find active users by role
const admins = await userRepository.find({
  where: { role: 'admin', isActive: true }
});

// Soft delete user
await userRepository.softDelete({ id: 'user-uuid' });
```

## 🔒 Security Considerations

- **Email Validation**: Ensure email format is valid
- **Role Authorization**: Validate user roles before operations
- **Tenant Isolation**: Users can only access their tenant's data
- **Password Security**: Store hashed passwords (not in this entity)

## 📋 Role Definitions

- **`admin`**: Full system access within tenant
- **`staff`**: Limited administrative access
- **`user`**: Basic user access

---

**Last Updated**: {{ current_date }}
**Entity Type**: Multi-Tenant Entity
**Extends**: BaseEntity
