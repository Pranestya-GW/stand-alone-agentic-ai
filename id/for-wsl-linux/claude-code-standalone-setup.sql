-- ============================================================================
-- Claude Code Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- This file is a complete, step-by-step guide to install Claude Code (Anthropic)
-- and the recommended stack MANUALLY — no shell scripts, just copy-paste each block.
--
-- Each section is an SQL comment block. Run the commands inside one by one
-- in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Node.js via fnm      → runtime requirement
--   Layer 2: Claude Code binary   → the agent itself
--   Layer 3: DeepSeek provider    → cheapest model for daily coding
--   Layer 4: MCP servers          → grep search, filesystem, git tools
--   Layer 5: CLAUDE.md + hooks    → project context & automation
--   Layer 6: Skills               → grilling, diagnose, handoff
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - Anthropic account (Pro $20/mo, Max, Teams, atau Enterprise)
 */

-- Cek OS — harus Linux/WSL
-- $ uname -a

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- $ free -h

-- Cek disk — butuh ~2GB free
-- $ df -h ~

-- Install curl & git kalo belum ada
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS — Claude Code butuh Node.js 18+                        ║
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

-- Step 1.3: Install Node.js 22 (LTS — paling stabil buat Claude Code)
-- $ fnm install 22
-- $ fnm use 22
-- $ fnm default 22          -- biar permanen, ga perlu ketik ulang tiap buka terminal

-- Step 1.4: Verifikasi
-- $ node --version           -- harus v22.x.x
-- $ npm --version            -- harus 10.x.x

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: CLAUDE CODE — Install agent Anthropic                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Claude Code adalah terminal coding agent dari Anthropic.
 * Baca codebase, edit multi-file, eksekusi bash, integrasi MCP.
 *
 * WAJIB: Anthropic paid account (Pro $20/mo, Max, Teams, Enterprise).
 *        Free-tier accounts ga bisa.
 *
 * Docs:    https://docs.anthropic.com/en/docs/claude-code
 * GitHub:  https://github.com/anthropics/claude-code
 */

-- Step 2.1: Install Claude Code secara global (via npm)
-- $ npm install -g @anthropic-ai/claude-code

-- Alternatif: Native installer (no Node.js needed, auto-update)
-- $ curl -fsSL https://claude.ai/install.sh | bash

-- Alternatif: Homebrew (macOS)
-- $ brew install claude-code

-- Step 2.2: Verifikasi instalasi
-- $ claude --version

-- Step 2.3: Fix PATH kalo "claude: command not found"
-- $ mkdir -p ~/.npm-global
-- $ npm config set prefix '~/.npm-global'
-- $ echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 2.4: Launch Claude Code (first run — OAuth authentication)
-- $ cd ~/SQL-QUERY-JOB
-- $ claude
--   → Browser akan buka untuk login Anthropic
--   → Kalo ga ada browser: copy URL dari terminal, buka manual

-- Step 2.5: Basic commands reference
-- $ claude                                    -- interactive session
-- $ claude -p "explain this codebase"         -- one-shot prompt (headless)
-- $ claude --model claude-sonnet-4-20250514   -- pakai model spesifik
-- $ claude doctor                             -- diagnostics

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Tambahan provider murah                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * CATATAN: Claude Code native-nya pake Anthropic models (Claude 3.5/4).
 *          DeepSeek bisa dipake sebagai OPENAI-COMPATIBLE provider
 *          atau via MCP proxy / custom endpoint.
 *
 * Kenapa tambahin DeepSeek?
 *   - $0.14/$0.28 per 1M token (input/output) — jauh lebih murah
 *   - 500M token GRATIS pas signup
 *   - Buat task ringan yang ga butuh reasoning kompleks
 *   - deepseek-v4-flash: cepat + bagus buat daily coding
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

-- Step 3.4: Cara pakai DeepSeek di Claude Code
--
--   Claude Code punya custom provider support via OPENAI_API_BASE.
--   Buat pakai DeepSeek, set environment variables:
--
-- $ export ANTHROPIC_API_KEY="sk-ant-..."     -- Anthropic key (wajib buat Claude Code)
-- $ export OPENAI_API_KEY="$DEEPSEEK_API_KEY"
-- $ export OPENAI_API_BASE="https://api.deepseek.com/v1"
--
--   Lalu di dalam Claude Code:
--   /model deepseek-chat                       -- switch ke DeepSeek
--
--   ATAU via flags pas launch:
-- $ claude --model openai/deepseek-chat

-- Step 3.5: Model DeepSeek yang tersedia (referensi)
--   deepseek-chat (v3)       → general purpose, reasoning bagus   ($0.27/$1.10)
--   deepseek-v4-flash        → cepat, murah, daily use             ($0.14/$0.28)
--   deepseek-reasoner        → deep thinking, math/logic           (price TBD)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: MCP SERVERS — Extend Claude Code dengan tools eksternal       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * MCP (Model Context Protocol) adalah standard buat ngehubungin AI agent
 * ke tools eksternal — grep code search, filesystem, git, database, dll.
 *
 * Claude Code support MCP natively. Config di ~/.claude/claude_desktop_config.json
 * atau di project-level .mcp.json.
 *
 * Docs: https://modelcontextprotocol.io
 */

-- Step 4.1: Buat config file MCP
-- $ mkdir -p ~/.claude

-- Step 4.2: Tambah MCP server — grep code search
--   Edit ~/.claude/mcp.json atau buat project .mcp.json:
--
-- {
--   "mcpServers": {
--     "grep": {
--       "command": "npx",
--       "args": ["-y", "@anthropic/mcp-server-grep"]
--     },
--     "filesystem": {
--       "command": "npx",
--       "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/nes/SQL-QUERY-JOB"]
--     },
--     "git": {
--       "command": "npx",
--       "args": ["-y", "@modelcontextprotocol/server-git"]
--     }
--   }
-- }

-- Step 4.3: MCP commands di dalam Claude Code
--   /mcp list                  → lihat semua MCP server yang aktif
--   /mcp status                → cek koneksi tiap server
--   /mcp tools                 → lihat tools yang disediakan MCP
--   /mcp restart <server>      → restart server yang error

-- Step 4.4: MCP server populer buat development
--   grep            → code search across millions of GitHub repos
--   filesystem      → baca/tulis/manage file di luar working directory
--   git             → commit, branch, diff, blame langsung dari agent
--   postgres        → query database PostgreSQL langsung
--   context7        → fetch library docs terbaru
--   playwright      → browser automation + testing
--   wrenai          → text-to-SQL + data analysis

-- Step 4.5: Cara pake MCP di session
--   Claude akan auto-detect tools dari MCP server.
--   Prompt natural aja:
--   "Search GitHub for PostgreSQL connection pooling examples using grep"
--   "Check git diff dan commit perubahan dengan message yang jelas"
--   "Query semua customer yang belom bayar di database"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: CLAUDE.MD + HOOKS — Project context & automation               ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * CLAUDE.md = file markdown di root project yang ngajarin Claude Code
 *             tentang konvensi, arsitektur, dan rules project lo.
 *
 * Hooks = script otomatis yang jalan sebelum/sesudah event tertentu
 *         (pre-edit, post-commit, pre-prompt, dll).
 */

-- Step 5.1: Buat CLAUDE.md di root project
-- $ cd ~/SQL-QUERY-JOB
-- $ claude
--   → Ketik /init → Claude bakal scan codebase dan generate CLAUDE.md

-- Step 5.2: Isi CLAUDE.md manual (contoh)
--   Edit ~/SQL-QUERY-JOB/CLAUDE.md:
--
--   # SQL-QUERY-JOB Conventions
--
--   ## Tech Stack
--   - PostgreSQL 16, PL/pgSQL
--   - Deployment: Supabase / self-hosted
--
--   ## Code Style
--   - SQL keywords UPPERCASE: SELECT, FROM, WHERE
--   - Table names: snake_case
--   - Always use explicit column lists, never SELECT *
--   - Add comments for complex joins
--
--   ## Testing
--   - Run EXPLAIN ANALYZE before every new query
--   - Test on staging DB first (PORT 5433)
--   - Minimum 1000 rows test data
--
--   ## Rules
--   - NEVER drop tables without /safety confirm
--   - Always create index sebelum query production
--   - Backup dulu sebelum migration

-- Step 5.3: Setup hooks (optional — buat automation)
--   Buat folder ~/.claude/hooks/
--   Contoh hook pre-edit (validator):
--
--   #!/bin/bash
--   # ~/.claude/hooks/pre-edit.sh
--   if echo "$CLAUDE_EDIT_FILE" | grep -q "production"; then
--     echo "⚠️  WARNING: Editing production file!"
--     echo "Use /safety to confirm"
--     exit 1
--   fi

-- Step 5.4: Jenis hooks yang tersedia
--   pre-edit       → jalan sebelum Claude edit file
--   post-edit      → jalan setelah file di-edit (auto-lint, format)
--   pre-commit     → sebelum git commit (run tests)
--   post-commit    → setelah commit (notify team, trigger CI)
--   pre-prompt     → sebelum user prompt diproses (inject context)
--   session-start  → pas session dimulai (load project config)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: SKILLS — Pre-built agent behaviors                            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Skills adalah file .md yang ngasih Claude instruksi spesifik buat task
 * tertentu. Bisa custom-built atau dari registry skills.sh.
 */

-- Step 6.1: Install grilling skill (stress-test rencana)
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling

-- Step 6.2: Install diagnose skill (disciplined debugging loop)
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose

-- Step 6.3: Install handoff skill (compact conversation for another agent)
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 6.4: Cara pakai skills (di dalam Claude session)
--   "Here's my database migration plan — grill me on it"
--   "Diagnose why this query is slow"
--   "Handoff this session to another agent"

-- Step 6.5: Cek skills yang terinstall
-- $ ls ~/.claude/skills/

-- Step 6.6: Bikin custom skill sendiri
--   Buat file .md dengan format:
--
--   # Skill Name
--   Description: What this skill does
--   Trigger: When to activate this skill
--
--   ## Instructions
--   Step-by-step instructions for Claude...

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
-- ============================================================================

-- [ ] Node.js 22              → node --version
-- [ ] Claude Code binary      → claude --version
-- [ ] Anthropic account        → claude (harus login)
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] MCP servers             → ls ~/.claude/mcp.json
-- [ ] CLAUDE.md               → ls ~/SQL-QUERY-JOB/CLAUDE.md
-- [ ] Grilling skill          → ls ~/.claude/skills/ | grep grill

-- ============================================================================
-- SLASH COMMANDS — Dalam Claude Code session
-- ============================================================================

-- /help                → list semua commands
-- /model <name>        → ganti model (claude-sonnet-4, openai/deepseek-chat)
-- /init                → generate CLAUDE.md dari codebase
-- /clear               → reset conversation
-- /compact             → compress context window
-- /doctor              → diagnostics
-- /context             → cek context window usage
-- /mcp list            → lihat MCP servers
-- /add-dir <path>      → tambah folder ke context
-- /permissions         → manage safety/permissions
-- /review              → code review current changes
-- /cost                → cek token usage & cost

-- ============================================================================
-- DAILY WORKFLOW — Contoh session Claude Code
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB
-- $ claude

-- # Di dalam Claude Code session:
-- /model openai/deepseek-chat                        -- switch ke DeepSeek (opsional)
-- "Jelaskan struktur database project ini"
-- "Cari semua query yang pake SELECT * dan ganti"
-- "Tambah index di kolom yang sering di-join"
-- /compact                                           -- hemat context
-- "Grill me on indexing strategy buat vu_kasir"

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: claude: command not found
-- Fix:     $ echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
--          $ source ~/.bashrc

-- Problem: npm install gagal (permission error)
-- Fix:     $ mkdir ~/.npm-global
--          $ npm config set prefix '~/.npm-global'
--          $ echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc

-- Problem: Authentication failed (Anthropic)
-- Fix:     $ claude logout
--          $ claude login

-- Problem: MCP server ga connect
-- Fix:     $ claude doctor
--          Cek log: ~/.claude/logs/

-- Problem: "No available models" (DeepSeek not showing)
-- Fix:     Pastiin environment variables ke-set:
--          $ echo $OPENAI_API_KEY
--          $ echo $OPENAI_API_BASE
--          Source ulang ~/.bashrc

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- $ npm uninstall -g @anthropic-ai/claude-code
-- $ rm -rf ~/.claude

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Claude Code docs:    https://docs.anthropic.com/en/docs/claude-code
-- Claude Code GitHub:  https://github.com/anthropics/claude-code
-- MCP docs:            https://modelcontextprotocol.io
-- MCP servers:         https://github.com/modelcontextprotocol/servers
-- DeepSeek API docs:   https://api-docs.deepseek.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/
-- Anthropic console:   https://console.anthropic.com/

-- ============================================================================
-- EOF — Selamat ngoding dengan Claude Code! 🤖
-- ============================================================================
