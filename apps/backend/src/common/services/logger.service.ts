// src/common/services/logger.service.ts
import { Injectable, Logger } from '@nestjs/common';

export interface LogContext {
  [key: string]: unknown;
  className?: string;
  methodName?: string;
  type?: string;
  method?: string;
  url?: string;
  ip?: string;
  userAgent?: string;
  requestId?: string;
  tenantId?: string;
  userId?: string;
  executionTime?: number;
  responseTime?: number;
  statusCode?: number;
}

@Injectable()
export class LoggerService {
  private readonly logger = new Logger(LoggerService.name);

  log(message: string, context?: LogContext): void {
    this.logger.log(message, context);
  }

  error(message: string, error?: Error | unknown, context?: LogContext): void {
    if (error instanceof Error) {
      this.logger.error(message, error.stack, context);
    } else {
      this.logger.error(message, String(error), context);
    }
  }

  warn(message: string, context?: LogContext): void {
    this.logger.warn(message, context);
  }

  debug(message: string, context?: LogContext): void {
    this.logger.debug(message, context);
  }

  verbose(message: string, context?: LogContext): void {
    this.logger.verbose(message, context);
  }

  httpRequest(method: string, url: string, context?: LogContext): void {
    this.logger.log(`HTTP ${method} ${url}`, { ...context, type: 'http_request' });
  }

  httpResponse(method: string, url: string, statusCode: number, responseTime: number, context?: LogContext): void {
    this.logger.log(`HTTP ${method} ${url} ${statusCode} ${responseTime}ms`, { 
      ...context, 
      type: 'http_response',
      statusCode,
      responseTime 
    });
  }
}
