@echo off
REM Quick Script to Remove Sensitive Data from Git History (Windows Version)
REM Repository: souhrudhJ/Hackathon
REM 
REM WARNING: This script will rewrite git history!
REM WARNING: All collaborators must re-clone after running this
REM
REM Prerequisites:
REM   - pip install git-filter-repo
REM   - Backup any uncommitted work
REM   - Close any open issues/PRs (they may break)
REM
REM Usage:
REM   cleanup_git_history.bat

setlocal enabledelayedexpansion

echo =========================================
echo Git History Cleanup Script (Windows)
echo =========================================
echo.
echo This script will:
echo   1. Remove exposed API key from git history
echo   2. Remove personal file path from git history
echo   3. Force push cleaned history to origin
echo.
echo WARNING: This rewrites git history!
echo WARNING: All collaborators must re-clone the repository after this
echo.

REM Confirm with user
set /p confirm="Have you read SECURITY_ALERT_GIT_HISTORY_CLEANUP.md? (yes/no): "
if not "%confirm%"=="yes" (
    echo Please read SECURITY_ALERT_GIT_HISTORY_CLEANUP.md first!
    exit /b 1
)

set /p key_revoked="Have you revoked the exposed API key on Roboflow? (yes/no): "
if not "%key_revoked%"=="yes" (
    echo WARNING: STOP! Revoke the API key first:
    echo    Go to https://roboflow.com and revoke key: XdP8NQpTT2okkMBxTP0r
    exit /b 1
)

set /p backed_up="Have you backed up any uncommitted work? (yes/no): "
if not "%backed_up%"=="yes" (
    echo Please backup your work first!
    exit /b 1
)

set /p final_confirm="Type 'REWRITE HISTORY' to continue: "
if not "%final_confirm%"=="REWRITE HISTORY" (
    echo Aborted.
    exit /b 1
)

echo.
echo Starting cleanup...
echo.

REM Check if git-filter-repo is installed
git-filter-repo --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: git-filter-repo not found!
    echo Install it with: pip install git-filter-repo
    exit /b 1
)

REM Create replacement file
echo Creating replacement rules...
(
echo XdP8NQpTT2okkMBxTP0r==^>YOUR_API_KEY_HERE
echo c:\Users\souhr\Downloads\Hackathon==^>./Hackathon
) > %TEMP%\git_history_replacements.txt

echo Done: Replacement rules created
echo.

REM Get current branch name
for /f "tokens=*" %%i in ('git branch --show-current') do set current_branch=%%i
echo Current branch: %current_branch%

REM Backup remote URL
for /f "tokens=*" %%i in ('git remote get-url origin') do set remote_url=%%i
echo Remote URL: %remote_url%

REM Run git-filter-repo
echo.
echo Running git-filter-repo...
echo This may take a moment...
git-filter-repo --replace-text %TEMP%\git_history_replacements.txt --force
if errorlevel 1 (
    echo ERROR: git-filter-repo failed!
    exit /b 1
)

echo Done: History rewritten locally
echo.

REM Re-add remote
echo Re-adding remote...
git remote add origin %remote_url%

REM Push rewritten history
echo.
echo Force pushing to origin...
echo WARNING: This will rewrite the remote repository!
pause

git push origin --force --all
if errorlevel 1 (
    echo ERROR: Failed to push!
    exit /b 1
)

REM Push tags if any
git tag >nul 2>&1
if not errorlevel 1 (
    echo Pushing tags...
    git push origin --force --tags
)

echo.
echo =========================================
echo Cleanup complete!
echo =========================================
echo.
echo Next steps:
echo   1. Verify cleanup worked:
echo      git log --all -p -S "XdP8NQpTT2okkMBxTP0r"
echo      (should return nothing^)
echo.
echo   2. Notify all collaborators to re-clone:
echo      git clone %remote_url%
echo.
echo   3. Contact GitHub Support to purge cache:
echo      https://support.github.com/
echo.
echo   4. Check if any forks exist and notify owners
echo.

REM Cleanup temp file
del /q %TEMP%\git_history_replacements.txt

echo Done!
pause
