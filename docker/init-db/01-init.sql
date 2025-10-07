-- Generic database initialization script
-- This script runs only on first-time database initialization (empty data dir)

-- Create extensions commonly used by the framework
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Note: Tables and schemas are created by TypeORM migrations
-- Use this file only for cluster-level setup that migrations don't handle

-- Log initialization for visibility
DO $$
BEGIN
    RAISE NOTICE 'Database initialization completed (generic init script)';
END $$;


