// src/application/dto/base.dto.ts
import { IsOptional, IsUUID, IsDateString } from 'class-validator';

export class BaseDto {
  @IsOptional()
  @IsUUID()
  id?: string;

  @IsOptional()
  @IsDateString()
  createdAt?: Date;

  @IsOptional()
  @IsDateString()
  updatedAt?: Date;
}

export class TenantDto extends BaseDto {
  @IsUUID()
  tenantId!: string;
}

export class PaginationDto {
  @IsOptional()
  page?: number = 1;

  @IsOptional()
  limit?: number = 10;

  @IsOptional()
  sortBy?: string;

  @IsOptional()
  sortOrder?: 'ASC' | 'DESC' = 'ASC';
}
