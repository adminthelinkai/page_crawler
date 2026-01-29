# Manual Migration Scripts

This directory contains scripts for manually migrating Supabase schema changes from Testing to Production.

## Quick Reference

### Initial Setup (Run Once)

```bash
# SSH into Testing VPS
ssh -i ~/.ssh/github_deploy_key root@72.61.226.144

# Run setup script
./scripts/manual_migration/setup_manual_migration.sh
```

### Regular Workflow

1. **Make changes** in Testing Supabase (tables, columns, RLS policies)

2. **Generate migration:**
   ```bash
   ./scripts/manual_migration/generate_migration.sh my_feature_name
   ```

3. **Validate migration:**
   ```bash
   ./scripts/manual_migration/validate_migration.sh supabase/migrations/YYYYMMDD_HHMMSS_my_feature_name.sql
   ```

4. **Apply to Production:**
   ```bash
   ./scripts/manual_migration/apply_migration.sh supabase/migrations/YYYYMMDD_HHMMSS_my_feature_name.sql
   ```

## Scripts

### `setup_manual_migration.sh`
**Purpose:** One-time setup on Testing VPS  
**What it does:**
- Installs Node.js and npm
- Installs Supabase CLI
- Initializes migration project
- Creates database configuration

**Usage:**
```bash
ssh root@72.61.226.144 'bash -s' < scripts/manual_migration/setup_manual_migration.sh
```

---

### `generate_migration.sh`
**Purpose:** Generate SQL migration from Testing database  
**What it does:**
- Connects to Testing database
- Runs `supabase db diff` to detect changes
- Creates timestamped SQL file
- Shows preview and checks for dangerous operations

**Usage:**
```bash
# On Testing VPS
cd ~/supabase-migrations
./generate_migration.sh add_user_table
```

---

### `validate_migration.sh`
**Purpose:** Safety check before applying to Production  
**What it does:**
- Scans for dangerous operations (DROP, TRUNCATE, DELETE)
- Counts safe operations (ADD COLUMN, CREATE TABLE, etc.)
- Checks RLS policy changes
- Reports file statistics

**Usage:**
```bash
./validate_migration.sh ~/supabase-migrations/supabase/migrations/20260129_1530_add_user_table.sql
```

**Exit codes:**
- `0` - Validation passed (safe)
- `1` - Validation failed (dangerous operations found)

---

### `apply_migration.sh`
**Purpose:** Apply migration to Production with safety checks  
**What it does:**
1. Runs validation (unless `--force` flag used)
2. Prompts for confirmation
3. Creates Production backup
4. Applies migration using `supabase db push`
5. Verifies deployment
6. Shows deployment report

**Usage:**
```bash
# Normal (recommended)
./apply_migration.sh ~/supabase-migrations/supabase/migrations/20260129_1530_add_user_table.sql

# Force apply (skip validation)
./apply_migration.sh ~/supabase-migrations/supabase/migrations/20260129_1530_add_user_table.sql --force
```

## Configuration

After running setup, update database credentials:

```bash
# On Testing VPS
nano ~/supabase-migrations/.env
```

Required variables:
```env
TESTING_DB_URL="postgresql://postgres:PASSWORD@localhost:54322/postgres"
PRODUCTION_DB_URL="postgresql://postgres:PASSWORD@72.61.246.138:54322/postgres"
```

## File Structure

```
~/supabase-migrations/          # On Testing VPS
├── .env                         # Database connection URLs
├── supabase/
│   ├── config.toml             # Supabase project config
│   └── migrations/             # Generated SQL files
│       ├── 20260129_1530_add_user_table.sql
│       └── 20260129_1600_add_rls_policies.sql
├── backups/                     # Production backups
│   └── prod_backup_20260129_1530.sql
└── quick-reference.sh          # Helper commands cheat sheet
```

## Safety Features

### Automatic Checks
- ✅ Validates SQL before applying
- ✅ Creates automatic backups
- ✅ Requires manual confirmation
- ✅ Logs all operations
- ✅ Shows deployment preview

### Dangerous Operation Detection
Scripts warn or block these operations:
- `DROP TABLE` - **Blocked**
- `TRUNCATE` - **Blocked**
- `DELETE FROM` - **Warning**
- `DROP COLUMN` - **Warning**
- `ALTER COLUMN TYPE` - **Warning**

## Examples

### Example 1: Add New Table

```bash
# 1. Create table in Testing Supabase UI or SQL editor
# 2. Generate migration
ssh root@72.61.226.144 << EOF
cd ~/supabase-migrations
source .env
export DATABASE_URL=\$TESTING_DB_URL
supabase db diff -f add_articles_table --schema public
ls -lh supabase/migrations/
EOF

# 3. Download and review
scp -i ~/.ssh/github_deploy_key "root@72.61.226.144:~/supabase-migrations/supabase/migrations/*add_articles_table.sql" ./

# 4. SSH back and apply
ssh root@72.61.226.144 << EOF
cd ~/supabase-migrations
source .env
export DATABASE_URL=\$PRODUCTION_DB_URL
supabase db push
EOF
```

### Example 2: Add RLS Policies

```bash
# After creating policies in Testing
ssh root@72.61.226.144
cd ~/supabase-migrations
source .env

# Generate
export DATABASE_URL=$TESTING_DB_URL
supabase db diff -f add_article_policies --schema public

# Review
cat supabase/migrations/*add_article_policies.sql

# Apply
export DATABASE_URL=$PRODUCTION_DB_URL
supabase db push
```

## Rollback

If something goes wrong:

```bash
# List backups
ls -lh ~/supabase-migrations/backups/

# Restore backup
source ~/supabase-migrations/.env
psql $PRODUCTION_DB_URL < ~/supabase-migrations/backups/prod_backup_TIMESTAMP.sql
```

## Best Practices

1. **Descriptive names:** Use clear migration names like `add_user_preferences_table`
2. **Small changes:** One logical change per migration
3. **Test first:** Always verify in Testing before Production
4. **Review SQL:** Read the generated SQL file before applying
5. **Keep backups:** Maintain backups for at least 30 days

## Troubleshooting

### Issue: "supabase: command not found"
**Solution:** Run `setup_manual_migration.sh` first

### Issue: "No changes detected"
**Solution:** This is normal if Testing matches last migration. Make a change first.

### Issue: "Permission denied"
**Solution:** Check database credentials in `.env` file

### Issue: "Connection refused"
**Solution:** Verify VPS firewall allows PostgreSQL port (54322)

## More Information

See [MIGRATION_GUIDE.md](../../docs/MIGRATION_GUIDE.md) for comprehensive documentation.
