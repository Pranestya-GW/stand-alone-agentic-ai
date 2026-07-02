-- ============================================================================
-- pi.dev Standalone Setup Guide — WINDOWS (PowerShell)
-- ============================================================================
--
-- Complete step-by-step guide to install pi.dev on WINDOWS using PowerShell.
-- NO WSL needed — native Windows. Copy-paste each PowerShell block.
--
-- Stack: pi.dev → pi-setup → DeepSeek → 4 plugins → grilling skill
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 1809+ / Windows 11
 *   - PowerShell 5.1+ (built-in)
 *   - Git for Windows (https://git-scm.com/download/win)
 *     Check: "Git from the command line and also from 3rd-party software"
 */

-- Check Windows version: PS> winver
-- Check RAM: PS> Get-CimInstance Win32_ComputerSystem | Select TotalPhysicalMemory

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS via nvm-windows                                        ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 1.1: Install nvm-windows
--   Download: https://github.com/coreybutler/nvm-windows/releases → nvm-setup.exe
--   CLOSE & REOPEN PowerShell after install

-- Step 1.2: Install Node.js 22
-- PS> nvm install 22
-- PS> nvm use 22

-- Step 1.3: Fix npm permissions
-- PS> mkdir $env:USERPROFILE\.npm-global
-- PS> npm config set prefix "$env:USERPROFILE\.npm-global"
-- PS> [Environment]::SetEnvironmentVariable("Path", "$env:USERPROFILE\.npm-global;" + $env:USERPROFILE\AppData\Roaming\npm;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

-- Step 1.4: Verify → node --version, npm --version

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: PI.DEV BINARY                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 2.1: Install pi.dev
-- PS> npm install -g @earendil-works/pi-coding-agent

-- Step 2.2: Verify → pi --version
-- Step 2.3: Test → pi "Hello, what can you do?"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: PI-SETUP                                                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: Clone pi-setup
-- PS> git clone https://github.com/abhinand5/pi-setup.git $env:USERPROFILE\pi-setup

-- Step 3.2: Install (open Git Bash from Start Menu)
--   cd ~/pi-setup && ./install.sh --restore --copy-config

-- Step 3.3: Fix pi binary path
-- PS> [Environment]::SetEnvironmentVariable("PI_REAL_BIN", "$env:USERPROFILE\AppData\Roaming\npm\pi.cmd", "User")

-- Step 3.4: Available commands: /filechanges, /safety, /context, /local-models, /theme

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: DEEPSEEK PROVIDER                                              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 4.1: Set permanent environment variable
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-key", "User")
--   CLOSE & REOPEN PowerShell

-- Step 4.2: Verify
-- PS> $headers = @{ Authorization = "Bearer $env:DEEPSEEK_API_KEY" }
-- PS> Invoke-RestMethod -Uri "https://api.deepseek.com/v1/models" -Headers $headers

-- Step 4.3: Use DeepSeek
-- PS> pi --model deepseek-v4-flash "Explain this codebase"
--   Or mid-session: /model deepseek-v4-flash

-- DeepSeek models: deepseek-v4-flash ($0.14/$0.28), deepseek-chat-v3 ($0.27/$1.10)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGINS                                                        ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- PS> pi install npm:context-mode
-- PS> pi install npm:pi-deepseek-search
-- PS> pi install npm:pi-codex-goal
-- PS> pi install npm:@juicesharp/rpiv-ask-user-question

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: GRILLING SKILL                                                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- PS> npx skills add https://github.com/mattpocock/skills --skill grilling

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Git for Windows  → git --version
-- [ ] nvm-windows      → nvm version
-- [ ] Node.js 22       → node --version
-- [ ] pi.dev           → pi --version
-- [ ] pi-setup         → ls $env:USERPROFILE\pi-setup
-- [ ] DeepSeek key     → echo $env:DEEPSEEK_API_KEY

-- ============================================================================
-- DAILY WORKFLOW
-- ============================================================================

-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> pi
-- /context-mode smart
-- "Explain the database structure"
-- "Find all SELECT * queries and replace them"

-- ============================================================================
-- TROUBLESHOOTING (Windows-specific)
-- ============================================================================

-- Problem: pi: command not found
-- Fix:     $npmPath = npm root -g; [Environment]::SetEnvironmentVariable("Path", $npmPath + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

-- Problem: Execution policy blocks script
-- Fix:     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

-- Problem: install.sh doesn't run
-- Fix:     Open Git Bash from Start Menu, cd ~/pi-setup && ./install.sh --restore

-- Problem: Path too long (260 char limit)
-- Fix:     reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f  (as Admin)

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- pi.dev: https://pi.dev  |  pi-setup: https://github.com/abhinand5/pi-setup
-- DeepSeek: https://platform.deepseek.com/api_keys  |  nvm-windows: github.com/coreybutler/nvm-windows

-- ============================================================================
-- EOF — Happy coding with Pi on Windows! 🚀
-- ============================================================================
