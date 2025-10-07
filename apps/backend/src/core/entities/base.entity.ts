// src/core/entities/base.entity.ts
import { PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Column } from 'typeorm';

/**
 * Base entity class that provides common properties for all entities
 * 
 * This abstract class defines the standard fields that every entity in the system should have:
 * - Unique identifier (UUID)
 * - Creation and update timestamps
 * - Soft delete flag
 * 
 * @abstract
 * @class BaseEntity
 * @example
 * ```typescript
 * @Entity('users')
 * export class User extends BaseEntity {
 *   @Column()
 *   name!: string;
 *   
 *   @Column()
 *   email!: string;
 * }
 * ```
 * @since 1.0.0
 */
export abstract class BaseEntity {
  /**
   * Unique identifier for the entity
   * @type {string}
   * @memberof BaseEntity
   * @example "123e4567-e89b-12d3-a456-426614174000"
   */
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  /**
   * Timestamp when the entity was created
   * @type {Date}
   * @memberof BaseEntity
   * @example "2023-01-01T00:00:00.000Z"
   */
  @CreateDateColumn()
  createdAt!: Date;

  /**
   * Timestamp when the entity was last updated
   * @type {Date}
   * @memberof BaseEntity
   * @example "2023-01-01T12:00:00.000Z"
   */
  @UpdateDateColumn()
  updatedAt!: Date;

  /**
   * Soft delete flag - indicates if the entity is deleted
   * @type {boolean}
   * @memberof BaseEntity
   * @default false
   * @example false
   */
  @Column({ default: false })
  isDeleted!: boolean;
}

/**
 * Tenant-aware entity class that extends BaseEntity with tenant context
 * 
 * This abstract class provides multi-tenancy support by including a tenantId field.
 * All entities that need to be tenant-specific should extend this class.
 * 
 * @abstract
 * @class TenantEntity
 * @extends BaseEntity
 * @example
 * ```typescript
 * @Entity('products')
 * export class Product extends TenantEntity {
 *   @Column()
 *   name!: string;
 *   
 *   @Column('decimal')
 *   price!: number;
 * }
 * ```
 * @since 1.0.0
 */
export abstract class TenantEntity extends BaseEntity {
  /**
   * Unique identifier of the tenant that owns this entity
   * @type {string}
   * @memberof TenantEntity
   * @example "tenant-123e4567-e89b-12d3-a456-426614174000"
   */
  @Column('uuid')
  tenantId!: string;
}