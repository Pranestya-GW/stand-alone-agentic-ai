-- ============================================================================
-- Cursor CLI Standalone Setup Guide (Manual — No Scripts) — WINDOWS NATIVE
-- ============================================================================
-- Sprint 27 — Juli 2026 | Exploration
--
-- Complete guide to install Cursor CLI on WINDOWS (PowerShell). NO WSL.
-- Copy-paste each PowerShell block.
--
-- Stack overview:
--   Layer 1: Cursor CLI binary    → the agent itself
--   Layer 2: DeepSeek provider    → alternative cheap model
--   Layer 3: MCP servers          → extend with external tools
--   Layer 4: @cursor/sdk          → programmatic agents (TypeScript)
--   Layer 5: Skills + hooks       → custom behaviors & automation
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
 *   - Cursor subscription: Hobby (free limited), Pro ($20/mo), atau Teams
 *
 * KENAPA CURSOR CLI DI WINDOWS?
 *   - Native Windows build sejak 2026 — NO WSL
 *   - Terminal version of Cursor IDE's Composer engine
 *   - Multi-model: Composer 2.5, GPT-5.5, Opus 4.8, Gemini 3.1
 *   - TypeScript SDK + MCP ecosystem
 */

-- Cek Windows version
-- PS> [System.Environment]::OSVersion.Version

-- Cek RAM — minimal 4GB
-- PS> Get-CimInstance Win32_ComputerSystem | Select TotalPhysicalMemory

-- Install Git for Windows kalo belum ada
--   Download: https://git-scm.com/download/win

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CURSOR CLI — Native Windows installer (NO Node.js needed!)     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Cursor CLI sekarang ada native Windows installer. Langsung jalan di
 * PowerShell — ga perlu npm atau WSL.
 *
 * Command: agent (bukan cursor-agent di Windows)
 * Location: C:\Users\<user>\AppData\Local\cursor-agent\
 */

-- Step 1.1: Install Cursor CLI (one-liner)
-- PS> irm 'https://cursor.com/install?win32=true' | iex

-- Alternatif: Download & run installer script
-- PS> irm https://cursor.com/install -OutFile install.ps1; .\install.ps1

-- Step 1.2: PATH configuration (auto-added, but verify)
-- PS> $installPath = "$env:USERPROFILE\AppData\Local\cursor-agent"
-- PS> if ($env:Path -notlike "*$installPath*") {
--        [Environment]::SetEnvironmentVariable("Path", $installPath + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
--     }

-- Step 1.3: Verifikasi
-- PS> agent --version

-- Step 1.4: Optional: install ripgrep (kadang dibutuhkan internal)
-- PS> winget install BurntSushi.ripgrep.msvc

-- Step 1.5: Launch
-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> agent
--   → Login dengan Cursor account (Pro $20/mo atau Hobby free)

-- Step 1.6: Basic commands
-- PS> agent                                            -- interactive TUI
-- PS> agent -p "Explain this codebase"                 -- headless
-- PS> agent --model composer-2 "Refactor this query"   -- pakai model spesifik

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Alternative murah                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Cursor CLI native pake Composer/GPT/Claude/Gemini.
 * DeepSeek via custom provider di config.json.
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys → Sign up → copy key

-- Step 2.2: Set environment variable (permanent)
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-deepseek-key-here", "User")
--   TUTUP & BUKA ULANG PowerShell

-- Step 2.3: Setup custom provider di Cursor config
--   Edit: $env:USERPROFILE\.cursor\config.json
--   {
--     "providers": {
--       "deepseek": {
--         "type": "openai-compatible",
--         "baseUrl": "https://api.deepseek.com/v1",
--         "apiKey": "env:DEEPSEEK_API_KEY",
--         "models": ["deepseek-chat", "deepseek-v4-flash"]
--       }
--     }
--   }

-- Step 2.4: Switch model
--   /model deepseek-chat
--   /model deepseek-v4-flash
--   /model Auto              → auto-select best model

-- Step 2.5: Model bawaan Cursor (dengan Pro subscription)
--   Composer 2.5             → model utama Cursor
--   GPT-5.5                  → OpenAI, reasoning
--   Claude Opus 4.8          → Anthropic, code gen
--   Gemini 3.1 Pro           → Google, 1M context

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: MCP SERVERS — Connect tools via Model Context Protocol         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: Buat MCP config
-- PS> New-Item -ItemType Directory -Force -Path $env:USERPROFILE\.cursor

-- Step 3.2: Edit $env:USERPROFILE\.cursor\mcp.json
--   {
--     "mcpServers": {
--       "grep": {
--         "command": "npx",
--         "args": ["-y", "@anthropic/mcp-server-grep"]
--       },
--       "git": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-git"]
--       },
--       "filesystem": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-filesystem", "C:\\Users\\RYZEN\\Desktop\\SQL-QUERY-JOB"]
--       }
--     }
--   }
--   CATATAN: Windows path pakai \\ (DOUBLE backslash)!

-- Step 3.3: MCP servers populer
--   grep, git, filesystem, postgres, playwright, context7

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: @CURSOR/SDK — Programmatic agents (TypeScript)                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: Setup SDK project
-- PS> mkdir ~/cursor-agents; cd ~/cursor-agents
-- PS> npm init -y
-- PS> npm install @cursor/sdk
-- PS> npm install typescript tsx --save-dev

-- Step 4.2: Contoh agent (review-agent.ts)
--   import { Agent } from "@cursor/sdk";
--
--   const agent = await Agent.create({
--     apiKey: process.env.CURSOR_API_KEY!,
--     model: { id: "composer-2" },
--     local: { cwd: process.cwd() },
--   });
--
--   const run = await agent.send("Review this PR for bugs and SQL injection");
--   for await (const event of run.stream()) {
--     if (event.type === "text") process.stdout.write(event.content);
--   }

-- Step 4.3: Run agent
-- PS> $env:CURSOR_API_KEY = "your-cursor-api-key"
-- PS> npx tsx review-agent.ts

-- Step 4.4: CI/CD (GitHub Actions — Windows runner)
--   - uses: actions/checkout@v4
--   - uses: actions/setup-node@v4
--     with: { node-version: '22' }
--   - run: npm install @cursor/sdk && npx tsx review-agent.ts
--     env:
--       CURSOR_API_KEY: ${{ secrets.CURSOR_API_KEY }}

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS + HOOKS + CONFIG                                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install skills
-- PS> npx skills add https://github.com/mattpocock/skills --skill grilling
-- PS> npx skills add https://github.com/mattpocock/skills --skill diagnose
-- PS> npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 5.2: Hooks system (PowerShell scripts)
--   Location: $env:USERPROFILE\.cursor\hooks\
--   pre-edit.ps1, post-edit.ps1, pre-commit.ps1

-- Step 5.3: Full config example ($env:USERPROFILE\.cursor\config.json)
--   {
--     "model": { "default": "auto" },
--     "security": { "confirmShellCommands": true },
--     "providers": {
--       "deepseek": {
--         "type": "openai-compatible",
--         "baseUrl": "https://api.deepseek.com/v1",
--         "apiKey": "env:DEEPSEEK_API_KEY",
--         "models": ["deepseek-chat", "deepseek-v4-flash"]
--       }
--     }
--   }

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Cursor CLI binary       → agent --version
-- [ ] Cursor account          → agent (harus login)
-- [ ] DeepSeek key            → echo $env:DEEPSEEK_API_KEY
-- [ ] MCP servers             → ls $env:USERPROFILE\.cursor\mcp.json
-- [ ] Skills                  → ls $env:USERPROFILE\.cursor\skills\
-- [ ] @cursor/sdk             → npm ls @cursor/sdk

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /model Auto, /review, /clear, /context, /cost, /diff
-- @filename, !command, !git status

-- ============================================================================
-- TROUBLESHOOTING (Windows)
-- ============================================================================

-- Problem: agent: command not found
-- Fix:     Cek instalasi di $env:USERPROFILE\AppData\Local\cursor-agent\
--          Tambah ke PATH manual (lihat Step 1.2)

-- Problem: ripgrep (rg.exe) not found
-- Fix:     winget install BurntSushi.ripgrep.msvc
--          ATAU download dari https://github.com/BurntSushi/ripgrep/releases

-- Problem: Execution policy blocks installer
-- Fix:     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

-- Problem: Authentication failed
-- Fix:     Cek account Cursor (harus Pro/Hobby)
--          Remove-Item -Recurse -Force $env:USERPROFILE\.cursor\auth
--          agent (login ulang)

-- Problem: @cursor/sdk TypeScript errors
-- Fix:     npm install @cursor/sdk (pastiin di project folder)
--          Cek tsconfig.json: "moduleResolution": "bundler"

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Cursor website:      https://cursor.com
-- Cursor CLI:          https://cursor.com/cli
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Selamat ngoding dengan Cursor CLI di Windows! 🖱️
-- ============================================================================
