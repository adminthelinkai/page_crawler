#!/bin/bash
# =============================================================================
# Apply Migration Script
# Applies validated migration to Production database with backup
# =============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Configuration
MIGRATION_DIR="${MIGRATION_DIR:-$HOME/supabase-migrations}"
BACKUP_DIR="$MIGRATION_DIR/backups"
MIGRATION_FILE="${1}"
FORCE_APPLY="${2:-}"

# Check arguments
if [ -z "$MIGRATION_FILE" ]; then
    log_error "Usage: $0 <migration_file.sql> [--force]"
    exit 1
fi

if [ ! -f "$MIGRATION_FILE" ]; then
    log_error "Migration file not found: $MIGRATION_FILE"
    exit 1
fi

# Load environment
if [ ! -f "$MIGRATION_DIR/.env" ]; then
    log_error "Configuration not found: $MIGRATION_DIR/.env"
    exit 1
fi

source "$MIGRATION_DIR/.env"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

create_backup() {
    log_info "Creating backup of Production database..."
    
    mkdir -p "$BACKUP_DIR"
    
    local backup_file="$BACKUP_DIR/prod_backup_$(date +%Y%m%d_%H%M%S).sql"
    
    # Extract connection details
    PROD_HOST=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*@\([^:]*\):.*/\1/p')
    PROD_PORT=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    PROD_DB=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*\/\([^?]*\).*/\1/p')
    PROD_USER=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
    
    # Create backup
    if PGPASSWORD="${PRODUCTION_DB_PASSWORD}" pg_dump \
        -h "$PROD_HOST" \
        -p "$PROD_PORT" \
        -U "$PROD_USER" \
        -d "$PROD_DB" \
        --schema-only \
        -n public -n auth -n storage \
        -f "$backup_file"; then
        
        log_success "Backup created: $backup_file"
        echo "$backup_file"
    else
        log_error "Backup failed"
        return 1
    fi
}

apply_migration() {
    local migration="$1"
    
    log_info "Applying migration to Production..."
    
    cd "$MIGRATION_DIR"
    
    # Set production database URL
    export DATABASE_URL="$PRODUCTION_DB_URL"
    
    # Apply using supabase db push
    if supabase db push; then
        log_success "Migration applied successfully"
        return 0
    else
        log_error "Migration failed"
        return 1
    fi
}

verify_migration() {
    log_info "Verifying migration..."
    
    # Extract production connection details
    PROD_HOST=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*@\([^:]*\):.*/\1/p')
    PROD_PORT=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    PROD_DB=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*\/\([^?]*\).*/\1/p')
    PROD_USER=$(echo "$PRODUCTION_DB_URL" | sed -n 's/.*:\/\/\([^:]*\):.*/\1/p')
    
    # List tables
    log_info "Tables in Production:"
    PGPASSWORD="${PRODUCTION_DB_PASSWORD}" psql \
        -h "$PROD_HOST" \
        -p "$PROD_PORT" \
        -U "$PROD_USER" \
        -d "$PROD_DB" \
        -c "\dt public.*" || true
    
    # Check RLS
    log_info "RLS-enabled tables:"
    PGPASSWORD="${PRODUCTION_DB_PASSWORD}" psql \
        -h "$PROD_HOST" \
        -p "$PROD_PORT" \
        -U "$PROD_USER" \
        -d "$PROD_DB" \
        -c "SELECT schemaname, tablename FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = true;" || true
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

echo ""
echo "=============================================="
echo "  Apply Migration to Production"
echo "=============================================="
echo ""

log_warn "⚠️  You are about to apply changes to PRODUCTION"
echo ""
log_info "Migration: $MIGRATION_FILE"
echo ""

# Validate first (unless --force)
if [ "$FORCE_APPLY" != "--force" ]; then
    if ! ./scripts/manual_migration/validate_migration.sh "$MIGRATION_FILE"; then
        log_error "Validation failed. Use --force to apply anyway (not recommended)"
        exit 1
    fi
    echo ""
fi

# Confirm
read -p "Continue with Production deployment? (yes/no): " -r
echo ""

if [[ ! $REPLY =~ ^[Yy](es)?$ ]]; then
    log_warn "Deployment cancelled"
    exit 0
fi

# Create backup
BACKUP_FILE=$(create_backup)
if [ $? -ne 0 ]; then
    log_error "Backup failed - aborting deployment"
    exit 1
fi

echo ""

# Apply migration
if apply_migration "$MIGRATION_FILE"; then
    log_success "✅ Migration applied successfully"
    
    echo ""
    
    # Verify
    verify_migration
    
    echo ""
    echo "=============================================="
    log_success "✅ Deployment completed successfully"
    echo "=============================================="
    echo ""
    log_info "Backup saved at: $BACKUP_FILE"
    echo ""
else
    log_error "❌ Migration failed"
    echo ""
    log_warn "To rollback, restore from backup:"
    log_warn "  psql \$PRODUCTION_DB_URL < $BACKUP_FILE"
    exit 1
fi
