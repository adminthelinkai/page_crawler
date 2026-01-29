# Manual Supabase Migration Guide

## Overview

This guide explains how to safely migrate database schema changes from Testing to Production using Supabase CLI.

## Prerequisites

- SSH access to Testing VPS (72.61.226.144)
- SSH access to Production VPS (72.61.246.138)
- Database credentials for both environments

## Quick Start

### 1. One-Time Setup (Run on Testing VPS)

```bash
# SSH into Testing VPS
ssh -i ~/.ssh/github_deploy_key root@72.61.226.144

# Download and run setup script
cd /root
curl -o setup.sh https://raw.githubusercontent.com/adminthelinkai/page_crawler/master/scripts/manual_migration/setup_manual_migration.sh
chmod +x setup.sh
./setup.sh

# Update database passwords
nano ~/supabase-migrations/.env
```

### 2. Make Schema Changes

Make your changes directly in the Testing Supabase database:
- Add tables
- Add columns
- Create RLS policies
- Create functions/triggers

### 3. Generate Migration

```bash
cd ~/supabase-migrations
source .env

# Generate migration (replace 'my_migration' with descriptive name)
export DATABASE_URL=$TESTING_DB_URL
supabase db diff -f my_migration --schema public,auth,storage
```

This creates a file like: `supabase/migrations/20260129_1530_my_migration.sql`

### 4. Review Migration

```bash
# View the generated SQL
cat supabase/migrations/20260129_1530_my_migration.sql

# Check for dangerous operations
grep -iE "DROP|TRUNCATE|DELETE" supabase/migrations/20260129_1530_my_migration.sql
```

**⚠️ STOP** if you see:
- `DROP TABLE`
- `TRUNCATE`
- `DELETE FROM`
- `ALTER COLUMN ... TYPE` (may cause data loss)

### 5. Apply to Production

```bash
# Backup Production first
export DATABASE_URL=$PRODUCTION_DB_URL
pg_dump $DATABASE_URL --schema-only > backup_$(date +%Y%m%d).sql

# Apply migration
supabase db push

# Verify
psql $PRODUCTION_DB_URL -c "\dt public.*"
```

## Detailed Workflow

### Safe Operations ✅

These operations are generally safe and won't cause data loss:

- `CREATE TABLE`
- `ALTER TABLE ... ADD COLUMN`
- `CREATE INDEX`
- `CREATE POLICY`
- `CREATE FUNCTION`
- `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`

### Dangerous Operations ⚠️

These require extra caution:

- `DROP TABLE` - Deletes entire table and data
- `DROP COLUMN` - Removes column and its data
- `ALTER COLUMN ... TYPE` - May fail if data incompatible
- `TRUNCATE` - Deletes all rows
- `DELETE FROM` - Removes specific rows

### Rollback Procedure

If migration causes issues:

```bash
# Restore from backup
psql $PRODUCTION_DB_URL < backup_20260129.sql
```

## Using the Helper Scripts

### From Local Machine (Windows)

The repository includes scripts you can run via SSH:

#### Generate Migration
```bash
ssh -i C:\Users\admin\.ssh\github_deploy_key root@72.61.226.144 "cd ~/supabase-migrations && source .env && export DATABASE_URL=\$TESTING_DB_URL && supabase db diff -f my_migration --schema public,auth,storage"
```

#### Apply Migration
```bash
ssh -i C:\Users\admin\.ssh\github_deploy_key root@72.61.226.144 "cd ~/supabase-migrations && source .env && export DATABASE_URL=\$PRODUCTION_DB_URL && supabase db push"
```

## Best Practices

### 1. Always Test First
- Make changes in Testing environment
- Verify functionality works
- Then migrate to Production

### 2. Descriptive Migration Names
Good: `add_user_preferences_table`
Bad: `update`, `fix`, `changes`

### 3. Small, Atomic Migrations
- One logical change per migration
- Easier to review and rollback
- Clearer git history

### 4. Review Before Applying
- Read every line of the generated SQL
- Check for unintended changes
- Verify column names/types are correct

### 5. Backup Before Major Changes
- Always backup before schema changes
- Keep backups for at least 30 days
- Test restore procedure periodically

## Troubleshooting

### "No changes detected"

**Cause:** Testing database already matches the last migration

**Solution:** This is normal if you haven't made new changes

### "Permission denied"

**Cause:** Database credentials incorrect or user lacks permissions

**Solution:** 
- Verify credentials in `~/supabase-migrations/.env`
- Ensure user has `CREATE` permissions
- Use `postgres` or `service_role` user

### "Migration conflicts"

**Cause:** Production has manual changes not tracked in migrations

**Solution:**
- Review Production schema
- Create baseline migration if needed
- Consider resetting migration history

### "pg_dump: command not found"

**Cause:** PostgreSQL client tools not installed

**Solution:**
```bash
sudo apt-get update
sudo apt-get install postgresql-client
```

## Migration Checklist

Before each production deployment:

- [ ] Changes tested in Testing environment
- [ ] Migration generated successfully
- [ ] SQL reviewed for dangerous operations
- [ ] Production backup created
- [ ] Migration validated (no DROP/TRUNCATE)
- [ ] Team notified (if applicable)
- [ ] Apply during maintenance window (if applicable)
- [ ] Deployment verified
- [ ] Rollback plan ready

## Example Scenarios

### Scenario 1: Add New Table

```sql
-- Generated migration
CREATE TABLE public.user_preferences (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid REFERENCES auth.users(id) NOT NULL,
    theme text NOT NULL DEFAULT 'light',
    notifications boolean NOT NULL DEFAULT true,
    created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own preferences"
    ON public.user_preferences
    FOR SELECT
    USING (auth.uid() = user_id);
```

**Status:** ✅ Safe - No data loss risk

### Scenario 2: Add Column to Existing Table

```sql
-- Generated migration
ALTER TABLE public.articles 
    ADD COLUMN featured boolean NOT NULL DEFAULT false;
```

**Status:** ✅ Safe - Existing data preserved, new column has default

### Scenario 3: Dangerous - Change Column Type

```sql
-- Generated migration
ALTER TABLE public.users
    ALTER COLUMN age TYPE integer USING age::integer;
```

**Status:** ⚠️ Risky - May fail if existing data not convertible

**Better approach:**
1. Add new column `age_int integer`
2. Migrate data: `UPDATE users SET age_int = age::integer WHERE age ~ '^\d+$'`
3. Verify data
4. Drop old column in separate migration

## Support

For issues or questions:
1. Check this guide
2. Review Supabase CLI docs: https://supabase.com/docs/guides/cli
3. Check migration logs in `~/supabase-migrations/`
