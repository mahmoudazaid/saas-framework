// src/infrastructure/config/app.config.ts
import { registerAs } from '@nestjs/config';

export default registerAs('app', () => ({
  port: parseInt(process.env['PORT'] ?? '3000', 10),
  nodeEnv: process.env['NODE_ENV'] ?? 'development',
  apiPrefix: process.env['API_PREFIX'] ?? 'api/v1',
  cors: {
    origin: process.env['CORS_ORIGIN']?.split(',') ?? ['http://localhost:3000', 'http://localhost:8080'],
    credentials: true,
  },
  rateLimit: {
    windowMs: parseInt(process.env['RATE_LIMIT_WINDOW_MS'] ?? '900000', 10), // 15 minutes
    max: parseInt(process.env['RATE_LIMIT_MAX'] ?? '100', 10), // limit each IP to 100 requests per windowMs
  },
}));
