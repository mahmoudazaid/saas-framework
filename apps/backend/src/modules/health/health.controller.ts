// src/modules/health/health.controller.ts
import { Controller, Get } from '@nestjs/common';
import { BusinessException } from '../../common/exceptions/business.exception';

@Controller('health')
export class HealthController {
  @Get()
  check(): { status: string; timestamp: string } {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }

  @Get('error')
  testError(): never {
    // Example of using custom exception
    throw new BusinessException('This is a test error');
  }
}
