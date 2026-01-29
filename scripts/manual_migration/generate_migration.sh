#!/bin/bash
# =============================================================================
# Generate Migration Script
# Generates SQL migration file from Testing database schema changes
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
MIGRATION_NAME="${1:-schema_update_$(date +%Y%m%d_%H%M%S)}"

# Check if .env exists
if [ ! -f "$MIGRATION_DIR/.env" ]; then
    log_error "Configuration file not found: $MIGRATION_DIR/.env"
    log_error "Please run setup_manual_migration.sh first"
    exit 1
fi

# Load environment variables
source "$MIGRATION_DIR/.env"

# Change to migration directory
cd "$MIGRATION_DIR"

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

echo ""
echo "=============================================="
echo "  Generate Migration: $MIGRATION_NAME"
echo "=============================================="
echo ""

log_info "Connecting to Testing database..."

# Set database URL for diff
export DATABASE_URL="$TESTING_DB_URL"

log_info "Generating migration diff..."

# Generate migration
if supabase db diff -f "$MIGRATION_NAME" --schema public,auth,storage; then
    log_success "Migration generated successfully"
    
    # Find the generated migration file
    MIGRATION_FILE=$(ls -t supabase/migrations/*_${MIGRATION_NAME}.sql 2>/dev/null | head -n 1)
    
    if [ -n "$MIGRATION_FILE" ]; then
        echo ""
        log_info "Migration file: $MIGRATION_FILE"
        echo ""
        log_info "Preview (first 20 lines):"
        echo "----------------------------------------"
        head -n 20 "$MIGRATION_FILE"
        echo "----------------------------------------"
        echo ""
        
        # Count lines
        LINE_COUNT=$(wc -l < "$MIGRATION_FILE")
        log_info "Total lines: $LINE_COUNT"
        
        # Check for dangerous operations
        echo ""
        log_warn "Checking for dangerous operations..."
        
        DANGEROUS_OPS=$(grep -iE "DROP TABLE|TRUNCATE|DELETE FROM|DROP COLUMN" "$MIGRATION_FILE" || true)
        
        if [ -n "$DANGEROUS_OPS" ]; then
            log_error "⚠️  DANGEROUS OPERATIONS DETECTED:"
            echo "$DANGEROUS_OPS"
            echo ""
            log_error "Please review carefully before applying to production!"
        else
            log_success "No dangerous operations detected"
        fi
        
        echo ""
        log_info "Next steps:"
        echo "1. Review full migration: cat $MIGRATION_FILE"
        echo "2. Validate migration: ./scripts/manual_migration/validate_migration.sh"
        echo "3. Apply to production: ./scripts/manual_migration/apply_migration.sh"
        
    else
        log_warn "Migration file not found - possibly no changes detected"
    fi
else
    log_error "Migration generation failed"
    exit 1
fi

echo ""
