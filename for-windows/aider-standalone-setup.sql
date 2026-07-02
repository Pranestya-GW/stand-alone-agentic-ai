-- ============================================================================
-- Aider Standalone Setup Guide (Manual — No Scripts) — WINDOWS NATIVE
-- ============================================================================
-- Sprint 27 — Juli 2026 | Exploration
--
-- Complete guide to install Aider on WINDOWS (PowerShell). NO WSL.
-- Copy-paste each PowerShell block.
--
-- Stack overview:
--   Layer 1: Python via uv       → runtime (no Node.js needed)
--   Layer 2: Aider install       → AI pair programming agent
--   Layer 3: DeepSeek provider   → cheapest model, 500M free tokens
--   Layer 4: Multi-model config  → Claude, GPT, Gemini, Ollama, OpenRouter
--   Layer 5: Git-native workflow → auto-commit, diff, undo
--   Layer 6: Advanced features   → architect mode, voice, lint
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 1809+ / Windows 11
 *   - PowerShell 5.1+ (Run as Administrator untuk install)
 *   - Python 3.9-3.12 (download dari https://python.org)
 *   - Git for Windows (download dari https://git-scm.com)
 *
 * KENAPA AIDER DI WINDOWS?
 *   - Support 100+ models! Paling fleksibel
 *   - Python-based — NO Node.js needed
 *   - Bring your own API key (bayar per use, no subscription)
 *   - Git-native: auto-commit, undo, branching
 */

-- Cek Windows version
-- PS> [System.Environment]::OSVersion.Version

-- Install Git for Windows (kalo belom)
--   Download: https://git-scm.com/download/win

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: PYTHON — Install Python & pip                                   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * 2 cara install Python di Windows:
 *   1. python.org → download installer (RECOMMENDED - paling simpel)
 *   2. winget → winget install Python.Python.3.12
 *
 * PENTING: Centang "Add Python to PATH" pas install!
 */

-- Step 1.1: Install Python 3.12
--   Download: https://www.python.org/downloads/
--   Pilih "Windows installer (64-bit)"
--   CENTANG: "Add python.exe to PATH"
--   CENTANG: "Install pip"
--   Install → NEXT semua
--   TUTUP & BUKA ULANG PowerShell

-- Step 1.2: Verifikasi Python
-- PS> python --version        -- harus 3.12.x
-- PS> pip --version

-- Step 1.3: Kalo pip not found — add Scripts folder to PATH
-- PS> $scriptsPath = "$env:APPDATA\Python\Python312\Scripts"
-- PS> [Environment]::SetEnvironmentVariable("Path", $scriptsPath + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
--   Atau: C:\Python312\Scripts\ (kalo install ke system)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: AIDER — Install AI pair programming agent                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 2.1: Install Aider via pip (RECOMMENDED)
-- PS> python -m pip install --upgrade pip setuptools wheel
-- PS> python -m pip install --upgrade aider-chat

-- Alternatif: One-click PowerShell installer (paling otomatis)
-- PS> powershell -ExecutionPolicy ByPass -c "irm https://aider.chat/install.ps1 | iex"
--   → Auto-install uv + Python 3.12 + Aider dalam satu command

-- Alternatif: pipx (isolated install)
-- PS> python -m pip install pipx
-- PS> pipx install aider-chat

-- Step 2.2: Verifikasi
-- PS> aider --version
--   Kalo ga ketemu: python -m aider --version

-- Step 2.3: PATH fix (kalo aider ga dikenali)
-- PS> [Environment]::SetEnvironmentVariable("Path", "$env:APPDATA\Python\Python312\Scripts" + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
--   TUTUP & BUKA ULANG PowerShell

-- Step 2.4: First run
-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> git init              -- Aider BUTUH git repo
-- PS> aider
--   → Aider scan codebase → build repo map
--   → Interactive prompt: aider >

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Best budget model                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider support DeepSeek NATIVELY. Paling simpel setup-nya!
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 3.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys → Sign up (gratis) → copy key

-- Step 3.2: Set environment variable (permanent)
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-deepseek-key-here", "User")
--   TUTUP & BUKA ULANG PowerShell

-- Step 3.3: Verifikasi
-- PS> echo $env:DEEPSEEK_API_KEY

-- Step 3.4: Cara paling simpel — langsung run pake DeepSeek
-- PS> aider --model deepseek
--   Aider auto-detect API key & config. Ga perlu setup lain.

-- Step 3.5: Tiered models — hemat dengan DeepSeek
-- PS> aider --model deepseek/deepseek-chat --weak-model deepseek/deepseek-v4-flash

-- Step 3.6: Persistent config (biar ga ketik ulang)
--   Bikin file: $env:USERPROFILE\.aider.conf.yml
--   model: deepseek/deepseek-chat
--   weak-model: deepseek/deepseek-v4-flash
--   auto-commits: true

-- Step 3.7: Model lain yang bisa dipake
--   aider --model sonnet                → Claude Sonnet
--   aider --model o3-mini               → OpenAI o3-mini
--   aider --model gemini                → Gemini 2.5 Pro
--   aider --model ollama/qwen3-coder    → Local model (GRATIS!)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: GIT-NATIVE WORKFLOW                                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: In-session commands
--   aider > /add file.sql           → tambah file ke context
--   aider > /read docs.md           → readonly context (hemat token)
--   aider > /drop file.sql          → remove dari context
--   aider > /undo                   → undo last AI edit
--   aider > /diff                   → lihat uncommitted changes
--   aider > /commit                 → manual git commit

-- Step 4.2: /run — execute command dari Aider
--   aider > /run python test.py
--   aider > /run git status

-- Step 4.3: /test — auto-fix failed tests
--   aider > /test pytest
--   → Run tests → fail → Aider auto-fix → loop sampe pass

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: ADVANCED FEATURES                                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Architect mode — plan before edit
-- PS> aider --chat-mode architect
--   aider > "Design indexing strategy for payment views"
--   → Review plan → /chat-mode code → execute

-- Step 5.2: Chat modes
--   /chat-mode code         → edit files (default)
--   /chat-mode architect    → plan only, NO edits
--   /chat-mode ask          → tanya-tanya, hemat token

-- Step 5.3: Config file (~/.aider.conf.yml)
--   model: deepseek/deepseek-chat
--   weak-model: deepseek/deepseek-v4-flash
--   auto-lint: true
--   auto-commits: true
--   dark-mode: true

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Python 3.12             → python --version
-- [ ] pip up-to-date          → pip --version
-- [ ] Aider installed         → aider --version
-- [ ] DeepSeek key            → echo $env:DEEPSEEK_API_KEY
-- [ ] Git repo initialized    → git status (di project)
-- [ ] Config file             → ls $env:USERPROFILE\.aider.conf.yml

-- ============================================================================
-- IN-SESSION COMMANDS
-- ============================================================================

-- /help, /model, /chat-mode, /add, /read, /drop, /undo, /diff, /commit
-- /run, /test, /clear, /tokens, /voice, /map, /web

-- ============================================================================
-- TROUBLESHOOTING (Windows)
-- ============================================================================

-- Problem: python: command not found
-- Fix:     Install Python dari python.org → CENTANG "Add to PATH"
--          Restart PowerShell

-- Problem: pip: command not found
-- Fix:     python -m pip install --upgrade pip
--          ATAU tambah Scripts folder ke PATH

-- Problem: aider: command not found
-- Fix:     python -m aider (alternatif command)
--          ATAU tambah %APPDATA%\Python\Python312\Scripts ke PATH

-- Problem: SSL certificate errors
-- Fix:     pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org aider-chat

-- Problem: scipy installation fails
-- Fix:     pip install scipy==1.11.4

-- Problem: "Git repo required"
-- Fix:     git init && git add -A && git commit -m "initial"

-- Problem: Path too long (260 char limit)
-- Fix:     Enable long paths di Registry (Run as Administrator):
--          reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Aider website:       https://aider.chat
-- Aider install:       https://aider.chat/docs/install.html
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Python download:     https://python.org/downloads
-- Git for Windows:     https://git-scm.com/download/win

-- ============================================================================
-- EOF — Selamat pair programming dengan Aider di Windows! 🐍
-- ============================================================================
