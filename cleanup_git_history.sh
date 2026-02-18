#!/bin/bash
#
# Quick Script to Remove Sensitive Data from Git History
# Repository: souhrudhJ/Hackathon
# 
# ⚠️  NOTE: This script contains the exposed API key for cleanup purposes
# ⚠️  WARNING: This script will rewrite git history!
# ⚠️  All collaborators must re-clone after running this
#
# Prerequisites:
#   - pip install git-filter-repo
#   - Backup any uncommitted work
#   - Close any open issues/PRs (they may break)
#
# Usage:
#   chmod +x cleanup_git_history.sh
#   ./cleanup_git_history.sh
#

set -e  # Exit on error

echo "========================================="
echo "Git History Cleanup Script"
echo "========================================="
echo ""
echo "This script will:"
echo "  1. Remove exposed API key from git history"
echo "  2. Remove personal file path from git history"
echo "  3. Force push cleaned history to origin"
echo ""
echo "⚠️  WARNING: This rewrites git history!"
echo "⚠️  All collaborators must re-clone the repository after this"
echo ""

# Confirm with user
read -p "Have you read SECURITY_ALERT_GIT_HISTORY_CLEANUP.md? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Please read SECURITY_ALERT_GIT_HISTORY_CLEANUP.md first!"
    exit 1
fi

read -p "Have you revoked the exposed API key on Roboflow? (yes/no): " key_revoked
if [ "$key_revoked" != "yes" ]; then
    echo "⚠️  STOP! Revoke the API key first:"
    echo "   Go to https://roboflow.com and revoke key: XdP8NQpTT2okkMBxTP0r"
    exit 1
fi

read -p "Have you backed up any uncommitted work? (yes/no): " backed_up
if [ "$backed_up" != "yes" ]; then
    echo "Please backup your work first!"
    exit 1
fi

read -p "Type 'REWRITE HISTORY' to continue: " final_confirm
if [ "$final_confirm" != "REWRITE HISTORY" ]; then
    echo "Aborted."
    exit 1
fi

echo ""
echo "Starting cleanup..."
echo ""

# Check if git-filter-repo is installed
if ! command -v git-filter-repo &> /dev/null; then
    echo "❌ git-filter-repo not found!"
    echo "Install it with: pip install git-filter-repo"
    exit 1
fi

# Create replacement file
echo "Creating replacement rules..."
cat > /tmp/git_history_replacements.txt << 'EOF'
XdP8NQpTT2okkMBxTP0r==>YOUR_API_KEY_HERE
c:\Users\souhr\Downloads\Hackathon==>./Hackathon
EOF

echo "✓ Replacement rules created"

# Get current branch name
current_branch=$(git branch --show-current)
echo "Current branch: $current_branch"

# Backup remote URL (git-filter-repo removes it)
remote_url=$(git remote get-url origin)
echo "Remote URL: $remote_url"

# Run git-filter-repo
echo ""
echo "Running git-filter-repo..."
echo "This may take a moment..."
git-filter-repo --replace-text /tmp/git_history_replacements.txt --force

echo "✓ History rewritten locally"

# Re-add remote (git-filter-repo removes it)
echo "Re-adding remote..."
git remote add origin "$remote_url"

# Push rewritten history
echo ""
echo "Force pushing to origin..."
echo "⚠️  This will rewrite the remote repository!"
read -p "Press ENTER to continue or Ctrl+C to abort..."

git push origin --force --all

# Push tags if any
if git tag | grep -q .; then
    echo "Pushing tags..."
    git push origin --force --tags
fi

echo ""
echo "========================================="
echo "✓ Cleanup complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Verify cleanup worked:"
echo "     git log --all -p -S 'XdP8NQpTT2okkMBxTP0r'"
echo "     (should return nothing)"
echo ""
echo "  2. Notify all collaborators to re-clone:"
echo "     rm -rf Hackathon && git clone $remote_url"
echo ""
echo "  3. Contact GitHub Support to purge cache:"
echo "     https://support.github.com/"
echo ""
echo "  4. Check if any forks exist and notify owners"
echo ""

# Cleanup temp file
rm -f /tmp/git_history_replacements.txt

echo "Done!"
