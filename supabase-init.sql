-- Supabase local development initialization
-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Auth schema (GoTrue will create tables here)
CREATE SCHEMA IF NOT EXISTS auth;

-- Roles for PostgREST
CREATE ROLE anon NOLOGIN;
CREATE ROLE authenticated NOLOGIN;

-- Grants on public schema
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO anon, authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;

-- Grant access to auth schema
GRANT USAGE ON SCHEMA auth TO anon, authenticated;

-- auth.uid() function for RLS policies
CREATE OR REPLACE FUNCTION auth.uid() RETURNS uuid AS $$
  SELECT coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), '')::uuid,
    nullif(current_setting('request.jwt.claim.role', true), '')::uuid
  )
$$ LANGUAGE sql STABLE;

GRANT EXECUTE ON FUNCTION auth.uid() TO anon, authenticated;
