-- ============================================================================
-- Claude Code Standalone Setup Guide (Manual — No Scripts) — WINDOWS NATIVE
-- ============================================================================
--
-- This file is a complete, step-by-step guide to install Claude Code (Anthropic)
-- MANUALLY on WINDOWS (PowerShell) — no WSL needed.
-- Each section is an SQL comment block. Copy-paste each PowerShell block.
--
-- Stack overview:
--   Layer 1: Claude Code binary    → the agent itself (native Windows installer)
--   Layer 2: DeepSeek provider     → alternative cheap model
--   Layer 3: MCP servers           → grep search, filesystem, git tools
--   Layer 4: CLAUDE.md + hooks     → project context & automation
--   Layer 5: Skills                → grilling, diagnose, handoff
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 build 1809+ / Windows 11
 *   - PowerShell 5.1+ (bawaan Windows)
 *   - Git for Windows (download dari https://git-scm.com)
 *   - Anthropic account: Pro ($20/mo), Max, Teams, atau Enterprise
 */

-- Cek Windows version
-- PS> [System.Environment]::OSVersion.Version

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- PS> Get-CimInstance Win32_ComputerSystem | Select TotalPhysicalMemory

-- Cek PowerShell version
-- PS> $PSVersionTable.PSVersion

-- Install Git for Windows kalo belum ada
--   Download: https://git-scm.com/download/win
--   PENTING: Centang "Git from the command line and also from 3rd-party software"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CLAUDE CODE — Native Windows installer (NO Node.js needed!)   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╗
 *
 * Claude Code sekarang punya NATIVE Windows support via installer.
 * Ga perlu Node.js, ga perlu WSL — langsung jalan di PowerShell.
 *
 * WAJIB: Anthropic paid account (Pro $20/mo).
 * Docs:  https://docs.anthropic.com/en/docs/claude-code
 */

-- Step 1.1: Install Claude Code (native installer — RECOMMENDED)
-- PS> irm https://claude.ai/install.ps1 | iex
--   (Run as Administrator untuk best results)

-- Alternatif: winget (Windows package manager)
-- PS> winget install Anthropic.ClaudeCode

-- Step 1.2: PATH configuration (kalo "claude" not found)
--   Claude installs ke: %USERPROFILE%\.local\bin
--   Buka Environment Variables (System Properties → Advanced → Environment Variables)
--   Tambah ke User Path: %USERPROFILE%\.local\bin
--   TUTUP & BUKA ULANG PowerShell

-- Step 1.3: Verifikasi instalasi
-- PS> claude --version

-- Step 1.4: Launch Claude Code (first run — OAuth authentication)
-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> claude
--   → Browser buka untuk login Anthropic
--   → Kalo browser ga kebuka: set $env:BROWSER
-- PS> $env:BROWSER = "C:\Program Files\Google\Chrome\Application\chrome.exe"

-- Step 1.5: Basic commands
-- PS> claude                                          -- interactive session
-- PS> claude -p "explain this codebase"               -- one-shot (headless)
-- PS> claude --model claude-sonnet-4-20250514 "task"  -- pakai model spesifik
-- PS> claude doctor                                   -- diagnostics

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Alternative cheap model                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Claude Code native-nya pake Anthropic models. DeepSeek sebagai cadangan
 * via OpenAI-compatible API buat task ringan.
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys → Sign up → copy key

-- Step 2.2: Set ENVIRONMENT VARIABLES (permanent di Windows)
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-deepseek-key-here", "User")
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-your-deepseek-key-here", "User")
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_BASE", "https://api.deepseek.com/v1", "User")
--   TUTUP & BUKA ULANG PowerShell setelah set

-- Step 2.3: Verifikasi key
-- PS> $headers = @{ Authorization = "Bearer $env:DEEPSEEK_API_KEY" }
-- PS> Invoke-RestMethod -Uri "https://api.deepseek.com/v1/models" -Headers $headers

-- Step 2.4: Cara pakai DeepSeek di Claude Code
-- PS> claude --model openai/deepseek-chat "Jelaskan codebase ini"
--
--   Atau di dalam session:
--   /model openai/deepseek-chat

-- Step 2.5: Model DeepSeek yang tersedia
--   deepseek-chat (v3)       → reasoning bagus                ($0.27/$1.10)
--   deepseek-v4-flash        → murah, cepat, daily use         ($0.14/$0.28)

-- Step 2.6: Set Anthropic API key (wajib buat Claude Code)
-- PS> [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-your-key-here", "User")

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: MCP SERVERS — Extend Claude Code dengan tools eksternal       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: Buat MCP config folder
-- PS> New-Item -ItemType Directory -Force -Path $env:USERPROFILE\.claude

-- Step 3.2: Buat MCP config file
--   Edit: $env:USERPROFILE\.claude\mcp.json
--
--   {
--     "mcpServers": {
--       "grep": {
--         "command": "npx",
--         "args": ["-y", "@anthropic/mcp-server-grep"]
--       },
--       "filesystem": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\RYZEN\\Desktop\\SQL-QUERY-JOB"]
--       },
--       "git": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-git"]
--       }
--     }
--   }
--
--   CATATAN: Gunakan DOUBLE backslash (\\\\) untuk Windows path!

-- Step 3.3: MCP commands di dalam Claude Code
--   /mcp list    → lihat semua MCP server
--   /mcp status  → cek koneksi

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: CLAUDE.MD + HOOKS — Project context & automation               ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: Generate CLAUDE.md
-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> claude
--   → /init (scan codebase → generate CLAUDE.md)

-- Step 4.2: Setup Git Bash path (kalo Claude perlu bash)
-- PS> [Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", "C:\Program Files\Git\bin\bash.exe", "User")

-- Step 4.3: Hooks location
--   Folder: $env:USERPROFILE\.claude\hooks\
--   Bikin .ps1 scripts buat hooks (pre-edit, post-edit, dll)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS — Pre-built agent behaviors                            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install skills
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

-- [ ] Git for Windows         → git --version
-- [ ] Claude Code binary      → claude --version
-- [ ] Anthropic account       → claude (harus login)
-- [ ] DeepSeek key            → echo $env:DEEPSEEK_API_KEY
-- [ ] MCP servers             → ls $env:USERPROFILE\.claude\mcp.json
-- [ ] CLAUDE.md               → project root
-- [ ] Skills                  → ls $env:USERPROFILE\.claude\skills\

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /init, /clear, /compact, /doctor, /context, /mcp list, /cost

-- ============================================================================
-- TROUBLESHOOTING (Windows)
-- ============================================================================

-- Problem: claude: command not found
-- Fix:     Tambah %USERPROFILE%\.local\bin ke PATH Environment Variables
--          TUTUP & BUKA ULANG PowerShell

-- Problem: Execution policy blocks install.ps1
-- Fix:     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

-- Problem: "Git Bash not found" error
-- Fix:     Install Git for Windows DULU → centang "Git from command line"
--          ATAU set manual: $env:CLAUDE_CODE_GIT_BASH_PATH

-- Problem: Browser ga kebuka pas login
-- Fix:     Copy URL dari terminal, paste manual di browser

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Claude Code docs:    https://docs.anthropic.com/en/docs/claude-code
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Git for Windows:     https://git-scm.com/download/win

-- ============================================================================
-- EOF — Selamat ngoding dengan Claude Code di Windows! 🤖
-- ============================================================================
