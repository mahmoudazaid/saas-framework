// src/common/interceptors/log-method.interceptor.ts
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { Reflector } from '@nestjs/core';
import { LoggerService, LogContext } from '../services/logger.service';
import { LOG_METADATA_KEY, LogMetadata } from '../decorators/log.decorator';

@Injectable()
export class LogMethodInterceptor implements NestInterceptor {
  constructor(
    private readonly logger: LoggerService,
    private readonly reflector: Reflector,
  ) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const logMetadata = this.reflector.get<LogMetadata>(
      LOG_METADATA_KEY,
      context.getHandler(),
    );

    if (!logMetadata) {
      return next.handle();
    }

    const className = context.getClass().name;
    const methodName = context.getHandler().name;
    const startTime = Date.now();

    // Extract context information
    const logContext: LogContext = {
      className,
      methodName,
      type: 'method_execution',
    };

    // Log method entry
    if (logMetadata.includeArgs) {
      const args = context.getArgs();
      this.logger.debug(
        `${logMetadata.message ?? 'Method called'}: ${className}.${methodName}`,
        { ...logContext, args: this.sanitizeArgs(args) }
      );
    }

    return next.handle().pipe(
      tap((result) => {
        const executionTime = Date.now() - startTime;
        const contextWithTime = { ...logContext, executionTime };

        if (logMetadata.includeResult) {
          this.logger.debug(
            `${logMetadata.message ?? 'Method completed'}: ${className}.${methodName}`,
            { ...contextWithTime, result: this.sanitizeResult(result) }
          );
        }

        if (logMetadata.includeExecutionTime) {
          this.logger.debug(
            `Method execution time: ${className}.${methodName} (${executionTime}ms)`,
            contextWithTime
          );
        }
      }),
      catchError((error: unknown) => {
        const executionTime = Date.now() - startTime;
        const contextWithTime = { ...logContext, executionTime };

        this.logger.error(
          `${logMetadata.message ?? 'Method error'}: ${className}.${methodName}`,
          error instanceof Error ? error : new Error(String(error)),
          contextWithTime
        );

        throw error;
      }),
    );
  }

  private sanitizeArgs(args: unknown[]): unknown[] {
    return args.map(arg => {
      if (typeof arg === 'object' && arg !== null) {
        // Remove sensitive fields
        const sanitized = { ...arg as Record<string, unknown> };
        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { password, token, secret, ...rest } = sanitized;
        return rest;
      }
      return arg;
    });
  }

  private sanitizeResult(result: unknown): unknown {
    if (typeof result === 'object' && result !== null) {
      // Remove sensitive fields
      const sanitized = { ...result as Record<string, unknown> };
      // eslint-disable-next-line @typescript-eslint/no-unused-vars
      const { password, token, secret, ...rest } = sanitized;
      return rest;
    }
    return result;
  }
}
