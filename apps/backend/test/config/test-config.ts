// apps/backend/test/config/test-config.ts
export type TestEnv = 'local' | 'dev' | 'prod';

// For now, always use 'local' - no external env files needed
export const envName: TestEnv = 'local';

// Simple local config - no external files
export const cfg = {
  database: {
    // Will be overridden by Testcontainers
    url: process.env['DATABASE_URL'] || 'postgresql://test:test@localhost:5432/test',
    host: 'localhost',
    port: 5432,
    username: 'test',
    password: 'test',
    database: 'test'
  },
  api: {
    port: 3001, // Different port for tests
    baseUrl: 'http://localhost:3001'
  },
  jwt: {
    secret: 'test-secret-key',
    expiresIn: '1h'
  }
};

export const isEmu = () => true; // Always use local/test mode

// Test data helpers
export const testData = {
  entities: {
    valid: {
      id: 'test-id-123',
      name: 'Test Entity',
      description: 'Test description'
    }
  },
  tenants: {
    valid: {
      id: 'tenant-123',
      slug: 'test-tenant',
      name: 'Test Tenant'
    }
  }
};
