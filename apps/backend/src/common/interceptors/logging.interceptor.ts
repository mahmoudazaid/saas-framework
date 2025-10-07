// src/common/interceptors/logging.interceptor.ts
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { Request, Response } from 'express';
import { LoggerService, LogContext } from '../services/logger.service';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  constructor(private readonly logger: LoggerService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();
    
    const { method, url, ip } = request;
    const userAgent = request.get('User-Agent') ?? '';
    const startTime = Date.now();

    // Extract context information
    const logContext: LogContext = {
      method,
      url,
      ip,
      userAgent,
      requestId: this.generateRequestId(),
      tenantId: (request as Request & { tenantSlug?: string }).tenantSlug,
      userId: (request as Request & { user?: { id?: string } }).user?.id,
    };

    // Log incoming request
    this.logger.httpRequest(method, url, logContext);

    return next.handle().pipe(
      tap(() => {
        const responseTime = Date.now() - startTime;
        const statusCode = response.statusCode;
        
        // Log successful response
        this.logger.httpResponse(method, url, statusCode, responseTime, logContext);
      }),
      catchError((error: Error & { status?: number }) => {
        const responseTime = Date.now() - startTime;
        const statusCode = error.status ?? 500;
        
        // Log error response
        this.logger.error(
          `HTTP ${method} ${url} ${statusCode} ${responseTime}ms`,
          error,
          { ...logContext, statusCode, responseTime }
        );
        
        throw error;
      }),
    );
  }

  private generateRequestId(): string {
    return `req_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}