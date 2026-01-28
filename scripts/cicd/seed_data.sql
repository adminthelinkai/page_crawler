-- Seed Data Migration
-- This script safely inserts/updates required data with hardcoded IDs

-- Example: Ensure a specific test user or config exists (User requested "hard code data for primary key columns")
-- Replace table/columns with actual requirements. For now, using the cicd_test_table as an example.

-- Ensure the test table exists (redundant if schema migration worked, but safe)
CREATE TABLE IF NOT EXISTS public.cicd_test_table (
    id serial PRIMARY KEY,
    name text,
    created_at timestamptz DEFAULT now()
);

-- Seed row 1 (Hardcoded ID 100)
INSERT INTO public.cicd_test_table (id, name)
VALUES (100, 'Seed Data 100')
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

-- Seed row 2 (Hardcoded ID 101)
INSERT INTO public.cicd_test_table (id, name)
VALUES (101, 'Seed Data 101')
ON CONFLICT (id) DO NOTHING;

-- This pattern ensures data is preserved (DO NOTHING) or updated (DO UPDATE) without duplication.
