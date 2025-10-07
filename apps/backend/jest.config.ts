// apps/backend/jest.config.ts
import type { Config } from 'jest';

const swc = { '^.+\\.ts$': '@swc/jest' };

const cfg = (name: string, rootDir: string, setup: string, testMatch: string[]): Config => ({
  displayName: name,
  rootDir,
  testEnvironment: 'node',
  transform: swc,
  setupFilesAfterEnv: [setup],
  testMatch,
  collectCoverageFrom: [
    'src/**/*.ts',
    '!**/*.test.ts',
    '!**/*.spec.ts',
    // Exclude framework implementation files
    '!src/common/**/*.ts',
    '!src/core/**/*.ts',
    '!src/infrastructure/**/*.ts',
    '!src/presentation/**/*.ts',
    '!src/application/dto/**/*.ts',
    '!src/application/interfaces/**/*.ts',
    '!src/application/services/**/*.ts',
    '!src/application/use-cases/**/*.ts',
    '!src/config/**/*.ts',
    '!src/main.ts',
    '!src/app.module.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 85,
      lines: 85,
      statements: 85,
    },
  },
});

export default {
  projects: [
    // Backend tests
    cfg('backend-unit', '.', '<rootDir>/test/config/jest.setup.unit.ts', ['<rootDir>/test/unit/**/*.test.ts']),
    cfg('backend-integration', '.', '<rootDir>/test/config/jest.setup.integration.ts', ['<rootDir>/test/integration/**/*.test.ts']),
  ],
} as Config;
