// src/common/base.module.ts
import { Module } from '@nestjs/common';
import { LoggerService } from './services/logger.service';

@Module({
  providers: [LoggerService] as const,
  exports: [LoggerService] as const,
})
export class BaseModule {}
