-- ============================================================================
-- Codex CLI Standalone Setup Guide (Manual — No Scripts) — WINDOWS NATIVE
-- ============================================================================
--
-- Complete guide to install OpenAI Codex CLI on WINDOWS (PowerShell).
-- NO WSL needed — native Windows. Copy-paste each PowerShell block.
--
-- Stack overview:
--   Layer 1: Codex CLI binary    → the agent (standalone, no Node.js)
--   Layer 2: DeepSeek provider   → alternative cheap model
--   Layer 3: Sandbox modes       → safety: elevated vs unelevated
--   Layer 4: CI/CD integration   → `codex exec` for automation
--   Layer 5: Skills + MCP        → pre-built behaviors & tools
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 1809+ / Windows 11
 *   - PowerShell 5.1+
 *   - Git for Windows (download dari https://git-scm.com)
 *   - OpenAI account: Plus ($20/mo), Pro, Team, Edu, Enterprise
 *     ATAU OpenAI API key
 *
 * KENAPA CODEX CLI DI WINDOWS?
 *   - Native support sejak 2026 — NO WSL, NO Node.js
 *   - `codex.exe` standalone binary
 *   - Bisa pake DeepSeek sebagai provider alternatif
 *   - Desktop app juga tersedia via Microsoft Store
 */

-- Cek Windows version
-- PS> [System.Environment]::OSVersion.Version

-- Cek RAM — minimal 4GB
-- PS> Get-CimInstance Win32_ComputerSystem | Select TotalPhysicalMemory

-- Install Git for Windows kalo belum ada
--   Download: https://git-scm.com/download/win

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CODEX CLI — Native Windows installer                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI on Windows: 3 cara install.
 * Official installer (recommended) = paling simpel.
 *
 * Docs:    https://github.com/openai/codex
 * Latest:  v0.142.3
 */

-- Step 1.1: Install via PowerShell (RECOMMENDED)
-- PS> powershell -ExecutionPolicy ByPass -c "irm https://chatgpt.com/codex/install.ps1 | iex"

-- Alternatif: npm (butuh Node.js 20+)
-- PS> nvm install 22
-- PS> nvm use 22
-- PS> npm install -g @openai/codex

-- Alternatif: winget (desktop app + CLI)
-- PS> winget install OpenAI.Codex

-- Alternatif: Manual binary download
--   Buka: https://github.com/openai/codex/releases
--   Download: codex-x86_64-pc-windows-msvc.exe
--   Rename → codex.exe → taruh di folder yang ada di PATH

-- Step 1.2: Verifikasi instalasi
-- PS> codex --version
--   Expected: codex-cli 0.142.x

-- Step 1.3: Authentication (first launch)
-- PS> codex
--   → Pilih "Sign in with ChatGPT" (browser OAuth)
--   ATAU:
-- PS> $env:OPENAI_API_KEY = "sk-your-openai-key"
-- PS> codex login --with-api-key

-- Step 1.4: Basic commands
-- PS> codex                                    -- interactive TUI
-- PS> codex "explain this codebase"            -- langsung prompt
-- PS> codex exec "fix the error"               -- headless/CI
-- PS> codex --model gpt-4o "refactor this"     -- pakai model spesifik

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Alternative cheap model                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI pake OpenAI models by default. TAPI support OpenAI-compatible
 * providers — termasuk DeepSeek! Tinggal set environment variable.
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys → Sign up (gratis) → copy key

-- Step 2.2: Set environment variables (permanent)
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-your-deepseek-key-here", "User")
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_BASE", "https://api.deepseek.com/v1", "User")
--   TUTUP & BUKA ULANG PowerShell

-- Step 2.3: Verifikasi key
-- PS> $headers = @{ Authorization = "Bearer $env:OPENAI_API_KEY" }
-- PS> Invoke-RestMethod -Uri "https://api.deepseek.com/v1/models" -Headers $headers

-- Step 2.4: Cara pakai DeepSeek
-- PS> codex --model deepseek-chat "Jelaskan codebase ini"
-- PS> codex --model deepseek-v4-flash "Refactor query ini"
--
--   Atau mid-session:
--   /model deepseek-chat

-- Step 2.5: Balik ke OpenAI models
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_BASE", "", "User")
--   ATAU set ke OpenAI key langsung

-- Step 2.6: Model DeepSeek
--   deepseek-chat (v3)       → reasoning bagus          ($0.27/$1.10)
--   deepseek-v4-flash        → murah & cepat              ($0.14/$0.28)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: SANDBOX MODES — Safety first                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: Cek sandbox mode
-- PS> codex --sandbox status

-- Step 3.2: Set sandbox mode
-- PS> codex --sandbox unelevated    → tanya dulu sebelum execute (RECOMMENDED)
-- PS> codex --sandbox elevated      → auto-approve semua (HATI-HATI!)
-- PS> codex --sandbox safe          → readonly, ga bisa edit

-- Step 3.3: Note on Windows sandbox
--   Elevated sandbox butuh Administrator privileges di Windows.
--   Kalo company policy block elevated → otomatis fallback ke unelevated.

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: CI/CD & CODEX.MD                                              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: `codex exec` — headless mode
-- PS> codex exec "Fix all errors in src/"
-- PS> codex exec --approve "Run migration and verify"

-- Step 4.2: GitHub Actions with Codex (Windows runner)
--   - uses: actions/checkout@v4
--   - run: powershell -ExecutionPolicy ByPass -c "irm https://chatgpt.com/codex/install.ps1 | iex"
--   - run: codex exec --approve "Review PR for bugs"
--     env:
--       OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

-- Step 4.3: CODEX.md — project context
-- PS> cd ~/Desktop/SQL-QUERY-JOB
-- PS> codex
--   → /init (generate CODEX.md otomatis)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS + MCP                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install skills
-- PS> npx skills add https://github.com/mattpocock/skills --skill grilling
-- PS> npx skills add https://github.com/mattpocock/skills --skill diagnose
-- PS> npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 5.2: MCP config — $env:USERPROFILE\.codex\mcp.json
--   Sama seperti di guide Linux, tapi path pakai \\ (double backslash)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Codex CLI binary        → codex --version
-- [ ] Authenticated           → codex (harus login)
-- [ ] DeepSeek key            → echo $env:OPENAI_API_KEY
-- [ ] Sandbox mode            → codex --sandbox status

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /sandbox, /clear, /context, /cost, /diff, /undo, /init

-- ============================================================================
-- TROUBLESHOOTING (Windows)
-- ============================================================================

-- Problem: Execution policy blocks install
-- Fix:     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

-- Problem: codex: command not found
-- Fix:     Cek PATH — tambahin folder instalasi codex
--          ATAU install ulang pake installer resmi

-- Problem: Authentication loop
-- Fix:     Remove-Item -Recurse -Force $env:USERPROFILE\.codex\auth.json
--          codex (login ulang)

-- Problem: Sandbox elevated needs admin
-- Fix:     Run PowerShell as Administrator
--          ATAU pake unelevated mode (more prompts, safer)

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Codex CLI GitHub:    https://github.com/openai/codex
-- Codex releases:      https://github.com/openai/codex/releases
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Selamat ngoding dengan Codex CLI di Windows! 🚀
-- ============================================================================
