#!/bin/bash
# =============================================================================
# Supabase Schema Extraction Script
# Extracts database schema and RLS policies from a Supabase PostgreSQL container
# =============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/../../migration_output"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Default values (can be overridden via environment variables)
VPS_IP="${TESTING_VPS_IP:-72.61.226.144}"
SSH_KEY="${SSH_KEY_PATH:-~/.ssh/github_deploy_key}"
DB_CONTAINER="${TESTING_DB_CONTAINER:-supabase-db-lcs8k80cgc4wocgg4gs8owgo}"
DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-postgres}"

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

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

check_ssh_connection() {
    log_info "Checking SSH connection to ${VPS_IP}..."
    if ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "root@${VPS_IP}" "echo 'Connection OK'" > /dev/null 2>&1; then
        log_success "SSH connection successful"
        return 0
    else
        log_error "Failed to connect to ${VPS_IP}"
        return 1
    fi
}

check_container_running() {
    log_info "Checking if container ${DB_CONTAINER} is running..."
    local status
    status=$(ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker inspect -f '{{.State.Running}}' ${DB_CONTAINER} 2>/dev/null || echo 'false'")
    
    if [[ "$status" == "true" ]]; then
        log_success "Container is running"
        return 0
    else
        log_error "Container ${DB_CONTAINER} is not running"
        return 1
    fi
}

extract_schema() {
    log_info "Extracting database schema..."
    
    mkdir -p "${OUTPUT_DIR}"
    
    # Extract full schema
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} pg_dump -U ${DB_USER} \
        --schema-only \
        --no-owner \
        --no-privileges \
        --no-comments \
        -n public \
        -n auth \
        -n storage \
        ${DB_NAME} | sed -E 's/^CREATE SCHEMA (public|auth|storage);$/-- &/' | sed -E 's/^ALTER SCHEMA (public|auth|storage) OWNER TO .*$/-- &/' > "${OUTPUT_DIR}/schema_${TIMESTAMP}.sql"
    
    if [[ -s "${OUTPUT_DIR}/schema_${TIMESTAMP}.sql" ]]; then
        log_success "Schema extracted: ${OUTPUT_DIR}/schema_${TIMESTAMP}.sql"
        # Create symlink to latest
        ln -sf "schema_${TIMESTAMP}.sql" "${OUTPUT_DIR}/schema_latest.sql"
    else
        log_error "Schema extraction failed or produced empty file"
        return 1
    fi
}

extract_rls_policies() {
    log_info "Extracting RLS policies..."
    
    # Extract RLS enabled tables
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -t -A -c \"
        SELECT 'ALTER TABLE ' || schemaname || '.' || tablename || ' ENABLE ROW LEVEL SECURITY;'
        FROM pg_tables
        WHERE schemaname IN ('public', 'auth', 'storage')
        AND rowsecurity = true;
        \"" > "${OUTPUT_DIR}/rls_enable_${TIMESTAMP}.sql"
    
    # Extract policy definitions
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c \"
        SELECT 
            'CREATE POLICY ' || quote_ident(pol.polname) || 
            ' ON ' || nsp.nspname || '.' || cls.relname ||
            ' FOR ' || CASE pol.polcmd 
                WHEN 'r' THEN 'SELECT'
                WHEN 'a' THEN 'INSERT'
                WHEN 'w' THEN 'UPDATE'
                WHEN 'd' THEN 'DELETE'
                WHEN '*' THEN 'ALL'
            END ||
            CASE WHEN pol.polroles = '{0}' THEN '' 
                 ELSE ' TO ' || array_to_string(ARRAY(SELECT rolname FROM pg_roles WHERE oid = ANY(pol.polroles)), ', ') 
            END ||
            CASE WHEN pol.polqual IS NOT NULL THEN ' USING (' || pg_get_expr(pol.polqual, pol.polrelid) || ')' ELSE '' END ||
            CASE WHEN pol.polwithcheck IS NOT NULL THEN ' WITH CHECK (' || pg_get_expr(pol.polwithcheck, pol.polrelid) || ')' ELSE '' END ||
            ';'
        FROM pg_policy pol
        JOIN pg_class cls ON pol.polrelid = cls.oid
        JOIN pg_namespace nsp ON cls.relnamespace = nsp.oid
        WHERE nsp.nspname IN ('public', 'auth', 'storage');
        \"" 2>/dev/null | grep -v "^(" | grep -v "^$" > "${OUTPUT_DIR}/policies_${TIMESTAMP}.sql" || true
    
    log_success "RLS policies extracted"
    ln -sf "rls_enable_${TIMESTAMP}.sql" "${OUTPUT_DIR}/rls_enable_latest.sql"
    ln -sf "policies_${TIMESTAMP}.sql" "${OUTPUT_DIR}/policies_latest.sql"
}

extract_functions() {
    log_info "Extracting custom functions..."
    
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c \"
        SELECT pg_get_functiondef(p.oid)
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
        AND p.prokind = 'f';
        \"" 2>/dev/null > "${OUTPUT_DIR}/functions_${TIMESTAMP}.sql" || true
    
    log_success "Functions extracted: ${OUTPUT_DIR}/functions_${TIMESTAMP}.sql"
    ln -sf "functions_${TIMESTAMP}.sql" "${OUTPUT_DIR}/functions_latest.sql"
}

extract_extensions() {
    log_info "Extracting extensions..."
    
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -t -A -c \"
        SELECT 'CREATE EXTENSION IF NOT EXISTS ' || quote_ident(extname) || ';'
        FROM pg_extension
        WHERE extname != 'plpgsql';
        \"" > "${OUTPUT_DIR}/extensions_${TIMESTAMP}.sql"
    
    log_success "Extensions extracted: ${OUTPUT_DIR}/extensions_${TIMESTAMP}.sql"
    ln -sf "extensions_${TIMESTAMP}.sql" "${OUTPUT_DIR}/extensions_latest.sql"
}

generate_report() {
    log_info "Generating extraction report..."
    
    cat > "${OUTPUT_DIR}/extraction_report_${TIMESTAMP}.txt" << EOF
=============================================================================
SUPABASE SCHEMA EXTRACTION REPORT
=============================================================================
Timestamp:       ${TIMESTAMP}
Source VPS:      ${VPS_IP}
Container:       ${DB_CONTAINER}
Database:        ${DB_NAME}

Extracted Files:
- schema_${TIMESTAMP}.sql
- rls_enable_${TIMESTAMP}.sql
- policies_${TIMESTAMP}.sql
- functions_${TIMESTAMP}.sql
- extensions_${TIMESTAMP}.sql

File Sizes:
$(ls -lh "${OUTPUT_DIR}"/*_${TIMESTAMP}.sql 2>/dev/null | awk '{print "  - " $9 ": " $5}')

=============================================================================
EOF
    
    log_success "Report generated: ${OUTPUT_DIR}/extraction_report_${TIMESTAMP}.txt"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "=============================================="
    echo "  Supabase Schema Extraction Script"
    echo "=============================================="
    echo ""
    
    check_ssh_connection || exit 1
    check_container_running || exit 1
    
    extract_extensions
    extract_schema
    extract_rls_policies
    extract_functions
    generate_report
    
    echo ""
    log_success "All extractions completed successfully!"
    echo "Output directory: ${OUTPUT_DIR}"
    echo ""
}

main "$@"
