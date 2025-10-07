// src/config/logger.config.ts
import { LogLevel } from '@nestjs/common';

export interface LoggerConfig {
  level: LogLevel;
  enableConsole: boolean;
  enableStructured: boolean;
  enableRequestLogging: boolean;
  enableMethodLogging: boolean;
  enablePerformanceLogging: boolean;
  enableSecurityLogging: boolean;
  enableDatabaseLogging: boolean;
}

export const getLoggerConfig = (): LoggerConfig => {
  const nodeEnv = process.env['NODE_ENV'] ?? 'development';
  const isDevelopment = nodeEnv === 'development';
  const isTest = nodeEnv === 'test';
  const isProduction = nodeEnv === 'production';

  return {
    level: isTest ? 'error' : isDevelopment ? 'debug' : 'warn',
    enableConsole: isDevelopment,
    enableStructured: true,
    enableRequestLogging: !isTest,
    enableMethodLogging: isDevelopment,
    enablePerformanceLogging: isDevelopment || isProduction,
    enableSecurityLogging: true,
    enableDatabaseLogging: isDevelopment,
  };
};

export const loggerConfig = getLoggerConfig();
