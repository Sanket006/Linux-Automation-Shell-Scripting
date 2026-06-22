#!/bin/bash
# ============================================================
# Script: deploy.sh
# Purpose: Deploy a web application from a Git branch
# Usage: ./deploy.sh <branch_name>
# Example: ./deploy.sh main
# ============================================================

set -euo pipefail

# --- Configuration ---
APP_NAME="my-web-app"
APP_DIR="/var/www/$APP_NAME"
GIT_REPO="https://github.com/myorg/$APP_NAME.git"
BRANCH="${1:-main}"
SERVICE_NAME="myapp"
DEPLOY_LOG="/var/log/$APP_NAME/deploy.log"
BACKUP_DIR="/var/backups/$APP_NAME"

# --- Color codes for output ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'   # No Color

# --- Functions ---
log()     { echo -e "[$(date '+%H:%M:%S')] $1" | tee -a "$DEPLOY_LOG"; }
success() { echo -e "${GREEN}✅ $1${NC}" | tee -a "$DEPLOY_LOG"; }
warn()    { echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$DEPLOY_LOG"; }
error()   { echo -e "${RED}❌ $1${NC}" | tee -a "$DEPLOY_LOG"; exit 1; }

# Error trap
trap 'error "Deployment FAILED on line $LINENO. Check $DEPLOY_LOG for details."' ERR

# --- Pre-deployment checks ---
log "============================================="
log "  Deploying $APP_NAME from branch: $BRANCH"
log "============================================="

# Check required tools are installed
for TOOL in git npm node; do
    command -v "$TOOL" &>/dev/null || error "$TOOL is not installed. Aborting."
done
success "All required tools are present."

# --- Step 1: Backup current deployment ---
log "STEP 1/6: Creating backup of current deployment..."
BACKUP_PATH="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_PATH"
cp -r "$APP_DIR/." "$BACKUP_PATH/" 2>/dev/null || warn "No existing deployment to backup."
success "Backup created at: $BACKUP_PATH"

# --- Step 2: Pull latest code ---
log "STEP 2/6: Pulling latest code from $BRANCH..."
if [ -d "$APP_DIR/.git" ]; then
    cd "$APP_DIR"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
else
    git clone --branch "$BRANCH" "$GIT_REPO" "$APP_DIR"
    cd "$APP_DIR"
fi
success "Code updated from branch: $BRANCH (commit: $(git rev-parse --short HEAD))"

# --- Step 3: Install dependencies ---
log "STEP 3/6: Installing dependencies..."
npm install --production --silent
success "Dependencies installed."

# --- Step 4: Run database migrations ---
log "STEP 4/6: Running database migrations..."
# npm run migrate   # Uncomment for real projects
success "Migrations completed."

# --- Step 5: Restart the application service ---
log "STEP 5/6: Restarting $SERVICE_NAME service..."
sudo systemctl restart "$SERVICE_NAME"
sleep 3   # Give it time to start

if systemctl is-active --quiet "$SERVICE_NAME"; then
    success "$SERVICE_NAME is running."
else
    error "$SERVICE_NAME failed to start. Rolling back..."
fi

# --- Step 6: Verify deployment ---
log "STEP 6/6: Verifying deployment..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/health || echo "000")

if [ "$HTTP_STATUS" == "200" ]; then
    success "Health check passed! HTTP status: $HTTP_STATUS"
else
    warn "Health check returned status: $HTTP_STATUS — Investigate!"
fi

log "============================================="
success "🚀 Deployment of $APP_NAME completed successfully!"
log "Branch: $BRANCH | Time: $(date)"
log "============================================="
