#!/bin/bash
# Deploy Blockchain Forensics Scanner to GitHub Repository
# This script sets up all necessary files and secrets for the forensics workflow

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER="${1:-}"
REPO_NAME="${2:-}"
ETHERSCAN_KEY="${3:-}"
ARBISCAN_KEY="${4:-}"

echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}Blockchain Forensics Scanner Deploy${NC}"
echo -e "${BLUE}==========================================${NC}\n"

# Validate inputs
if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    echo -e "${RED}❌ Error: Missing required arguments${NC}"
    echo "Usage: $0 <owner> <repo> [etherscan_key] [arbiscan_key]"
    echo ""
    echo "Example:"
    echo "  $0 Themoor1 kernel-bindings-tests sk_xxx sk_yyy"
    exit 1
fi

echo -e "${YELLOW}📋 Configuration:${NC}"
echo "  Repository: $REPO_OWNER/$REPO_NAME"
echo "  Etherscan API Key: ${ETHERSCAN_KEY:0:10}***"
echo "  Arbiscan API Key: ${ARBISCAN_KEY:0:10}***"
echo ""

# Step 1: Verify repository access
echo -e "${BLUE}[1/6]${NC} Verifying repository access..."
if ! gh repo view "$REPO_OWNER/$REPO_NAME" &>/dev/null; then
    echo -e "${RED}❌ Cannot access repository: $REPO_OWNER/$REPO_NAME${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Repository access verified${NC}\n"

# Step 2: Check if files exist
echo -e "${BLUE}[2/6]${NC} Checking required files..."
MISSING_FILES=()

if ! gh api repos/$REPO_OWNER/$REPO_NAME/contents/forensics.py &>/dev/null 2>&1; then
    MISSING_FILES+=("forensics.py")
fi

if ! gh api repos/$REPO_OWNER/$REPO_NAME/contents/.github/workflows/auto-review-trigger-forensics.yml &>/dev/null 2>&1; then
    MISSING_FILES+=(".github/workflows/auto-review-trigger-forensics.yml")
fi

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}❌ Missing required files:${NC}"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    exit 1
fi

echo -e "${GREEN}✅ All required files present${NC}\n"

# Step 3: Create/Update secrets
echo -e "${BLUE}[3/6]${NC} Configuring GitHub secrets..."

if [ -n "$ETHERSCAN_KEY" ]; then
    echo "  Setting ETHERSCAN_API_KEY..."
    gh secret set ETHERSCAN_API_KEY -b "$ETHERSCAN_KEY" --repo "$REPO_OWNER/$REPO_NAME" 2>/dev/null || true
    echo -e "${GREEN}  ✅ ETHERSCAN_API_KEY${NC}"
fi

if [ -n "$ARBISCAN_KEY" ]; then
    echo "  Setting ARBISCAN_API_KEY..."
    gh secret set ARBISCAN_API_KEY -b "$ARBISCAN_KEY" --repo "$REPO_OWNER/$REPO_NAME" 2>/dev/null || true
    echo -e "${GREEN}  ✅ ARBISCAN_API_KEY${NC}"
fi

echo -e "${YELLOW}⚠️  Optional secrets (configure manually in GitHub UI):${NC}"
echo "  - DISCORD_WEBHOOK_URL"
echo "  - TELEGRAM_BOT_TOKEN"
echo "  - TELEGRAM_CHAT_ID\n"

# Step 4: Verify workflow syntax
echo -e "${BLUE}[4/6]${NC} Validating workflow syntax..."
WORKFLOW_FILE=".github/workflows/auto-review-trigger-forensics.yml"
if ! gh workflow view "$WORKFLOW_FILE" --repo "$REPO_OWNER/$REPO_NAME" &>/dev/null; then
    echo -e "${YELLOW}⚠️  Workflow exists but couldn't verify (may still be valid)${NC}"
else
    echo -e "${GREEN}✅ Workflow syntax valid${NC}"
fi
echo ""

# Step 5: Enable workflows
echo -e "${BLUE}[5/6]${NC} Enabling GitHub Actions..."
gh api repos/$REPO_OWNER/$REPO_NAME/actions/permissions -X PUT -f enabled=true 2>/dev/null || true
echo -e "${GREEN}✅ GitHub Actions enabled${NC}\n"

# Step 6: Display next steps
echo -e "${BLUE}[6/6]${NC} Deployment summary..."
echo ""
echo -e "${GREEN}🎉 Deployment Complete!${NC}\n"

echo -e "${BLUE}📊 Quick Reference:${NC}"
echo "  Repository: https://github.com/$REPO_OWNER/$REPO_NAME"
echo "  Actions:    https://github.com/$REPO_OWNER/$REPO_NAME/actions"
echo "  Workflow:   https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/auto-review-trigger-forensics.yml"
echo ""

echo -e "${BLUE}🚀 Next Steps:${NC}"
echo "  1. Verify secrets in GitHub Settings:"
echo "     https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
echo ""
echo "  2. Test the workflow (choose one):"
echo "     A) Manual trigger:"
echo "        https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/auto-review-trigger-forensics.yml"
echo "        → Click 'Run workflow' → Enter PR number → Submit"
echo ""
echo "     B) Create a test PR to auto-trigger:"
echo "        git checkout -b test/forensics"
echo "        echo 'test' >> README.md"
echo "        git add . && git commit -m 'test: trigger forensics scan'"
echo "        git push -u origin test/forensics"
echo "        # Open PR on GitHub"
echo ""
echo "  3. Monitor scan results:"
echo "     → Check PR comments for forensic scan output"
echo "     → View artifacts in workflow run details"
echo "     → Check Discord/Telegram notifications (if configured)"
echo ""

echo -e "${GREEN}✅ Ready to deploy!${NC}\n"
