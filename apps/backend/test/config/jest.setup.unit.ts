// apps/backend/test/config/jest.setup.unit.ts
import { config } from 'dotenv';

// Load environment variables for tests
config({ path: '.env.test' });

// Clear all mocks after each test
afterEach(() => {
  jest.clearAllMocks();
});

// Global test timeout
jest.setTimeout(10000);
