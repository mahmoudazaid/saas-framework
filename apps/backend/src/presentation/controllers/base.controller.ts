// src/presentation/controllers/base.controller.ts
import { Controller, Logger } from '@nestjs/common';

interface ErrorResponse {
  statusCode: number;
  message: string;
  timestamp: string;
}

@Controller()
export abstract class BaseController {
  private readonly logger = new Logger(BaseController.name);

  // Add common controller methods here
  protected handleError(error: unknown): ErrorResponse {
    // Common error handling logic
    this.logger.error('Controller error:', error);
    
    const errorObj = error as { status?: number; message?: string };
    return {
      statusCode: errorObj.status ?? 500,
      message: errorObj.message ?? 'Internal server error',
      timestamp: new Date().toISOString(),
    };
  }
}
