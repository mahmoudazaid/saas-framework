// src/core/repositories/base.repository.ts
import { Repository, FindOptionsWhere } from 'typeorm';
import { BaseEntity } from '../entities/base.entity';

export interface IBaseRepository<T extends BaseEntity> {
  findById(id: string): Promise<T | null>;
  findAll(): Promise<T[]>;
  create(entity: Partial<T>): Promise<T>;
  update(id: string, entity: Partial<T>): Promise<T | null>;
  delete(id: string): Promise<void>;
  softDelete(id: string): Promise<void>;
}

export abstract class BaseRepository<T extends BaseEntity> implements IBaseRepository<T> {
  constructor(protected repository: Repository<T>) {}

  async findById(id: string): Promise<T | null> {
    try {
      return await this.repository.findOne({ where: { id } as FindOptionsWhere<T> });
    } catch (error) {
      throw new Error(`Failed to find entity by id ${id}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async findAll(): Promise<T[]> {
    try {
      return await this.repository.find();
    } catch (error) {
      throw new Error(`Failed to find all entities: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async create(entity: Partial<T>): Promise<T> {
    try {
      const newEntity = this.repository.create(entity as T);
      return await this.repository.save(newEntity);
    } catch (error) {
      throw new Error(`Failed to create entity: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async update(id: string, entity: Partial<T>): Promise<T | null> {
    try {
      await this.repository.update(id, entity);
      return await this.findById(id);
    } catch (error) {
      throw new Error(`Failed to update entity ${id}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async delete(id: string): Promise<void> {
    try {
      await this.repository.delete(id);
    } catch (error) {
      throw new Error(`Failed to delete entity ${id}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async softDelete(id: string): Promise<void> {
    try {
      await this.repository.update(id, { isDeleted: true } as Partial<T>);
    } catch (error) {
      throw new Error(`Failed to soft delete entity ${id}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
}
