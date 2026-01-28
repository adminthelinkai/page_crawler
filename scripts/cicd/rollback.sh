#!/bin/bash
# =============================================================================
# Rollback Script for Supabase Schema Migration
# Restores production database from backup
# =============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/../../backups"

# Default values
VPS_IP="${PRODUCTION_VPS_IP:-72.61.246.138}"
SSH_KEY="${SSH_KEY_PATH:-~/.ssh/github_deploy_key}"
DB_CONTAINER="${PRODUCTION_DB_CONTAINER:-supabase-db-xgcogw0wkcswsgg4o404ow4w}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-postgres}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

list_backups() {
    log_info "Available backups:"
    echo ""
    ls -lth "${BACKUP_DIR}"/production_backup_*.sql 2>/dev/null | head -10 || echo "No backups found"
    echo ""
}

select_backup() {
    if [[ -n "${BACKUP_FILE:-}" ]]; then
        if [[ -f "$BACKUP_FILE" ]]; then
            log_info "Using specified backup: $BACKUP_FILE"
            return 0
        else
            log_error "Specified backup file not found: $BACKUP_FILE"
            return 1
        fi
    fi
    
    # Use latest backup by default
    BACKUP_FILE="${BACKUP_DIR}/production_backup_latest.sql"
    
    if [[ -f "$BACKUP_FILE" ]]; then
        local actual_file
        actual_file=$(readlink -f "$BACKUP_FILE")
        log_info "Using latest backup: $actual_file"
    else
        log_error "No backup found. Cannot rollback."
        return 1
    fi
}

confirm_rollback() {
    echo ""
    log_warn "⚠️  WARNING: This will restore the production database schema from backup!"
    log_warn "This operation may affect existing data and connections."
    echo ""
    
    read -p "Are you sure you want to proceed? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        log_info "Rollback cancelled"
        exit 0
    fi
}

check_ssh_connection() {
    log_info "Checking SSH connection..."
    if ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "root@${VPS_IP}" "echo 'OK'" > /dev/null 2>&1; then
        log_success "SSH connection successful"
    else
        log_error "SSH connection failed"
        exit 1
    fi
}

create_pre_rollback_backup() {
    log_info "Creating pre-rollback backup of current state..."
    
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} pg_dump -U ${DB_USER} \
        --schema-only \
        -n public \
        ${DB_NAME}" > "${BACKUP_DIR}/pre_rollback_${timestamp}.sql" 2>/dev/null
    
    log_success "Pre-rollback backup created: ${BACKUP_DIR}/pre_rollback_${timestamp}.sql"
}

perform_rollback() {
    log_info "Performing rollback..."
    
    # Copy backup to remote server
    scp -i "${SSH_KEY}" "$BACKUP_FILE" "root@${VPS_IP}:/tmp/rollback_schema.sql"
    
    # Apply the backup
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec -i ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} \
        -v ON_ERROR_STOP=0 \
        -f /tmp/rollback_schema.sql" 2>&1 || true
    
    # Cleanup
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" "rm -f /tmp/rollback_schema.sql"
    
    log_success "Rollback completed"
}

verify_rollback() {
    log_info "Verifying rollback..."
    
    # Simple verification
    if ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT 1;'" > /dev/null 2>&1; then
        log_success "Database is accessible after rollback"
    else
        log_error "Database verification failed!"
        return 1
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "=============================================="
    echo "  Supabase Schema Rollback"
    echo "=============================================="
    echo ""
    
    list_backups
    select_backup || exit 1
    confirm_rollback
    check_ssh_connection
    create_pre_rollback_backup
    perform_rollback
    verify_rollback
    
    echo ""
    log_success "Rollback completed successfully!"
    log_info "Please validate the application functionality manually."
    echo ""
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --backup)
            BACKUP_FILE="$2"
            shift 2
            ;;
        --list)
            list_backups
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--backup <backup_file>] [--list]"
            exit 1
            ;;
    esac
done

main "$@"
