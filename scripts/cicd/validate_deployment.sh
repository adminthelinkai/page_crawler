#!/bin/bash
# =============================================================================
# Supabase Deployment Validation Script
# Validates that the migration was successful
# =============================================================================

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="${SCRIPT_DIR}/../../reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

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
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }
log_error() { echo -e "${RED}[✗]${NC} $1"; }

VALIDATION_PASSED=0
VALIDATION_FAILED=0
VALIDATION_WARNINGS=0

record_pass() { ((VALIDATION_PASSED++)); log_success "$1"; }
record_fail() { ((VALIDATION_FAILED++)); log_error "$1"; }
record_warn() { ((VALIDATION_WARNINGS++)); log_warn "$1"; }

# -----------------------------------------------------------------------------
# Validation Functions
# -----------------------------------------------------------------------------

validate_ssh_connection() {
    echo ""
    echo "📡 Validating SSH Connection"
    echo "----------------------------"
    
    if ssh -i "${SSH_KEY}" -o StrictHostKeyChecking=no -o ConnectTimeout=10 "root@${VPS_IP}" "echo 'OK'" > /dev/null 2>&1; then
        record_pass "SSH connection to ${VPS_IP} successful"
    else
        record_fail "SSH connection to ${VPS_IP} failed"
        return 1
    fi
}

validate_container_health() {
    echo ""
    echo "🐳 Validating Container Health"
    echo "-------------------------------"
    
    local status
    status=$(ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker inspect -f '{{.State.Health.Status}}' ${DB_CONTAINER} 2>/dev/null || echo 'unknown'")
    
    case "$status" in
        "healthy")
            record_pass "PostgreSQL container is healthy"
            ;;
        "starting")
            record_warn "PostgreSQL container is still starting"
            ;;
        *)
            record_fail "PostgreSQL container health status: $status"
            ;;
    esac
}

validate_database_connection() {
    echo ""
    echo "🔌 Validating Database Connection"
    echo "----------------------------------"
    
    if ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT 1;'" > /dev/null 2>&1; then
        record_pass "Database connection successful"
    else
        record_fail "Database connection failed"
        return 1
    fi
}

validate_schema_presence() {
    echo ""
    echo "📊 Validating Schema Presence"
    echo "-----------------------------"
    
    # Count tables in public schema
    local table_count
    table_count=$(ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -t -A -c \
        \"SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';\"")
    
    if [[ "$table_count" -gt 0 ]]; then
        record_pass "Public schema has ${table_count} tables"
    else
        record_warn "No tables found in public schema"
    fi
    
    # List tables
    echo ""
    log_info "Tables in public schema:"
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c \
        \"SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;\"" 2>/dev/null || true
}

validate_rls_policies() {
    echo ""
    echo "🔒 Validating RLS Policies"
    echo "--------------------------"
    
    # Count RLS-enabled tables
    local rls_count
    rls_count=$(ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -t -A -c \
        \"SELECT COUNT(*) FROM pg_tables WHERE schemaname = 'public' AND rowsecurity = true;\"")
    
    if [[ "$rls_count" -gt 0 ]]; then
        record_pass "RLS enabled on ${rls_count} tables"
    else
        record_warn "No tables have RLS enabled"
    fi
    
    # Count policies
    local policy_count
    policy_count=$(ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -t -A -c \
        \"SELECT COUNT(*) FROM pg_policy pol
        JOIN pg_class cls ON pol.polrelid = cls.oid
        JOIN pg_namespace nsp ON cls.relnamespace = nsp.oid
        WHERE nsp.nspname = 'public';\"")
    
    log_info "Total RLS policies in public schema: ${policy_count}"
}

validate_extensions() {
    echo ""
    echo "🧩 Validating Extensions"
    echo "------------------------"
    
    log_info "Installed extensions:"
    ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c \
        \"SELECT extname, extversion FROM pg_extension ORDER BY extname;\"" 2>/dev/null || true
    
    record_pass "Extensions query successful"
}

validate_supabase_services() {
    echo ""
    echo "🚀 Validating Supabase Services"
    echo "-------------------------------"
    
    local services=("supabase-rest" "supabase-auth" "supabase-storage" "supabase-kong" "supabase-studio")
    
    for service in "${services[@]}"; do
        local container_status
        container_status=$(ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
            "docker ps --filter 'name=${service}' --format '{{.Status}}' | head -1" 2>/dev/null || echo "not found")
        
        if [[ "$container_status" == *"Up"* ]]; then
            record_pass "${service}: Running"
        elif [[ "$container_status" == "not found" ]]; then
            record_warn "${service}: Not found"
        else
            record_fail "${service}: ${container_status}"
        fi
    done
}

run_test_queries() {
    echo ""
    echo "🧪 Running Test Queries"
    echo "-----------------------"
    
    # Test simple query
    if ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT current_timestamp;'" > /dev/null 2>&1; then
        record_pass "Simple query executed successfully"
    else
        record_fail "Simple query failed"
    fi
    
    # Test schema introspection
    if ssh -i "${SSH_KEY}" "root@${VPS_IP}" \
        "docker exec ${DB_CONTAINER} psql -U ${DB_USER} -d ${DB_NAME} -c \
        \"SELECT schemaname, COUNT(*) FROM pg_tables GROUP BY schemaname;\"" > /dev/null 2>&1; then
        record_pass "Schema introspection query successful"
    else
        record_fail "Schema introspection query failed"
    fi
}

generate_report() {
    echo ""
    echo "📋 Generating Validation Report"
    echo "--------------------------------"
    
    mkdir -p "${REPORT_DIR}"
    
    local report_file="${REPORT_DIR}/validation_report_${TIMESTAMP}.txt"
    
    cat > "$report_file" << EOF
=============================================================================
SUPABASE DEPLOYMENT VALIDATION REPORT
=============================================================================
Timestamp:       $(date -u +%Y-%m-%dT%H:%M:%SZ)
Production VPS:  ${VPS_IP}
Container:       ${DB_CONTAINER}

VALIDATION SUMMARY
------------------
✓ Passed:   ${VALIDATION_PASSED}
⚠ Warnings: ${VALIDATION_WARNINGS}
✗ Failed:   ${VALIDATION_FAILED}

OVERALL STATUS: $(if [[ $VALIDATION_FAILED -eq 0 ]]; then echo "✅ SUCCESS"; else echo "❌ FAILED"; fi)

=============================================================================
EOF
    
    log_info "Report saved: ${report_file}"
}

print_summary() {
    echo ""
    echo "=============================================="
    echo "  VALIDATION SUMMARY"
    echo "=============================================="
    echo ""
    echo -e "  ${GREEN}✓ Passed:${NC}   ${VALIDATION_PASSED}"
    echo -e "  ${YELLOW}⚠ Warnings:${NC} ${VALIDATION_WARNINGS}"
    echo -e "  ${RED}✗ Failed:${NC}   ${VALIDATION_FAILED}"
    echo ""
    
    if [[ $VALIDATION_FAILED -eq 0 ]]; then
        echo -e "  ${GREEN}Overall Status: SUCCESS${NC}"
        return 0
    else
        echo -e "  ${RED}Overall Status: FAILED${NC}"
        return 1
    fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "=============================================="
    echo "  Supabase Deployment Validation"
    echo "=============================================="
    
    validate_ssh_connection || exit 1
    validate_container_health
    validate_database_connection || exit 1
    validate_schema_presence
    validate_rls_policies
    validate_extensions
    validate_supabase_services
    run_test_queries
    generate_report
    print_summary
}

main "$@"
