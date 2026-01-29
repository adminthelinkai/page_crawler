#!/bin/bash
# =============================================================================
# Validate Migration Script
# Validates migration SQL for dangerous operations and best practices
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
MIGRATION_FILE="${1}"

if [ -z "$MIGRATION_FILE" ]; then
    log_error "Usage: $0 <migration_file.sql>"
    exit 1
fi

if [ ! -f "$MIGRATION_FILE" ]; then
    log_error "Migration file not found: $MIGRATION_FILE"
    exit 1
fi

# -----------------------------------------------------------------------------
# Validation Functions
# -----------------------------------------------------------------------------

check_dangerous_ops() {
    local file="$1"
    local found=0
    
    log_info "Checking for dangerous operations..."
    
    # Check for DROP TABLE
    if grep -qi "DROP TABLE" "$file"; then
        log_error "❌ Found: DROP TABLE"
        grep -i "DROP TABLE" "$file"
        found=1
    fi
    
    # Check for TRUNCATE
    if grep -qi "TRUNCATE" "$file"; then
        log_error "❌ Found: TRUNCATE"
        grep -i "TRUNCATE" "$file"
        found=1
    fi
    
    # Check for DELETE FROM
    if grep -qi "DELETE FROM" "$file"; then
        log_warn "⚠️  Found: DELETE FROM"
        grep -i "DELETE FROM" "$file"
        found=1
    fi
    
    # Check for DROP COLUMN
    if grep -qi "DROP COLUMN" "$file"; then
        log_warn "⚠️  Found: DROP COLUMN"
        grep -i "DROP COLUMN" "$file"
        found=1
    fi
    
    # Check for ALTER COLUMN TYPE
    if grep -qi "ALTER COLUMN.*TYPE" "$file"; then
        log_warn "⚠️  Found: ALTER COLUMN TYPE (may cause data loss)"
        grep -i "ALTER COLUMN.*TYPE" "$file"
        found=1
    fi
    
    return $found
}

check_safe_ops() {
    local file="$1"
    
    log_info "Checking for safe operations..."
    
    # Count safe operations
    local add_column=$(grep -ci "ADD COLUMN" "$file" || true)
    local create_table=$(grep -ci "CREATE TABLE" "$file" || true)
    local create_index=$(grep -ci "CREATE INDEX" "$file" || true)
    local create_policy=$(grep -ci "CREATE POLICY" "$file" || true)
    local create_function=$(grep -ci "CREATE.*FUNCTION" "$file" || true)
    
    echo "  - ADD COLUMN: $add_column"
    echo "  - CREATE TABLE: $create_table"
    echo "  - CREATE INDEX: $create_index"
    echo "  - CREATE POLICY: $create_policy"
    echo "  - CREATE FUNCTION: $create_function"
}

check_rls_changes() {
    local file="$1"
    
    log_info "Checking for RLS policy changes..."
    
    if grep -qi "ENABLE ROW LEVEL SECURITY" "$file"; then
        log_success "✅ Found RLS enablement"
    fi
    
    if grep -qi "CREATE POLICY" "$file"; then
        local policy_count=$(grep -ci "CREATE POLICY" "$file")
        log_success "✅ Found $policy_count new policies"
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

echo ""
echo "=============================================="
echo "  Migration Validation"
echo "=============================================="
echo ""

log_info "Validating: $MIGRATION_FILE"
echo ""

# File stats
log_info "File statistics:"
echo "  - Size: $(du -h "$MIGRATION_FILE" | cut -f1)"
echo "  - Lines: $(wc -l < "$MIGRATION_FILE")"
echo ""

# Check for dangerous operations
VALIDATION_FAILED=0
if check_dangerous_ops "$MIGRATION_FILE"; then
    VALIDATION_FAILED=1
fi

echo ""

# Check for safe operations
check_safe_ops "$MIGRATION_FILE"

echo ""

# Check RLS changes
check_rls_changes "$MIGRATION_FILE"

echo ""
echo "=============================================="

if [ $VALIDATION_FAILED -eq 0 ]; then
    log_success "✅ Validation passed - migration looks safe"
    echo ""
    log_info "You can proceed with: ./scripts/manual_migration/apply_migration.sh $MIGRATION_FILE"
    exit 0
else
    log_error "❌ Validation failed - dangerous operations detected"
    echo ""
    log_warn "Please review the migration carefully before proceeding"
    log_warn "If you're sure, you can still apply with: ./scripts/manual_migration/apply_migration.sh $MIGRATION_FILE --force"
    exit 1
fi
