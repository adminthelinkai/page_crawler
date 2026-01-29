#!/bin/bash
# =============================================================================
# Manual Migration Setup Script
# One-time setup on Testing VPS for Supabase CLI-based migrations
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
MIGRATION_DIR="$HOME/supabase-migrations"
TESTING_DB_HOST="localhost"
TESTING_DB_PORT="54322"
TESTING_DB_USER="postgres"
TESTING_DB_NAME="postgres"
TESTING_DB_PASSWORD="${TESTING_DB_PASSWORD:-your_password_here}"

PRODUCTION_DB_HOST="72.61.246.138"
PRODUCTION_DB_PORT="54322"
PRODUCTION_DB_USER="postgres"
PRODUCTION_DB_NAME="postgres"
PRODUCTION_DB_PASSWORD="${PRODUCTION_DB_PASSWORD:-your_password_here}"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------

check_node() {
    log_info "Checking Node.js installation..."
    if command -v node > /dev/null 2>&1; then
        NODE_VERSION=$(node --version)
        log_success "Node.js installed: $NODE_VERSION"
        return 0
    else
        log_error "Node.js not found"
        return 1
    fi
}

install_node() {
    log_info "Installing Node.js..."
    
    # Install NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    
    # Install Node.js
    sudo apt-get install -y nodejs
    
    log_success "Node.js installed"
}

install_supabase_cli() {
    log_info "Installing Supabase CLI..."
    
    npm install -g supabase
    
    if command -v supabase > /dev/null 2>&1; then
        SUPABASE_VERSION=$(supabase --version)
        log_success "Supabase CLI installed: $SUPABASE_VERSION"
    else
        log_error "Supabase CLI installation failed"
        return 1
    fi
}

initialize_project() {
    log_info "Initializing Supabase project..."
    
    mkdir -p "$MIGRATION_DIR"
    cd "$MIGRATION_DIR"
    
    # Initialize supabase project
    if [ ! -d "supabase" ]; then
        supabase init
        log_success "Supabase project initialized at $MIGRATION_DIR"
    else
        log_warn "Supabase project already exists at $MIGRATION_DIR"
    fi
}

create_db_config() {
    log_info "Creating database configuration..."
    
    cat > "$MIGRATION_DIR/.env" <<EOF
# Testing Database
TESTING_DB_URL="postgresql://${TESTING_DB_USER}:${TESTING_DB_PASSWORD}@${TESTING_DB_HOST}:${TESTING_DB_PORT}/${TESTING_DB_NAME}"

# Production Database
PRODUCTION_DB_URL="postgresql://${PRODUCTION_DB_USER}:${PRODUCTION_DB_PASSWORD}@${PRODUCTION_DB_HOST}:${PRODUCTION_DB_PORT}/${PRODUCTION_DB_NAME}"
EOF

    log_success "Database configuration created at $MIGRATION_DIR/.env"
    log_warn "Please update passwords in $MIGRATION_DIR/.env"
}

create_helper_scripts() {
    log_info "Creating helper scripts..."
    
    # Create quick reference script
    cat > "$MIGRATION_DIR/quick-reference.sh" <<'EOF'
#!/bin/bash
# Quick Reference for Manual Migrations

echo "=== Supabase Manual Migration Quick Reference ==="
echo ""
echo "1. Generate Migration (after making changes in Testing):"
echo "   cd ~/supabase-migrations"
echo "   source .env"
echo "   supabase db diff -f migration_name --schema public,auth,storage"
echo ""
echo "2. Review Migration:"
echo "   cat supabase/migrations/YYYYMMDDHHMMSS_migration_name.sql"
echo ""
echo "3. Apply to Production:"
echo "   export DATABASE_URL=\$PRODUCTION_DB_URL"
echo "   supabase db push"
echo ""
echo "4. Verify:"
echo "   psql \$PRODUCTION_DB_URL -c '\\dt public.*'"
echo ""
EOF
    
    chmod +x "$MIGRATION_DIR/quick-reference.sh"
    log_success "Helper scripts created"
}

setup_git() {
    log_info "Initializing Git repository (optional)..."
    
    cd "$MIGRATION_DIR"
    
    if [ ! -d ".git" ]; then
        git init
        
        cat > .gitignore <<EOF
.env
*.log
.DS_Store
EOF
        
        git add .
        git commit -m "Initial commit: Supabase migration setup"
        
        log_success "Git repository initialized"
    else
        log_warn "Git repository already exists"
    fi
}

print_next_steps() {
    echo ""
    echo "=============================================="
    log_success "Setup completed successfully!"
    echo "=============================================="
    echo ""
    echo "Next steps:"
    echo ""
    echo "1. Update database passwords in:"
    echo "   $MIGRATION_DIR/.env"
    echo ""
    echo "2. Make schema changes in Testing Supabase"
    echo ""
    echo "3. Generate migration:"
    echo "   cd $MIGRATION_DIR"
    echo "   source .env"
    echo "   supabase db diff -f my_migration --schema public"
    echo ""
    echo "4. Review and apply to Production"
    echo ""
    echo "For quick reference, run:"
    echo "   $MIGRATION_DIR/quick-reference.sh"
    echo ""
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo ""
    echo "=============================================="
    echo "  Supabase Manual Migration Setup"
    echo "=============================================="
    echo ""
    
    # Check and install Node.js
    if ! check_node; then
        install_node
    fi
    
    # Install Supabase CLI
    install_supabase_cli
    
    # Initialize project
    initialize_project
    
    # Create configuration
    create_db_config
    
    # Create helper scripts
    create_helper_scripts
    
    # Setup Git (optional)
    setup_git
    
    # Print next steps
    print_next_steps
}

main "$@"
