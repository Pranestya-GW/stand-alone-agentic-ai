-- ============================================================================
-- Gemini CLI Standalone Setup Guide (Manual — No Scripts) — WINDOWS NATIVE
-- ============================================================================
--
-- Complete guide to install Gemini CLI on WINDOWS (PowerShell). NO WSL.
-- Each section is an SQL comment block. Copy-paste each PowerShell block.
--
-- Stack overview:
--   Layer 1: Node.js + Gemini CLI  → the agent itself (free tier!)
--   Layer 2: DeepSeek provider     → alternative cheap model
--   Layer 3: GEMINI.md             → project context & conventions
--   Layer 4: MCP servers           → extend with external tools
--   Layer 5: Themes + settings     → custom TUI look
--   Layer 6: Skills                → pre-built agent behaviors
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 1809+ / Windows 11
 *   - PowerShell 5.1+
 *   - Node.js 20+ (download dari https://nodejs.org → pilih LTS)
 *   - Google Account (GRATIS — free tier: 60 req/min, 1000 req/day)
 *
 * KENAPA GEMINI CLI?
 *   - FREE TIER! Ga perlu bayar buat mulai
 *   - 1M token context window — salah satu yang paling gede
 *   - Built-in Google Search grounding (cek fakta live)
 *   - Native Windows support via npm
 */

-- Cek Windows version
-- PS> [System.Environment]::OSVersion.Version

-- Cek RAM — minimal 4GB
-- PS> Get-CimInstance Win32_ComputerSystem | Select TotalPhysicalMemory

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS + GEMINI CLI — Install binary                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI butuh Node.js 20+. Bisa install via:
 *   1. nodejs.org → download LTS installer (RECOMMENDED)
 *   2. nvm-windows → buat ganti-ganti versi Node.js
 *   3. winget → winget install OpenJS.NodeJS.LTS
 */

-- Step 1.1: Install Node.js (kalo belom)
--   Download & install dari https://nodejs.org (pilih LTS 22.x)
--   PENTING: Centang "Automatically install the necessary tools"
--   PASTIKAN "Add to PATH" dicentang

-- Step 1.2: Verifikasi Node.js
-- PS> node --version
-- PS> npm --version

-- Step 1.3: Install Gemini CLI
-- PS> npm install -g @google/gemini-cli

-- Alternatif: Preview/nightly channels
-- PS> npm install -g @google/gemini-cli@preview
-- PS> npm install -g @google/gemini-cli@nightly

-- Step 1.4: Verifikasi
-- PS> gemini --version

-- Step 1.5: Fix "gemini: command not found"
--   Tambah ke PATH: %APPDATA%\npm
--   Buka Environment Variables → User Path → tambah:
--   %USERPROFILE%\AppData\Roaming\npm
--   TUTUP & BUKA ULANG PowerShell

-- Step 1.6: Launch Gemini CLI (first run — OAuth)
-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> gemini
--   → Pilih "Login with Google" (browser OAuth — GRATIS)
--   → ATAU pake API key (lihat Step 2.3)

-- Step 1.7: Basic commands
-- PS> gemini                                          -- interactive TUI
-- PS> gemini -p "Explain this codebase"               -- one-shot
-- PS> gemini -m "gemini-2.5-flash" "Refactor this"    -- pakai model
-- PS> gemini -y "Run all tests"                       -- auto-approve

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Alternative cheap model                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI native-nya pake Google models (GRATIS).
 * TAPI bisa tambahin DeepSeek sebagai OpenAI-compatible provider.
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys → Sign up → copy key

-- Step 2.2: Set environment variables (permanent)
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-deepseek-key-here", "User")
--   TUTUP & BUKA ULANG PowerShell

-- Step 2.3: (Opsional) Set Google API key kalo mau pake Gemini via API key
--   Buka: https://aistudio.google.com/ → Get API Key
-- PS> [Environment]::SetEnvironmentVariable("GEMINI_API_KEY", "your-google-api-key", "User")

-- Step 2.4: Setup DeepSeek di Gemini CLI settings
--   Edit: $env:USERPROFILE\.gemini\settings.json
--   {
--     "models": {
--       "providers": {
--         "deepseek": {
--           "baseUrl": "https://api.deepseek.com/v1",
--           "apiKey": "env:DEEPSEEK_API_KEY",
--           "models": ["deepseek-chat", "deepseek-v4-flash"]
--         }
--       }
--     }
--   }

-- Step 2.5: Model bawaan Google (free tier — TANPA BIAYA)
--   gemini-2.5-flash         → cepat, general purpose            (FREE)
--   gemini-2.5-pro           → reasoning + tools terbaik         (FREE)
--   auto                     → auto-select best model            (DEFAULT)

-- Step 2.6: Model DeepSeek
--   deepseek-chat (v3)       → task kompleks                     ($0.27/$1.10)
--   deepseek-v4-flash        → daily use, murah                  ($0.14/$0.28)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: GEMINI.MD — Project context                                   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: Buat GEMINI.md di project root
--   Edit: C:\Users\RYZEN\Desktop\SQL-QUERY-JOB\GEMINI.md
--
--   # SQL-QUERY-JOB Conventions
--   ## Tech Stack
--   - PostgreSQL 16, PL/pgSQL
--   ## Rules
--   - SQL keywords UPPERCASE
--   - NEVER SELECT *
--   - EXPLAIN ANALYZE before every new query

-- Step 3.2: Gemini auto-reads GEMINI.md setiap session

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: MCP SERVERS                                                   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: MCP config — $env:USERPROFILE\.gemini\mcp.json
--   {
--     "mcpServers": {
--       "grep": {
--         "command": "npx",
--         "args": ["-y", "@anthropic/mcp-server-grep"]
--       },
--       "git": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-git"]
--       }
--     }
--   }

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: THEMES + SETTINGS                                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Settings file — $env:USERPROFILE\.gemini\settings.json
--   {
--     "ui": { "theme": "tokyo-night" },
--     "security": { "autoApprove": false },
--     "model": { "default": "gemini-2.5-flash" }
--   }

-- Step 5.2: Commands
--   /theme    → ganti tema TUI
--   /settings → buka settings.json
--   /stats    → usage stats
--   /clear    → reset conversation

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: SKILLS                                                        ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Install skills
-- PS> npx skills add https://github.com/mattpocock/skills --skill grilling
-- PS> npx skills add https://github.com/mattpocock/skills --skill diagnose
-- PS> npx skills add https://github.com/mattpocock/skills --skill handoff

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Node.js 22              → node --version
-- [ ] Gemini CLI binary       → gemini --version
-- [ ] Google auth             → gemini (harus login)
-- [ ] GEMINI.md               → project root
-- [ ] MCP servers             → ls $env:USERPROFILE\.gemini\mcp.json
-- [ ] DeepSeek key            → echo $env:DEEPSEEK_API_KEY

-- ============================================================================
-- TROUBLESHOOTING (Windows)
-- ============================================================================

-- Problem: gemini: command not found
-- Fix:     Tambah %APPDATA%\npm ke PATH Environment Variables
--          TUTUP & BUKA ULANG PowerShell

-- Problem: Permissions / EACCES error
-- Fix:     Run PowerShell as Administrator
--          ATAU: npm config set prefix "$env:USERPROFILE\.npm-global"

-- Problem: Rate limit (free tier: 60 req/min)
-- Fix:     Tunggu 1 menit ATAU upgrade ke GEMINI_API_KEY

-- Problem: Settings JSON tidak bisa dibaca
-- Fix:     Pastiin pakai double quotes (") bukan single quotes
--          Validasi JSON: Get-Content $env:USERPROFILE\.gemini\settings.json | ConvertFrom-Json

-- ============================================================================
-- DAILY WORKFLOW
-- ============================================================================

-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> gemini
-- /model gemini-2.5-pro
-- "Jelaskan struktur database"
-- "Search Google for PostgreSQL 16 best practices"
-- "Tambah index di kolom yang sering di-join"

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Gemini CLI docs:     https://geminicli.com/docs/
-- Google AI Studio:    https://aistudio.google.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Selamat ngoding dengan Gemini CLI di Windows! 💎
-- ============================================================================
