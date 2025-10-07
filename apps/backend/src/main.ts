// src/main.ts
import { NestFactory } from '@nestjs/core';
import { FastifyAdapter, NestFastifyApplication } from '@nestjs/platform-fastify';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { LoggerService } from './common/services/logger.service';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';

async function bootstrap(): Promise<void> {
  try {
    const app = await NestFactory.create<NestFastifyApplication>(
      AppModule,
      new FastifyAdapter(),
      {
        logger: ['error', 'warn', 'log'],
      },
    );

    // Get logger service instance
    const loggerService = app.get<LoggerService>(LoggerService);

    // Add global validation pipe
    app.useGlobalPipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        forbidNonWhitelisted: true,
      }),
    );

    // Add global logging interceptor
    app.useGlobalInterceptors(new LoggingInterceptor(loggerService));
    
    // Enable CORS for Flutter web and mobile apps
    app.enableCors({
      origin: true,
      credentials: true,
    });
    
    const port = process.env['PORT'] ?? 3000;
    await app.listen(port, '0.0.0.0');
    
    // Use shared logger service
    loggerService.log(`🚀 API is running on: http://localhost:${port}`, {
      type: 'application_startup',
      port: Number(port),
      environment: process.env['NODE_ENV'] ?? 'development',
    });
  } catch (error) {
    // Use process.stderr for critical errors during bootstrap
    process.stderr.write(`Failed to start application: ${error instanceof Error ? error.message : 'Unknown error'}\n`);
    process.exit(1);
  }
}
void bootstrap();
