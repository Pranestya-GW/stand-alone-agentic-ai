-- ============================================================================
-- Cursor CLI Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
-- Sprint 27 — Juli 2026 | Exploration
--
-- This file is a complete, step-by-step guide to install Cursor CLI
-- and the recommended stack MANUALLY — no shell scripts, just copy-paste each block.
--
-- Each section is an SQL comment block. Run the commands inside one by one
-- in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Cursor CLI binary    → the agent itself (standalone)
--   Layer 2: DeepSeek provider    → cheapest model alternative
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
 *   - WSL2 / Ubuntu 22.04+ (atau macOS 13+, Windows 11)
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - Cursor subscription: Hobby (free limited), Pro ($20/mo), atau Teams
 *
 * KENAPA CURSOR CLI?
 *   - Terminal version of Cursor IDE's AI agent
 *   - Composer engine di terminal — no GUI needed
 *   - Support banyak model: Composer 2.5, GPT-5.5, Opus 4.8, Gemini 3.1
 *   - Headless mode: `cursor-agent -p "task"` buat CI/CD
 *   - MCP + Hooks + SDK ecosystem
 *   - @filename dan !command mid-conversation
 *
 * Docs:    https://cursor.com
 */

-- Cek OS
-- $ uname -a

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- $ free -h

-- Cek disk — butuh ~2GB free
-- $ df -h ~

-- Install curl & git kalo belum ada
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CURSOR CLI — Install agent (standalone binary)                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Cursor CLI adalah terminal version dari Cursor IDE agent.
 * Bawa engine Composer ke terminal — edit file, execute commands,
 * integrasi MCP, support multiple AI models.
 */

-- Step 1.1: Install Cursor CLI (official installer)
-- $ curl https://cursor.com/install -fsS | bash

-- Alternatif: Manual download dari https://cursor.com/download

-- Step 1.2: Verifikasi instalasi
-- $ cursor-agent --version
--   ATAU:
-- $ cursor --version

-- Step 1.3: Login (first run)
-- $ cursor-agent
--   → Login dengan Cursor account (Hobby free, Pro $20/mo, Teams)
--   → Browser OAuth authentication

-- Step 1.4: Basic commands reference
-- $ cursor-agent                                 -- interactive TUI mode
-- $ cursor-agent -p "Explain this codebase"      -- one-shot prompt (headless)
-- $ cursor                                       -- alias (kadang works)
-- $ cursor-agent --model <name> "task"           -- pakai model spesifik

-- Step 1.5: Core modes
--   Interactive (TUI)   → cursor-agent (chat interface di terminal)
--   Headless             → cursor-agent -p "task" (CI/CD, scripts)
--   Shell mode           → agent jalanin shell commands dengan safety check

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Provider alternatif murah                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Cursor CLI native-nya pake Cursor models (Composer 2.5, GPT-5.5, dll).
 * TAPI support OpenAI-compatible providers — termasuk DeepSeek!
 *
 * Kenapa tambahin DeepSeek?
 *   - Lebih murah buat task yang ga butuh reasoning kompleks
 *   - 500M token GRATIS pas signup
 *   - deepseek-v4-flash: $0.14/$0.28 per 1M token
 *   - Kalo Pro quota abis, DeepSeek jadi cadangan
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys
--   Sign up (gratis) → copy API key (format: sk-...)

-- Step 2.2: Simpan permanent di ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 2.3: Verifikasi key jalan
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 2.4: Setup DeepSeek sebagai custom provider di Cursor CLI
--   Edit ~/.cursor/config.json:
--
--   {
--     "providers": {
--       "deepseek": {
--         "type": "openai-compatible",
--         "baseUrl": "https://api.deepseek.com/v1",
--         "apiKey": "env:DEEPSEEK_API_KEY",
--         "models": [
--           "deepseek-chat",
--           "deepseek-v4-flash"
--         ]
--       }
--     }
--   }

-- Step 2.5: Cara switch ke DeepSeek di Cursor CLI
--   /model deepseek-chat
--   /model deepseek-v4-flash
--
--   ATAU auto-select:
--   /model Auto              → Cursor pilih model terbaik otomatis

-- Step 2.6: Model bawaan Cursor (gratis dengan Pro subscription)
--   Composer 2.5             → model utama Cursor, general purpose
--   GPT-5.5                  → OpenAI, reasoning terbaik
--   Claude Opus 4.8          → Anthropic, code generation
--   Gemini 3.1 Pro           → Google, 1M context
--   Grok 4.3                 → xAI, real-time info

-- Step 2.7: Model DeepSeek yang tersedia
--   deepseek-chat (v3)       → reasoning bagus, task kompleks    ($0.27/$1.10)
--   deepseek-v4-flash        → cepat, murah, daily use           ($0.14/$0.28)
--   deepseek-reasoner        → deep thinking, math/logic         (price TBD)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: MCP SERVERS — Connect tools & APIs via Model Context Protocol  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * MCP (Model Context Protocol) adalah standard industri buat koneksi
 * AI agent ke tools eksternal. Cursor CLI support MCP native.
 *
 * Config: ~/.cursor/mcp.json atau <project>/.cursor/mcp.json
 * Docs: https://modelcontextprotocol.io
 */

-- Step 3.1: Buat MCP config
-- $ mkdir -p ~/.cursor

-- Step 3.2: Tambah MCP servers
--   Edit ~/.cursor/mcp.json:
--
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
--         "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/nes/SQL-QUERY-JOB"]
--       },
--       "postgres": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-postgres"],
--         "env": {
--           "DATABASE_URL": "postgresql://user:pass@localhost:5432/mydb"
--         }
--       }
--     }
--   }

-- Step 3.3: MCP servers populer buat Cursor CLI
--   grep              → code search on millions of GitHub repos
--   git               → commit, branch, diff, blame
--   filesystem        → file operations outside working directory
--   postgres          → query PostgreSQL database langsung
--   playwright        → browser automation + testing
--   context7          → fetch latest library docs
--   linear            → issue tracking & project management
--   github            → issues, PRs, repos management

-- Step 3.4: Cara pakai MCP di Cursor CLI session
--   Cursor auto-detect tools dari MCP servers.
--   Prompt natural aja:
--   "Search GitHub for PostgreSQL indexing best practices using grep"
--   "Check git diff and commit with a meaningful message"
--   "Query all unpaid customers from the database"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: @CURSOR/SDK — Build programmatic agents in TypeScript         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * @cursor/sdk memungkinkan lo buat PROGRAMMATIC AGENTS — agent yang
 * jalan di CI/CD pipeline, script, atau aplikasi lo sendiri.
 * Full TypeScript SDK dengan streaming, tool use, dan multi-model.
 */

-- Step 4.1: Install SDK
-- $ npm install @cursor/sdk

-- Step 4.2: Setup project workspace
-- $ mkdir ~/cursor-agents && cd ~/cursor-agents
-- $ npm init -y
-- $ npm install @cursor/sdk
-- $ npm install typescript tsx --save-dev

-- Step 4.3: Contoh agent sederhana (review-agent.ts)
--
--   import { Agent } from "@cursor/sdk";
--
--   async function main() {
--     const agent = await Agent.create({
--       apiKey: process.env.CURSOR_API_KEY!,
--       model: { id: "composer-2" },
--       local: { cwd: process.cwd() },
--     });
--
--     const run = await agent.send(
--       "Review this PR diff and find bugs, security issues, and SQL injection risks"
--     );
--
--     for await (const event of run.stream()) {
--       if (event.type === "text") {
--         process.stdout.write(event.content);
--       }
--     }
--
--     console.log("\n✅ Review complete");
--   }
--
--   main().catch(console.error);

-- Step 4.4: Run agent
-- $ export CURSOR_API_KEY="your-cursor-api-key"
-- $ npx tsx review-agent.ts

-- Step 4.5: CI/CD integration (GitHub Actions example)
--   name: Cursor Code Review
--   on: [pull_request]
--   jobs:
--     review:
--       runs-on: ubuntu-latest
--       steps:
--         - uses: actions/checkout@v4
--         - uses: actions/setup-node@v4
--           with: { node-version: '22' }
--         - run: npm install @cursor/sdk
--         - run: npx tsx review-agent.ts
--           env:
--             CURSOR_API_KEY: ${{ secrets.CURSOR_API_KEY }}

-- Step 4.6: SDK capabilities
--   agent.send("prompt")            → kirim prompt + stream response
--   agent.interrupt()               → interrupt running agent
--   agent.getContext()              → dapatkan conversation context
--   model: { id: "auto" }          → auto-select best model
--   model: { id: "composer-2" }    → pakai Composer 2
--   model: { id: "gpt-5.5" }       → pakai GPT-5.5

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS + HOOKS — Custom behaviors & lifecycle automation      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install skills via npm packages
-- $ npm install -g developer-context-agent       -- token-efficient context via MCP
-- $ npm install -g @lytics/dev-agent              -- MCP-integrated dev agent

-- Step 5.2: Install pre-built agent skills (from skills.sh registry)
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 5.3: Install cursor-kenji (60 skills + 13 slash commands + 16 MCP servers)
-- $ npx skills add kensaurus/cursor-kenji

-- Step 5.4: Cursor hooks system (~/.cursor/hooks/)
--   Buat script yang jalan di lifecycle events:
--
--   ~/.cursor/hooks/pre-edit.sh:
--   #!/bin/bash
--   # Jalan sebelum Cursor edit file
--   echo "⚠️  About to edit: $CURSOR_EDIT_FILE"
--
--   ~/.cursor/hooks/post-edit.sh:
--   #!/bin/bash
--   # Auto-lint setelah edit
--   sqlfluff lint "$CURSOR_EDIT_FILE"
--
--   ~/.cursor/hooks/pre-commit.sh:
--   #!/bin/bash
--   # Run tests sebelum commit
--   npm test

-- Step 5.5: Cursor config file (~/.cursor/config.json) — full example
--   {
--     "model": {
--       "default": "auto",
--       "available": ["composer-2", "gpt-5.5", "opus-4.8", "gemini-3.1", "deepseek-chat"]
--     },
--     "ui": {
--       "theme": "dark",
--       "showTokens": true,
--       "showCost": true
--     },
--     "security": {
--       "confirmShellCommands": true,
--       "blockedCommands": ["rm -rf", "sudo rm", "chmod -R 777"]
--     },
--     "hooks": {
--       "preEdit": "~/.cursor/hooks/pre-edit.sh",
--       "postEdit": "~/.cursor/hooks/post-edit.sh"
--     },
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
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
-- ============================================================================

-- [ ] Cursor CLI binary       → cursor-agent --version
-- [ ] Cursor account          → cursor-agent (harus login)
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] MCP servers             → ls ~/.cursor/mcp.json
-- [ ] Skills                  → ls ~/.cursor/skills/
-- [ ] @cursor/sdk             → npm ls @cursor/sdk

-- ============================================================================
-- SLASH COMMANDS — Dalam Cursor CLI session (cursor-agent >)
-- ============================================================================

-- /help                → list semua commands
-- /model <name>        → switch model (composer-2, gpt-5.5, deepseek-chat)
-- /model Auto          → auto-select best model
-- /review              → trigger code review (Bugbot)
-- /clear               → reset conversation
-- /context             → cek context window usage
-- /cost                → cek token usage & cost
-- /diff                → lihat perubahan
-- @filename            → inject file ke context
-- !command             → run shell command mid-conversation
-- !git status          → contoh: cek git tanpa keluar session

-- ============================================================================
-- KEY SYNTAX — Dalam Cursor CLI chat
-- ============================================================================

-- @filename.sql         → inject file ke agent context
-- !command               → execute shell command
-- @@symbol               → jump to symbol definition
-- @folder/               → add entire folder to context

-- ============================================================================
-- DAILY WORKFLOW — Contoh session Cursor CLI
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB
-- $ cursor-agent

-- # Di dalam Cursor session:
-- /model deepseek-chat                              -- switch ke DeepSeek
-- @schema.sql                                       -- inject schema ke context
-- "Jelaskan relasi antar tabel di schema ini"
-- "Cari semua query yang pake SELECT * dan ganti"
-- !psql -d mydb -c "\dt"                            -- check tables langsung
-- @queries/unpaid.sql                               -- inject query file
-- "Optimize this query and fix the JOIN order"
-- /review                                           -- code review semua perubahan

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: cursor-agent: command not found
-- Fix:     Install ulang:
--          $ curl https://cursor.com/install -fsS | bash
--          Cek PATH: echo $PATH | grep cursor

-- Problem: Authentication failed
-- Fix:     $ cursor-agent logout
--          $ cursor-agent login

-- Problem: MCP server ga connect
-- Fix:     Cek ~/.cursor/mcp.json valid JSON
--          Cek log: ~/.cursor/logs/mcp.log
--          Restart Cursor CLI

-- Problem: DeepSeek model not showing
-- Fix:     Cek ~/.cursor/config.json — providers config
--          Pastiin DEEPSEEK_API_KEY ke-set: echo $DEEPSEEK_API_KEY
--          Restart cursor-agent

-- Problem: @cursor/sdk types not found
-- Fix:     $ npm install @cursor/sdk
--          Cek tsconfig.json — moduleResolution: "bundler"

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- Cursor CLI:
-- $ rm $(which cursor-agent)
-- $ rm -rf ~/.cursor

-- @cursor/sdk (project-level):
-- $ npm uninstall @cursor/sdk

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Cursor website:      https://cursor.com
-- Cursor SDK blog:     https://cursor.com/blog/typescript-sdk
-- Cursor CLI docs:     https://cursor.com/docs/cli
-- MCP docs:            https://modelcontextprotocol.io
-- MCP servers:         https://github.com/modelcontextprotocol/servers
-- DeepSeek API docs:   https://api-docs.deepseek.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Selamat ngoding dengan Cursor CLI! 🖱️
-- ============================================================================
