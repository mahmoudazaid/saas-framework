// src/application/interfaces/repository.interface.ts
import { BaseEntity } from '../../core/entities/base.entity';

export interface IRepository<T extends BaseEntity> {
  findById(id: string): Promise<T | null>;
  findAll(): Promise<T[]>;
  create(entity: Partial<T>): Promise<T>;
  update(id: string, entity: Partial<T>): Promise<T>;
  delete(id: string): Promise<void>;
  softDelete(id: string): Promise<void>;
}

export interface ITenantRepository<T extends BaseEntity> extends IRepository<T> {
  findByTenantId(tenantId: string): Promise<T[]>;
  findByIdAndTenantId(id: string, tenantId: string): Promise<T | null>;
}
