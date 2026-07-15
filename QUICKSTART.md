# 🚀 Quick Start Guide - Blockchain Forensics Scanner

Get your blockchain forensics scanner running in **5 minutes**.

## ⚡ TL;DR (Ultra-Fast Setup)

```bash
# 1. Get API keys
# - Etherscan: https://etherscan.io/apis
# - Arbiscan: https://arbiscan.io/apis

# 2. Run deployment script
chmod +x deploy-forensics.sh
./deploy-forensics.sh Themoor1 kernel-bindings-tests YOUR_ETHERSCAN_KEY YOUR_ARBISCAN_KEY

# 3. Test the workflow
# Option A: Manual trigger
#   → GitHub UI → Actions → Run workflow → Enter PR #

# Option B: Create test PR
#   git checkout -b test/scan
#   echo "test" >> README.md
#   git add . && git commit -m "test"
#   git push -u origin test/scan
#   → Open PR on GitHub

# Done! 🎉
```

---

## 📋 What You Get

✅ **Automatic blockchain scanning** on every PR  
✅ **Real-time results** posted as PR comments  
✅ **Cross-chain detection** (Ethereum + Arbitrum)  
✅ **Artifact audit trail** (30-day retention)  
✅ **Optional notifications** (Discord/Telegram)  

---

## 🔧 Prerequisites (2 minutes)

### 1. Install GitHub CLI
```bash
# macOS
brew install gh

# Linux
sudo apt-get install gh

# Windows
choco install gh
```

### 2. Authenticate
```bash
gh auth login
# Follow prompts
```

### 3. Get API Keys
- **Etherscan**: Visit https://etherscan.io/apis → Create API Key
- **Arbiscan**: Visit https://arbiscan.io/apis → Create API Key

---

## 🎯 Deployment (2 minutes)

### Step 1: Clone Repo
```bash
cd kernel-bindings-tests
```

### Step 2: Make Deployment Script Executable
```bash
chmod +x deploy-forensics.sh
```

### Step 3: Run Deployment
```bash
./deploy-forensics.sh Themoor1 kernel-bindings-tests sk_your_etherscan_key sk_your_arbiscan_key
```

**Expected output:**
```
==========================================
Blockchain Forensics Scanner Deploy
==========================================

✅ Repository access verified
✅ All required files present
✅ ETHERSCAN_API_KEY
✅ ARBISCAN_API_KEY
✅ GitHub Actions enabled

🎉 Deployment Complete!
```

---

## ✅ Verify Installation (1 minute)

```bash
# Check secrets
gh secret list --repo Themoor1/kernel-bindings-tests

# Expected:
# ETHERSCAN_API_KEY          Updated 2026-07-09
# ARBISCAN_API_KEY           Updated 2026-07-09
```

---

## 🧪 Test (Optional, 2 minutes)

### Quick Test: Manual Trigger
```bash
# Navigate to Actions
https://github.com/Themoor1/kernel-bindings-tests/actions

# Click: "Auto Review Bot Trigger with Blockchain Forensics"
# Click: "Run workflow"
# Enter PR number: 1
# Click: "Run workflow"

# Wait ~30 seconds for results
```

### Full Test: Create PR
```bash
git checkout -b test/forensics
echo "# Test Scan" >> README.md
git add README.md
git commit -m "test: trigger forensics"
git push -u origin test/forensics

# Open PR on GitHub
gh pr create --title "Test: Forensics" --body "Testing blockchain scanner"

# Watch for results:
# 1. PR comment with scan results
# 2. Artifacts in workflow run
```

---

## 📊 View Results

### Check PR Comments
```bash
# Automatically posted by scanner
# Shows: Transactions, anomalies, gas prices, etc.
```

### View Artifacts
```bash
# Download scan results
gh run download <RUN_ID> --dir ./results

# Contents:
# - scan_output.log (full scan output)
# - results/ (detailed findings)
# - forensics.log (debug log)
```

### Monitor Runs
```bash
# List all runs
gh run list --repo Themoor1/kernel-bindings-tests

# Watch specific run
gh run watch <RUN_ID> --repo Themoor1/kernel-bindings-tests
```

---

## 🔔 Optional: Add Notifications

### Discord
```bash
# 1. Create Discord webhook
#    Server Settings → Webhooks → Create Webhook

# 2. Add to GitHub secrets
gh secret set DISCORD_WEBHOOK_URL --repo Themoor1/kernel-bindings-tests
# Paste webhook URL when prompted
```

### Telegram
```bash
# 1. Create bot: Chat with @BotFather on Telegram
# 2. Get chat ID: Send message, visit https://api.telegram.org/bot{TOKEN}/getUpdates

# 3. Add secrets
gh secret set TELEGRAM_BOT_TOKEN --repo Themoor1/kernel-bindings-tests
gh secret set TELEGRAM_CHAT_ID --repo Themoor1/kernel-bindings-tests
```

---

## 🎯 Workflow Triggers

The scanner automatically triggers on:

| Trigger | Example |
|---------|---------|
| **PR Created/Updated** | Open new PR → Scans automatically |
| **PR Review** | Submit review → Triggers scan |
| **Comment** | Comment `@eth-bot rerun` → Re-runs scan |
| **Manual** | Actions UI → Run workflow → Enter PR # |

---

## 📈 What Gets Scanned

For each PR, the scanner:

✅ Checks Ethereum blockchain  
✅ Checks Arbitrum blockchain  
✅ Detects suspicious patterns  
✅ Analyzes transaction flows  
✅ Tracks gas prices  
✅ Identifies cross-chain activity  
✅ Generates audit trail  

---

## 🔧 Troubleshooting

### "Secret not configured" Error
```bash
# Verify secrets
gh secret list --repo Themoor1/kernel-bindings-tests

# Add if missing
gh secret set ETHERSCAN_API_KEY --repo Themoor1/kernel-bindings-tests
```

### "Workflow not running"
```bash
# Check GitHub Actions is enabled
gh api repos/Themoor1/kernel-bindings-tests/actions/permissions

# Enable if needed
gh api repos/Themoor1/kernel-bindings-tests/actions/permissions -X PUT -f enabled=true
```

### "API Rate Limit"
- Wait 1 hour for reset
- Or upgrade API plan on Etherscan/Arbiscan

---

## 📚 Full Documentation

For detailed setup, see: [DEPLOYMENT.md](./DEPLOYMENT.md)

---

## ✨ Key Files

| File | Purpose |
|------|---------|
| `forensics.py` | Main scanning logic |
| `requirements.txt` | Python dependencies |
| `.github/workflows/auto-review-trigger-forensics.yml` | GitHub Actions workflow |
| `deploy-forensics.sh` | Automated deployment script |
| `DEPLOYMENT.md` | Full setup guide |

---

## 🚀 Next Steps

1. ✅ Deploy with `./deploy-forensics.sh`
2. ✅ Test with manual trigger or PR
3. ✅ (Optional) Add Discord/Telegram
4. ✅ Monitor results in PR comments
5. ✅ Review artifacts for detailed findings

---

## 💡 Tips

- **Re-run scan:** Comment `@eth-bot rerun` on any PR
- **Check logs:** View workflow run details for debug info
- **Archive results:** Download artifacts from workflow runs
- **Monitor costs:** API calls use free tier (rate-limited)

---

**🎉 Ready to go! Deploy now:**

```bash
./deploy-forensics.sh Themoor1 kernel-bindings-tests YOUR_KEYS
```
