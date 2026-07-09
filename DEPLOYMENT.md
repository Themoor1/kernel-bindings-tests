# 🔍 Blockchain Forensics Scanner - Deployment Guide

Complete guide to deploy the blockchain forensics scanner to your GitHub repository.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Configuration](#configuration)
5. [Testing](#testing)
6. [Monitoring](#monitoring)
7. [Troubleshooting](#troubleshooting)

---

## Overview

The **Blockchain Forensics Scanner** automatically scans Ethereum and Arbitrum blockchains for suspicious activity when triggered by:
- Pull Request events
- Code reviews
- PR comments (`@eth-bot rerun`)
- Manual workflow dispatch

**Features:**
- ✅ Real-time blockchain scanning (Ethereum & Arbitrum)
- ✅ Automatic PR comments with scan results
- ✅ Discord & Telegram notifications
- ✅ Temporal flow analysis (cross-chain activity detection)
- ✅ Gas price tracking
- ✅ Anomaly detection
- ✅ Audit artifacts (30-day retention)

---

## Prerequisites

### Required
- [ ] GitHub CLI (`gh`) installed locally
  ```bash
  # macOS
  brew install gh
  
  # Linux
  sudo apt-get install gh
  
  # Windows
  choco install gh
  ```

- [ ] GitHub Personal Access Token (PAT) with `repo` and `workflow` scopes
  ```bash
  gh auth login
  # Follow prompts to authenticate
  ```

- [ ] Etherscan API Key ([get one](https://etherscan.io/apis))
- [ ] Arbiscan API Key ([get one](https://arbiscan.io/apis))

### Optional
- [ ] Discord Webhook URL (for notifications)
- [ ] Telegram Bot Token & Chat ID (for notifications)

---

## Installation

### Step 1: Clone Your Repository

```bash
git clone https://github.com/Themoor1/kernel-bindings-tests.git
cd kernel-bindings-tests
```

### Step 2: Verify Deployment Files

The following files should already exist:

```bash
# Check required files
ls -la forensics.py
ls -la requirements.txt
ls -la .github/workflows/auto-review-trigger-forensics.yml
ls -la deploy-forensics.sh
```

**Expected structure:**
```
kernel-bindings-tests/
├── forensics.py                    ✅ Main scanner logic
├── requirements.txt                ✅ Python dependencies
├── deploy-forensics.sh             ✅ Deployment script
└── .github/workflows/
    └── auto-review-trigger-forensics.yml  ✅ GitHub Actions workflow
```

### Step 3: Run Deployment Script

```bash
chmod +x deploy-forensics.sh

# Run with API keys
./deploy-forensics.sh Themoor1 kernel-bindings-tests YOUR_ETHERSCAN_KEY YOUR_ARBISCAN_KEY
```

**Example:**
```bash
./deploy-forensics.sh Themoor1 kernel-bindings-tests sk_live_xxx sk_live_yyy
```

**What this does:**
- ✅ Verifies repository access
- ✅ Validates required files
- ✅ Configures API key secrets
- ✅ Enables GitHub Actions
- ✅ Validates workflow syntax

---

## Configuration

### Add Required Secrets

Navigate to your repository: **Settings** → **Secrets and variables** → **Actions**

#### Required Secrets

**1. ETHERSCAN_API_KEY**
- Get from: https://etherscan.io/apis
- Click "Create API Key"
- Copy the key
- Add to GitHub Secrets

```bash
# Or use GitHub CLI
gh secret set ETHERSCAN_API_KEY --repo Themoor1/kernel-bindings-tests
# Paste key when prompted
```

**2. ARBISCAN_API_KEY**
- Get from: https://arbiscan.io/apis
- Click "Create API Key"
- Copy the key
- Add to GitHub Secrets

```bash
gh secret set ARBISCAN_API_KEY --repo Themoor1/kernel-bindings-tests
```

#### Optional Secrets

**Discord Webhook**
- Create a Discord server/channel
- Settings → Webhooks → Create Webhook
- Copy URL

```bash
gh secret set DISCORD_WEBHOOK_URL --repo Themoor1/kernel-bindings-tests
```

**Telegram Notifications**
- Create bot: Chat with [@BotFather](https://t.me/botfather)
- Get bot token
- Get chat ID: Send message to bot, then visit `https://api.telegram.org/bot{TOKEN}/getUpdates`

```bash
gh secret set TELEGRAM_BOT_TOKEN --repo Themoor1/kernel-bindings-tests
gh secret set TELEGRAM_CHAT_ID --repo Themoor1/kernel-bindings-tests
```

### Verify Secrets

```bash
gh secret list --repo Themoor1/kernel-bindings-tests
```

Expected output:
```
ETHERSCAN_API_KEY          Updated 2026-07-09
ARBISCAN_API_KEY           Updated 2026-07-09
DISCORD_WEBHOOK_URL        Updated 2026-07-09 (optional)
TELEGRAM_BOT_TOKEN         Updated 2026-07-09 (optional)
TELEGRAM_CHAT_ID           Updated 2026-07-09 (optional)
```

---

## Testing

### Option 1: Manual Workflow Trigger (Easiest)

1. Go to: https://github.com/Themoor1/kernel-bindings-tests/actions
2. Click **"Auto Review Bot Trigger with Blockchain Forensics"**
3. Click **"Run workflow"** button (top right)
4. Enter a PR number: `1`
5. Click **"Run workflow"**

**Monitor the run:**
```bash
# List recent workflow runs
gh run list --repo Themoor1/kernel-bindings-tests --workflow auto-review-trigger-forensics.yml

# Watch a specific run
gh run watch <RUN_ID> --repo Themoor1/kernel-bindings-tests
```

### Option 2: Create a Test PR

```bash
# Create test branch
git checkout -b test/forensics-scan

# Make a small change
echo "# Forensics Test" >> README.md

# Commit and push
git add README.md
git commit -m "test: trigger forensics scan"
git push -u origin test/forensics-scan

# Open PR on GitHub (or use CLI)
gh pr create --title "Test: Forensics Scan" --body "Testing blockchain forensics scanner"
```

**The workflow will:**
1. ✅ Extract PR number
2. ✅ Run forensics scan
3. ✅ Comment on the PR with results
4. ✅ Upload artifacts
5. ✅ Send notifications (if configured)

### Option 3: Test Locally (Debug)

```bash
# Set environment variables
export ETHERSCAN_API_KEY="your_key_here"
export ARBISCAN_API_KEY="your_key_here"

# Run the scanner
python forensics.py

# Check logs
cat forensics.log
ls -la results/
```

---

## Monitoring

### View Workflow Runs

```bash
# List all runs
gh run list --repo Themoor1/kernel-bindings-tests

# List runs for specific workflow
gh run list --repo Themoor1/kernel-bindings-tests \
  --workflow auto-review-trigger-forensics.yml

# View specific run
gh run view <RUN_ID> --repo Themoor1/kernel-bindings-tests
```

### Check PR Comments

The scanner automatically comments on PRs with results:

```bash
# View PR comments
gh pr view <PR_NUMBER> --comments --repo Themoor1/kernel-bindings-tests
```

### Download Artifacts

```bash
# List artifacts from a run
gh run view <RUN_ID> --repo Themoor1/kernel-bindings-tests --json artifacts

# Download artifacts
gh run download <RUN_ID> \
  --repo Themoor1/kernel-bindings-tests \
  --dir ./forensics-results
```

### Monitor Logs

```bash
# View job logs
gh run view <RUN_ID> \
  --repo Themoor1/kernel-bindings-tests \
  --log

# View specific job
gh run view <RUN_ID> \
  --repo Themoor1/kernel-bindings-tests \
  --job <JOB_ID> \
  --log
```

---

## Troubleshooting

### Issue: "Missing API keys" Error

**Symptom:**
```
❌ Error: ETHERSCAN_API_KEY is not configured
```

**Solution:**
```bash
# Verify secrets are set
gh secret list --repo Themoor1/kernel-bindings-tests

# If missing, add them
gh secret set ETHERSCAN_API_KEY --repo Themoor1/kernel-bindings-tests

# Verify secret value (first 10 chars only)
gh secret list --repo Themoor1/kernel-bindings-tests | grep ETHERSCAN
```

### Issue: "Workflow not found" Error

**Symptom:**
```
workflow not found
```

**Solution:**
```bash
# Verify workflow file exists
gh workflow view auto-review-trigger-forensics.yml \
  --repo Themoor1/kernel-bindings-tests

# If missing, reupload
git add .github/workflows/auto-review-trigger-forensics.yml
git commit -m "fix: restore workflow"
git push
```

### Issue: "API Rate Limit Exceeded"

**Symptom:**
```
Too many requests error from Etherscan
```

**Solution:**
```bash
# Wait 1 hour for rate limit reset
# Or upgrade Etherscan API plan
# https://etherscan.io/apis
```

### Issue: "Python Dependencies Not Found"

**Symptom:**
```
ModuleNotFoundError: No module named 'requests'
```

**Solution:**
- Verify `requirements.txt` exists in repo root
- Check workflow installs dependencies:
  ```yaml
  - name: Install dependencies
    run: pip install -r requirements.txt
  ```

### Issue: "No Scan Results" in PR Comment

**Symptom:**
- PR comment shows "No scan results available"

**Solution:**
1. Check if secrets are configured
2. Verify API keys are valid
3. View full workflow logs:
   ```bash
   gh run view <RUN_ID> --repo Themoor1/kernel-bindings-tests --log
   ```
4. Check results artifacts:
   ```bash
   gh run download <RUN_ID> --repo Themoor1/kernel-bindings-tests --dir results
   ```

### Debug Mode

Enable detailed logging:

```bash
# Add to workflow manually (if needed):
env:
  DEBUG: "true"
```

Then view logs:
```bash
gh run view <RUN_ID> --repo Themoor1/kernel-bindings-tests --log
```

---

## Maintenance

### Update API Keys (Quarterly Recommended)

```bash
# Update Etherscan key
gh secret set ETHERSCAN_API_KEY --repo Themoor1/kernel-bindings-tests

# Update Arbiscan key
gh secret set ARBISCAN_API_KEY --repo Themoor1/kernel-bindings-tests
```

### Update Dependencies

```bash
# Check for updates
pip list --outdated

# Update requirements.txt with latest versions
pip freeze > requirements.txt

# Commit changes
git add requirements.txt
git commit -m "chore: update dependencies"
git push
```

### View Audit Trail

```bash
# List all workflow runs (last 10 days)
gh run list --repo Themoor1/kernel-bindings-tests --created ">2026-06-29"

# Export as JSON for archival
gh run list --repo Themoor1/kernel-bindings-tests --json \
  runNumber,status,startedAt,conclusion > audit_trail.json
```

---

## Support

### Get Help

1. **Check workflow logs:**
   ```bash
   gh run view <RUN_ID> --repo Themoor1/kernel-bindings-tests --log
   ```

2. **View recent activity:**
   ```bash
   gh activity log --repo Themoor1/kernel-bindings-tests
   ```

3. **Report issues:**
   - Create GitHub Issue
   - Include: Error message, Run ID, Workflow logs

### Resources

- [Etherscan API Docs](https://docs.etherscan.io/)
- [Arbiscan API Docs](https://docs.arbiscan.io/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [GitHub Secrets Docs](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `./deploy-forensics.sh Themoor1 kernel-bindings-tests KEY1 KEY2` | Deploy scanner |
| `gh secret list --repo Themoor1/kernel-bindings-tests` | View configured secrets |
| `gh run list --repo Themoor1/kernel-bindings-tests` | List workflow runs |
| `gh run view <ID> --repo Themoor1/kernel-bindings-tests --log` | View run logs |
| `gh run download <ID> --repo Themoor1/kernel-bindings-tests --dir results` | Download artifacts |

---

**✅ Deployment Complete!** 🚀

Your blockchain forensics scanner is now ready to automatically scan blockchain activity on every PR.
