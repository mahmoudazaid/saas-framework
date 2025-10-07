// src/infrastructure/database/typeorm.repository.ts
import { Repository, FindOptionsWhere } from 'typeorm';
import { BaseRepository } from '../../core/repositories/base.repository';
import { BaseEntity } from '../../core/entities/base.entity';

export class TypeOrmRepository<T extends BaseEntity> extends BaseRepository<T> {
  constructor(repository: Repository<T>) {
    super(repository);
  }

  // Add TypeORM-specific methods here
  async findByTenantId(tenantId: string): Promise<T[]> {
    try {
      return await this.repository.find({ where: { tenantId } as unknown as FindOptionsWhere<T> });
    } catch (error) {
      throw new Error(`Failed to find entities by tenantId ${tenantId}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async findByIdAndTenantId(id: string, tenantId: string): Promise<T | null> {
    try {
      return await this.repository.findOne({ where: { id, tenantId } as unknown as FindOptionsWhere<T> });
    } catch (error) {
      throw new Error(`Failed to find entity by id ${id} and tenantId ${tenantId}: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
}
