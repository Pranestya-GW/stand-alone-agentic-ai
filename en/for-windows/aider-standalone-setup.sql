-- ============================================================================
-- Aider Standalone Setup Guide — WINDOWS (PowerShell)
-- ============================================================================
--
-- Complete guide to install Aider on WINDOWS. NO WSL needed.
-- Python-based — NO Node.js required. Supports 100+ models.
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements: Windows 10 1809+ / 11, Python 3.9-3.12, Git for Windows
 *
 * Docs: https://aider.chat/docs/install.html
 */

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: PYTHON                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 1.1: Install Python 3.12
--   Download: https://www.python.org/downloads/ → Windows installer (64-bit)
--   CHECK: "Add python.exe to PATH" & "Install pip"
--   CLOSE & REOPEN PowerShell

-- Step 1.2: Verify → PS> python --version && pip --version

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: AIDER INSTALL                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 2.1: Install Aider (RECOMMENDED)
-- PS> python -m pip install --upgrade pip setuptools wheel
-- PS> python -m pip install --upgrade aider-chat

-- Alternative: One-click installer
-- PS> powershell -ExecutionPolicy ByPass -c "irm https://aider.chat/install.ps1 | iex"

-- Step 2.2: PATH fix (if aider not recognized)
-- PS> [Environment]::SetEnvironmentVariable("Path", "$env:APPDATA\Python\Python312\Scripts;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

-- Step 2.3: Verify → PS> aider --version (or python -m aider --version)

-- Step 2.4: First run
-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> git init && aider

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — NATIVE support in Aider!                   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 3.1: Set permanent env var
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-key", "User")
--   CLOSE & REOPEN PowerShell

-- Step 3.2: Simplest usage — just run with DeepSeek
-- PS> aider --model deepseek
--   Aider auto-detects API key. No other setup needed!

-- Step 3.3: Tiered models (cheap + powerful)
-- PS> aider --model deepseek/deepseek-chat --weak-model deepseek/deepseek-v4-flash

-- Step 3.4: Persistent config → %USERPROFILE%\.aider.conf.yml
--   model: deepseek/deepseek-chat
--   weak-model: deepseek/deepseek-v4-flash
--   auto-commits: true

-- Step 3.5: Other models — aider --model sonnet / o3-mini / gemini / ollama/qwen3-coder

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: GIT WORKFLOW + ADVANCED                                        ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- In-session commands: /add, /read, /drop, /undo, /diff, /commit, /run, /test
-- Architect mode: aider --chat-mode architect (plan before edit)
-- Chat modes: /chat-mode code | architect | ask

-- ============================================================================
-- TROUBLESHOOTING (Windows)
-- ============================================================================

-- Problem: python not found → Reinstall Python, check "Add to PATH"
-- Problem: pip not found → python -m pip install --upgrade pip
-- Problem: aider not found → python -m aider (alternative) or add Scripts to PATH
-- Problem: SSL errors → pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org aider-chat
-- Problem: scipy fails → pip install scipy==1.11.4
-- Problem: Path too long → reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f (as Admin)

-- ============================================================================
-- COST COMPARISON — Per 1M tokens
-- ============================================================================

-- deepseek-v4-flash: $0.14/$0.28 (RECOMMENDED) | GPT-4o: $2.50/$10 | Claude Sonnet 4: $3/$15
-- Gemini Flash: FREE* | Ollama (local): $0 (*free tier limits apply)

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Aider: https://aider.chat  |  Python: https://python.org/downloads
-- DeepSeek: https://platform.deepseek.com/api_keys  |  Ollama: https://ollama.com

-- ============================================================================
-- EOF — Happy pair programming with Aider on Windows! 🐍
-- ============================================================================
