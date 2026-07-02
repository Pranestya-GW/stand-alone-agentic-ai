-- ============================================================================
-- Gemini CLI Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- This file is a complete, step-by-step guide to install Gemini CLI (Google)
-- and the recommended stack MANUALLY — no shell scripts, just copy-paste each block.
--
-- Each section is an SQL comment block. Run the commands inside one by one
-- in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Node.js via fnm      → runtime requirement
--   Layer 2: Gemini CLI binary    → the agent itself
--   Layer 3: DeepSeek provider    → alternative model, 500M free
--   Layer 4: GEMINI.md            → project context & conventions
--   Layer 5: MCP servers          → extend with external tools
--   Layer 6: Themes + settings    → custom TUI look & feel
--   Layer 7: Skills               → pre-built agent behaviors
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (atau macOS 15+, Windows 11 24H2+)
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - Google Account (gratis — free tier: 60 req/min, 1000 req/day)
 *
 * KENAPA GEMINI CLI?
 *   - FREE TIER! Ga perlu bayar buat mulai (60 req/min, 1000 req/day)
 *   - 1M token context window — salah satu yang paling gede
 *   - Built-in Google Search grounding (bisa cek fakta live)
 *   - MCP support + GEMINI.md project config
 *   - Open-source: github.com/google-gemini/gemini-cli
 */

-- Cek OS — Linux/WSL, macOS, atau Windows native
-- $ uname -a

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- $ free -h

-- Cek disk — butuh ~2GB free
-- $ df -h ~

-- Install curl & git kalo belum ada
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS — Gemini CLI butuh Node.js 20+                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Kita pake fnm (Fast Node Manager) — lebih ringan dari nvm, lebih cepat.
 * Kenapa fnm? Bisa ganti-ganti versi Node.js dengan mudah, cocok buat
 * development environment yang butuh multiple versions.
 */

-- Step 1.1: Install fnm
-- $ curl -fsSL https://fnm.vercel.app/install | bash

-- Step 1.2: Reload shell (atau tutup-buka terminal)
-- $ source ~/.bashrc
--   ATAU manual:
-- $ export PATH="$HOME/.local/share/fnm:$PATH"
-- $ eval "$(fnm env)"

-- Step 1.3: Install Node.js 22 (LTS — stabil untuk Gemini CLI)
-- $ fnm install 22
-- $ fnm use 22
-- $ fnm default 22

-- Step 1.4: Verifikasi
-- $ node --version           -- harus v22.x.x
-- $ npm --version            -- harus 10.x.x

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: GEMINI CLI — Install agent dari Google                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI adalah open-source terminal agent dari Google DeepMind.
 * Baca codebase, edit file, eksekusi shell, search web, pake MCP.
 *
 * FREE TIER: 60 req/min, 1000 req/day — cukup buat personal dev.
 * Model: Gemini 2.5 Pro, Gemini 3 Flash, dll dengan 1M context.
 *
 * Docs:    https://geminicli.com/docs/
 * GitHub:  https://github.com/google-gemini/gemini-cli
 */

-- Step 2.1: Install Gemini CLI secara global (via npm)
-- $ npm install -g @google/gemini-cli

-- Alternatif: npx (no install — ephemeral)
-- $ npx @google/gemini-cli

-- Alternatif: Homebrew (macOS/Linux)
-- $ brew install gemini-cli

-- Alternatif: Preview/nightly channels
-- $ npm install -g @google/gemini-cli@preview   -- weekly preview
-- $ npm install -g @google/gemini-cli@nightly   -- daily bleeding-edge

-- Step 2.2: Verifikasi instalasi
-- $ gemini --version

-- Step 2.3: Launch Gemini CLI (first run — OAuth authentication)
-- $ cd ~/SQL-QUERY-JOB
-- $ gemini
--   → Pilih "Login with Google" (browser OAuth — GRATIS)
--   → ATAU: export GEMINI_API_KEY="YOUR_KEY" (API key buat CI/CD)
--   → ATAU: export GOOGLE_CLOUD_PROJECT="YOUR_PROJECT_ID" (Vertex AI)

-- Step 2.4: Basic commands reference
-- $ gemini                                          -- interactive TUI mode
-- $ gemini -p "Explain this codebase"               -- one-shot prompt
-- $ gemini -m "gemini-2.5-flash" "Refactor this"    -- pakai model spesifik
-- $ gemini -y "Run all tests"                       -- auto-approve commands

-- Step 2.5: Authentication methods (pilih satu)
--   Login with Google     → browser OAuth, free tier, personal use (RECOMMENDED)
--   GEMINI_API_KEY        → export di ~/.bashrc, higher rate limits
--   GOOGLE_CLOUD_PROJECT   → enterprise / Vertex AI (Google Cloud)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Provider alternatif super murah           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI native-nya pake Google Gemini models (free tier cukup).
 * TAPI bisa tambah DeepSeek sebagai OPENAI-COMPATIBLE provider.
 *
 * Kenapa tambahin DeepSeek?
 *   - Kalo free tier Gemini abis (1000 req/day = ~33 req/jam)
 *   - DeepSeek 500M token GRATIS pas signup
 *   - Alternatif kalo Gemini down atau rate limited
 *   - $0.14/$0.28 per 1M token (jauh lebih murah dari GPT-4o)
 *
 * Docs:     https://api-docs.deepseek.com/
 * API Base: https://api.deepseek.com/v1
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 3.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys
--   Sign up (gratis) → copy API key (format: sk-...)

-- Step 3.2: Simpan permanent di ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 3.3: Verifikasi key jalan
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 3.4: Cara pakai DeepSeek di Gemini CLI
--   Gemini CLI support OpenAI-compatible models via settings config.
--   Edit ~/.gemini/settings.json:
--
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
--
--   Lalu switch model:
--   /model deepseek-chat

-- Step 3.5: Model DeepSeek yang tersedia (referensi)
--   deepseek-chat (v3)       → reasoning bagus, task kompleks    ($0.27/$1.10)
--   deepseek-v4-flash        → cepat, murah, daily use           ($0.14/$0.28)
--   deepseek-reasoner        → deep thinking, math/logic         (price TBD)

-- Step 3.6: Google built-in models (free tier — cukup buat daily coding)
--   gemini-2.5-flash         → cepat, general purpose            (FREE tier)
--   gemini-2.5-pro           → reasoning + tools terbaik         (FREE tier)
--   gemini-3-flash           → model terbaru, low latency        (FREE tier)
--   auto                     → auto-select best model            (DEFAULT)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: GEMINI.MD — Project context & conventions                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * GEMINI.md = file markdown di root project yang ngajarin Gemini CLI
 *             tentang konvensi, arsitektur, dan rules project lo.
 *
 * Mirip CLAUDE.md (Claude Code) atau CODEX.md (Codex CLI).
 * Format: Markdown, taruh di root repo.
 */

-- Step 4.1: Buat GEMINI.md di root project
-- $ cd ~/SQL-QUERY-JOB
--   Bikin file GEMINI.md:

--   # SQL-QUERY-JOB Conventions
--
--   ## Tech Stack
--   - PostgreSQL 16, PL/pgSQL
--   - Deployment: Supabase / self-hosted
--
--   ## Code Style
--   - SQL keywords: UPPERCASE (SELECT, FROM, WHERE)
--   - Table names: snake_case
--   - Always explicit column lists — NEVER SELECT *
--   - Comment complex joins and subqueries
--
--   ## Testing
--   - Run EXPLAIN ANALYZE before every new query
--   - Test on staging DB first (PORT 5433)
--   - Minimum 1000 rows test data
--
--   ## Rules
--   - NEVER drop tables without explicit confirmation
--   - Always create index before querying production
--   - Backup before migration

-- Step 4.2: Gemini CLI auto-reads GEMINI.md setiap session
--   Jadi ga perlu manual load — tinggal taruh file,
--   Gemini bakal baca otomatis pas mulai.

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: MCP SERVERS — Extend Gemini CLI dengan tools eksternal        ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI punya MCP support native. Config di ~/.gemini/mcp.json
 * atau project-level .gemini/mcp.json.
 */

-- Step 5.1: Buat MCP config
-- $ mkdir -p ~/.gemini

-- Step 5.2: Tambah MCP servers
--   Edit ~/.gemini/mcp.json:
--
--   {
--     "mcpServers": {
--       "grep": {
--         "command": "npx",
--         "args": ["-y", "@anthropic/mcp-server-grep"]
--       },
--       "filesystem": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/nes/SQL-QUERY-JOB"]
--       },
--       "git": {
--         "command": "npx",
--         "args": ["-y", "@modelcontextprotocol/server-git"]
--       }
--     }
--   }

-- Step 5.3: Built-in tools Gemini CLI (tanpa MCP)
--   Google Search grounding  → fakta + docs terbaru langsung dari search
--   File operations           → baca/tulis/edit file
--   Shell commands            → eksekusi bash
--   Web fetching              → ambil konten dari URL

-- Step 5.4: MCP commands di dalam Gemini CLI session
--   /mcp list                  → lihat semua MCP server
--   /mcp status                → cek koneksi
--   /mcp tools                 → lihat tools yang tersedia

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: THEMES + SETTINGS — Customize TUI look & behavior             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Settings file location
--   ~/.gemini/settings.json        → user-level (global)
--   <project>/.gemini/settings.json → project-level (override user)

-- Step 6.2: Contoh settings.json lengkap
--   {
--     "ui": {
--       "theme": "tokyo-night",          -- tema TUI
--       "showTokenCount": true,          -- tampilin token usage
--       "showCostEstimate": true         -- tampilin estimasi biaya
--     },
--     "security": {
--       "auth": {
--         "selectedType": "oauth-personal"
--       },
--       "autoApprove": false,            -- false = minta konfirmasi (RECOMMENDED)
--       "blockedCommands": ["rm -rf", "sudo", "chmod 777"]
--     },
--     "model": {
--       "default": "gemini-2.5-flash"
--     }
--   }

-- Step 6.3: Available themes (bawaan Gemini CLI)
--   Default, Dark, Light, High-Contrast
--   Bisa custom dengan edit settings.json → "ui.theme"

-- Step 6.4: Commands di dalam Gemini CLI session
--   /theme              → ganti tema TUI
--   /settings           → buka settings.json di editor
--   /stats              → lihat usage stats (req count, tokens, cost)
--   /docs               → search Gemini CLI documentation
--   /clear              → reset conversation

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 7: SKILLS — Pre-built agent behaviors                            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 7.1: Install grilling skill (stress-test rencana)
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling

-- Step 7.2: Install diagnose skill (disciplined debugging)
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose

-- Step 7.3: Install handoff skill (compact conversation)
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 7.4: Cara pakai skills di Gemini CLI
--   "Grill me on this database normalization plan"
--   "Diagnose why this query plan is suboptimal"
--   "Handoff this session for the next agent"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
-- ============================================================================

-- [ ] Node.js 22              → node --version
-- [ ] Gemini CLI binary       → gemini --version
-- [ ] Google auth             → gemini (harus login)
-- [ ] GEMINI.md               → ls ~/SQL-QUERY-JOB/GEMINI.md
-- [ ] MCP servers             → ls ~/.gemini/mcp.json
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] Skills                  → ls ~/.gemini/skills/

-- ============================================================================
-- SLASH COMMANDS — Dalam Gemini CLI session
-- ============================================================================

-- /help                → list semua commands
-- /model <name>        → ganti model
-- /theme               → ganti tema TUI
-- /settings            → buka settings.json
-- /stats               → usage stats
-- /docs                → search documentation
-- /clear               → reset conversation
-- /mcp list            → MCP server list
-- /mcp status          → MCP connection status

-- ============================================================================
-- DAILY WORKFLOW — Contoh session Gemini CLI
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB
-- $ gemini

-- # Di dalam Gemini session:
-- /model gemini-2.5-pro                              -- upgrade model (kalo butuh reasoning)
-- "Jelaskan struktur database project ini"
-- "Search Google for PostgreSQL 16 best practices"   -- built-in search grounding!
-- "Cari query yang pake SELECT * dan ganti"
-- "Tambah index di kolom yang sering di-join"
-- "Grill me on indexing strategy buat vu_kasir"

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: gemini: command not found
-- Fix:     $ npm install -g @google/gemini-cli
--          Cek PATH: echo $PATH | grep npm-global

-- Problem: npm install gagal (permission error)
-- Fix:     $ mkdir ~/.npm-global
--          $ npm config set prefix '~/.npm-global'
--          $ echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc

-- Problem: Rate limit (60 req/min exceeded)
-- Fix:     Tunggu 1 menit ATAU upgrade ke paid tier dengan API key
--          $ export GEMINI_API_KEY="your-key"

-- Problem: Authentication loop (login terus)
-- Fix:     $ rm -rf ~/.gemini/auth
--          $ gemini (login ulang)

-- Problem: DeepSeek model not available
-- Fix:     Cek settings.json di ~/.gemini/settings.json
--          Pastiin DEEPSEEK_API_KEY ke-set: echo $DEEPSEEK_API_KEY

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- $ npm uninstall -g @google/gemini-cli
-- $ rm -rf ~/.gemini

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Gemini CLI docs:     https://geminicli.com/docs/
-- Gemini CLI GitHub:   https://github.com/google-gemini/gemini-cli
-- DeepSeek API docs:   https://api-docs.deepseek.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- MCP docs:            https://modelcontextprotocol.io
-- Skills directory:    https://www.skills.sh/
-- Google AI Studio:    https://aistudio.google.com/

-- ============================================================================
-- EOF — Selamat ngoding dengan Gemini CLI! 💎
-- ============================================================================
