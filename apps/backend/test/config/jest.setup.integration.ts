// apps/backend/test/config/jest.setup.integration.ts
import { config } from 'dotenv';
// import { startTestDb, stopTestDb } from '../../../packages/testing/src/typeorm-test';

// Load environment variables for tests
config({ path: '.env.test' });

// Start test database before all tests
// beforeAll(async () => {
//   await startTestDb();
// });

// Stop test database after all tests
// afterAll(async () => {
//   await stopTestDb();
// });

// Clear all mocks after each test
afterEach(() => {
  jest.clearAllMocks();
});

// Global test timeout for integration tests
jest.setTimeout(30000);
