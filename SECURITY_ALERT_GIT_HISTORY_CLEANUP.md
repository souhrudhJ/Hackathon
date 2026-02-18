# 🚨 CRITICAL SECURITY ALERT: Exposed Sensitive Data in Git History

⚠️ **NOTE**: This document contains the actual exposed API key. This is intentional and necessary for the cleanup process. The key should be revoked immediately as instructed below.

## Overview
**SEVERITY: CRITICAL**  
**ACTION REQUIRED: IMMEDIATE**

Sensitive credentials and personal information were committed to this repository's git history and remain accessible even though the current file contents have been updated.

## What Was Exposed

### 1. Roboflow API Key
- **File**: `train.py`
- **Commit**: `89caef8` (Initial commit, 2026-02-15)
- **Exposed Key**: `XdP8NQpTT2okkMBxTP0r`
- **Risk**: Anyone with access to the repository (or its history) can use this key to access your Roboflow account

### 2. Personal File Path
- **File**: `README.md`
- **Commit**: `89caef8` (Initial commit, 2026-02-15)
- **Exposed Path**: `c:\Users\souhr\Downloads\Hackathon`
- **Risk**: Reveals personal username and system structure

## Why This is Critical

Even though these values were removed in later commits, they remain in the git history. Anyone who:
- Clones the repository
- Has access to any fork
- Downloaded the repository before the fix

...can still access this sensitive information using git commands like:
```bash
git log --all -p -S 'XdP8NQpTT2okkMBxTP0r'
git show 89caef8:train.py
```

## Immediate Actions Required

### Step 1: Revoke the Exposed API Key (DO THIS FIRST)
1. Go to your Roboflow account settings at https://roboflow.com
2. Navigate to API Keys section
3. **Revoke/Delete the exposed key**: `XdP8NQpTT2okkMBxTP0r`
4. Generate a new API key for future use
5. Store the new key securely (use environment variables, never commit it)

### Step 2: Rewrite Git History to Remove Sensitive Data

⚠️ **WARNING**: This will rewrite repository history. All collaborators and forks will need to sync.

Choose ONE of the following methods:

---

#### Option A: Using git-filter-repo (Recommended - Fast & Safe)

**Prerequisites:**
```bash
pip install git-filter-repo
```

**Steps:**

1. **Backup your work** - Create a backup of any uncommitted changes

2. **Clone a fresh copy for safety:**
   ```bash
   cd ~/
   git clone https://github.com/souhrudhJ/Hackathon.git hackathon-clean
   cd hackathon-clean
   ```

3. **Create a file with strings to replace:**
   ```bash
   cat > /tmp/replacements.txt << 'EOF'
   XdP8NQpTT2okkMBxTP0r==>YOUR_API_KEY_HERE
   c:\Users\souhr\Downloads\Hackathon==>./Hackathon
   EOF
   ```

4. **Run git-filter-repo:**
   ```bash
   git filter-repo --replace-text /tmp/replacements.txt --force
   ```

5. **Force push to GitHub:**
   ```bash
   git remote add origin https://github.com/souhrudhJ/Hackathon.git
   git push origin --force --all
   git push origin --force --tags
   ```

---

#### Option B: Using BFG Repo Cleaner (Faster for Large Repos)

**Prerequisites:**
```bash
# Download BFG
wget https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
# OR
curl -o bfg.jar https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
```

**Steps:**

1. **Clone a mirror of the repository:**
   ```bash
   cd ~/
   git clone --mirror https://github.com/souhrudhJ/Hackathon.git hackathon-mirror.git
   ```

2. **Create a file with sensitive strings:**
   ```bash
   cat > /tmp/passwords.txt << 'EOF'
   XdP8NQpTT2okkMBxTP0r
   EOF
   ```

3. **Run BFG to replace sensitive strings:**
   ```bash
   java -jar bfg.jar --replace-text /tmp/passwords.txt hackathon-mirror.git
   ```

4. **Clean up and push:**
   ```bash
   cd hackathon-mirror.git
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```

---

#### Option C: Contact GitHub Support (If Above Options Don't Work)

GitHub provides official support for removing sensitive data:

1. Go to https://support.github.com/
2. Click "Contact GitHub Support"
3. Choose: **Account and Security** → **Sensitive Data Removal**
4. Provide this information:
   - **Repository**: `souhrudhJ/Hackathon`
   - **Commit SHA**: `89caef82309929722e672422c599510ce5f43ed5`
   - **Sensitive data**: API key and personal file path
   - **Files affected**: `train.py`, `README.md`

---

### Step 3: After History Rewrite

1. **Notify all collaborators** that they must re-clone the repository:
   ```bash
   # They should delete their local copy and re-clone
   rm -rf Hackathon
   git clone https://github.com/souhrudhJ/Hackathon.git
   ```

2. **Contact GitHub Support** to purge cached views:
   - GitHub caches repository views that might still show the old commit
   - Email support@github.com with the commit SHA to request cache purge

3. **Check all forks**: Any forks of this repository will still contain the sensitive data
   - Contact fork owners to delete their forks or update from your cleaned repository

4. **Search for leaked data elsewhere**:
   - Check if the API key was used anywhere else
   - Review access logs on Roboflow to see if the key was misused

---

## Verification

After rewriting history, verify the cleanup worked:

```bash
# These should return NO results:
git log --all -p -S 'XdP8NQpTT2okkMBxTP0r'
git log --all -p -S 'c:\\Users\\souhr\\Downloads\\Hackathon'

# Check commit still exists but with cleaned content:
git show 89caef8:train.py | grep -i "api_key"
git show 89caef8:README.md | grep -i "Users"
```

---

## Prevention for the Future

1. **Use environment variables** for sensitive data:
   ```python
   import os
   api_key = os.environ.get('ROBOFLOW_API_KEY')
   if not api_key:
       raise ValueError("ROBOFLOW_API_KEY environment variable not set")
   ```

2. **Never commit** `.env` files containing secrets

3. **Use `.gitignore`** to prevent sensitive files from being committed:
   ```gitignore
   # Sensitive files
   .env
   .env.local
   *.key
   *.pem
   *_secret*
   *_credentials*
   ```

4. **Use pre-commit hooks** to scan for secrets:
   ```bash
   pip install detect-secrets
   detect-secrets scan > .secrets.baseline
   ```

5. **Enable branch protection** on GitHub to require reviews before merging

---

## Timeline

- **2026-02-15**: Initial commit with exposed API key (commit 89caef8)
- **2026-02-18**: Issue discovered and documented
- **ACTION REQUIRED**: Follow steps above immediately

---

## Questions?

If you need help with any of these steps:
1. Check GitHub's official guide: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
2. Contact GitHub Support: https://support.github.com/
3. Review git-filter-repo documentation: https://github.com/newren/git-filter-repo

---

## Legal Notice

This document is provided for security remediation purposes. Unauthorized access or use of the exposed credentials is prohibited and may violate applicable laws.
