-- ============================================================================
-- Codex CLI Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- This file is a complete, step-by-step guide to install OpenAI Codex CLI
-- and the recommended stack MANUALLY — no shell scripts, just copy-paste each block.
--
-- Each section is an SQL comment block. Run the commands inside one by one
-- in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Codex CLI binary        → the agent itself (standalone, no Node.js)
--   Layer 2: DeepSeek provider       → cheapest model, 500M free tokens
--   Layer 3: Sandbox modes           → safety: elevated vs unelevated
--   Layer 4: CI/CD integration       → `codex exec` for automation
--   Layer 5: Skills + MCP            → pre-built behaviors & tools
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (atau Windows native, macOS 13+)
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - OpenAI account: Plus ($20/mo), Pro, Team, Edu, atau Enterprise
 *     ATAU OpenAI API key (billed to platform account)
 *
 * KENAPA CODEX CLI?
 *   - Standalone binary — NO Node.js, NO Python, NO dependencies!
 *   - Open-source: github.com/openai/codex
 *   - Sandbox: auto-confirm low-risk, tanya high-risk
 *   - `codex exec`: headless mode buat CI/CD
 *   - TUI (Terminal UI) yang polished
 */

-- Cek OS — Linux/WSL, macOS, atau Windows
-- $ uname -a

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- $ free -h

-- Cek disk — butuh ~1GB free
-- $ df -h ~

-- Install curl & git kalo belum ada
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CODEX CLI — Install agent (standalone binary)                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI adalah open-source terminal coding agent dari OpenAI.
 * Baca codebase, propose multi-file changes, eksekusi commands.
 *
 * Docs:    https://github.com/openai/codex
 * Latest:  v0.142.3 (Juni 2026)
 */

-- Step 1.1: Install Codex CLI (recommended — official installer)
-- $ curl -fsSL https://chatgpt.com/codex/install.sh | sh

-- Alternatif: npm (kalo udah ada Node.js)
-- $ npm install -g @openai/codex

-- Alternatif: npm versi spesifik
-- $ npm install -g @openai/codex@0.142.3

-- Alternatif: Homebrew (macOS)
-- $ brew install --cask codex

-- Alternatif: Manual binary download dari GitHub Releases
--   Buka: https://github.com/openai/codex/releases
--   Download binary sesuai platform, chmod +x, pindahin ke PATH

-- Step 1.2: Verifikasi instalasi
-- $ codex --version
--   Expected: codex-cli 0.142.3 (or later)

-- Step 1.3: Launch Codex CLI (first run — authentication)
-- $ cd ~/SQL-QUERY-JOB
-- $ codex
--   → Pilih "Sign in with ChatGPT" (browser OAuth)
--   → ATAU "Sign in with API Key" (headless/CI)

-- Step 1.4: Basic commands reference
-- $ codex                                       -- interactive TUI mode
-- $ codex "explain this codebase"               -- langsung prompt
-- $ codex exec "fix the CI failure"             -- headless/CI mode
-- $ codex --model gpt-4o "refactor this"        -- pakai model spesifik

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Model termurah buat Codex CLI              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI native-nya pake OpenAI models (GPT-4o, o3, o4-mini).
 * TAPI bisa pake OpenAI-compatible providers — termasuk DeepSeek!
 *
 * Kenapa DeepSeek?
 *   - Termurah: $0.14/$0.28 per 1M token (input/output)
 *   - 500M token GRATIS pas signup — ga perlu bayar OpenAI
 *   - deepseek-v4-flash: cepat + bagus buat daily coding
 *   - OpenAI-compatible API → Codex CLI langsung support
 *
 * Docs:     https://api-docs.deepseek.com/
 * API Base: https://api.deepseek.com/v1
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys
--   Sign up (gratis, ga perlu kartu kredit) → copy API key (format: sk-...)

-- Step 2.2: Simpan permanent di ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 2.3: Set DeepSeek sebagai provider di Codex CLI
-- $ export OPENAI_API_KEY="$DEEPSEEK_API_KEY"
-- $ export OPENAI_API_BASE="https://api.deepseek.com/v1"

--   Biar permanen, tambahin ke ~/.bashrc:
-- $ echo 'export OPENAI_API_KEY="$DEEPSEEK_API_KEY"' >> ~/.bashrc
-- $ echo 'export OPENAI_API_BASE="https://api.deepseek.com/v1"' >> ~/.bashrc

-- Step 2.4: Verifikasi API key jalan
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 2.5: Cara pakai DeepSeek di Codex CLI
-- $ codex --model deepseek-chat "Jelaskan codebase ini"
-- $ codex --model deepseek-v4-flash "Refactor query ini"
--
--   ATAU ganti model mid-session:
--   /model deepseek-chat

-- Step 2.6: Model DeepSeek yang bisa dipake (referensi)
--   deepseek-chat (v3)       → reasoning bagus, task kompleks    ($0.27/$1.10)
--   deepseek-v4-flash        → cepat, murah, daily use           ($0.14/$0.28)
--   deepseek-reasoner        → deep thinking, math/logic         (price TBD)

-- Step 2.7: Cara balik ke OpenAI models (kalo butuh)
--   Hapus/unset OPENAI_API_BASE:
-- $ unset OPENAI_API_BASE
--   Atau set ke API key OpenAI:
-- $ export OPENAI_API_KEY="sk-your-openai-key"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: SANDBOX MODES — Safety first, no surprises                     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI punya 3 sandbox modes buat kontrol seberapa otonom agent:
 *
 *   elevated    → auto-approve semua command (risky — buat trusted env)
 *   unelevated  → tanya konfirmasi buat setiap command (default)
 *   safe        → block SEMUA command berbahaya, readonly
 *
 * Untuk task coding normal, unelevated udah cukup.
 */

-- Step 3.1: Cek sandbox mode sekarang
-- $ codex --sandbox status
--   Atau di dalam session: /sandbox

-- Step 3.2: Set sandbox mode
-- $ codex --sandbox unelevated    → tanya dulu sebelum execute (RECOMMENDED)
-- $ codex --sandbox elevated      → auto-approve semua (hati-hati!)
-- $ codex --sandbox safe          → readonly, ga bisa edit file

-- Step 3.3: Cara kerja sandbox unelevated
--   Codex bakal nampilin command yang mau dijalankan:
--   ┌─────────────────────────────────────────┐
--   │ ⚠️ Approve command?                      │
--   │                                          │
--   │ $ rm -rf node_modules && npm install     │
--   │                                          │
--   │ [y] Yes  [n] No  [a] Always  [d] Diff   │
--   └─────────────────────────────────────────┘

-- Step 3.4: Auto-approve safe commands (unelevated config)
--   Edit ~/.codex/config.json:
--   {
--     "auto_approve": ["npm test", "git status", "ls", "cat"]
--   }

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: `codex exec` — Headless mode buat CI/CD & automation           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * `codex exec` jalanin agent tanpa interactive TUI — cocok buat:
 *   - GitHub Actions / GitLab CI
 *   - Pre-commit hooks
 *   - Scheduled jobs (crontab)
 *   - Scripting & automation
 */

-- Step 4.1: Basic exec usage
-- $ codex exec "Fix all TypeScript errors in src/"
-- $ codex exec "Add unit tests for the new API endpoint"
-- $ codex exec "Update CHANGELOG.md based on git log"

-- Step 4.2: Exec dengan approval mode (CI/CD)
-- $ codex exec --approve "Run database migration and verify"
--   → --approve: auto-approve semua commands (buat CI)
--   → TANPA --approve: bakal minta konfirmasi (buat local dev)

-- Step 4.3: Exec dengan model spesifik
-- $ codex exec --model deepseek-chat "Explain this PR diff"
-- $ codex exec --model gpt-4o "Review this PR for security issues"

-- Step 4.4: GitHub Actions example (.github/workflows/codex-review.yml)
--   name: Codex Code Review
--   on: [pull_request]
--   jobs:
--     review:
--       runs-on: ubuntu-latest
--       steps:
--         - uses: actions/checkout@v4
--         - run: curl -fsSL https://chatgpt.com/codex/install.sh | sh
--         - run: codex exec --approve "Review this PR for bugs and security"
--           env:
--             OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

-- Step 4.5: Git hook example (.git/hooks/pre-commit)
--   #!/bin/bash
--   codex exec --approve "Check staged changes for common mistakes"
--   exit $?

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS + MCP — Extend Codex CLI capabilities                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install grilling skill (stress-test rencana)
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling

-- Step 5.2: Install diagnose skill (disciplined debugging)
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose

-- Step 5.3: Install handoff skill (compact conversation)
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 5.4: MCP servers support (via config)
--   Codex CLI support MCP. Tambahin ke ~/.codex/mcp.json:
--   {
--     "mcpServers": {
--       "grep": {
--         "command": "npx",
--         "args": ["-y", "@anthropic/mcp-server-grep"]
--       }
--     }
--   }

-- Step 5.5: Cara pakai skills di Codex CLI
--   "Grill me on this database migration plan"
--   "Diagnose why this index scan is slow"
--   "Handoff this debugging session to another agent"
--   "Search GitHub for best practices using grep"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
-- ============================================================================

-- [ ] Codex CLI binary        → codex --version
-- [ ] Authenticated           → codex (harus bisa login)
-- [ ] DeepSeek key            → echo $OPENAI_API_KEY
-- [ ] Sandbox mode            → codex --sandbox status
-- [ ] Skills                  → ls ~/.codex/skills/

-- ============================================================================
-- SLASH COMMANDS — Dalam Codex CLI session
-- ============================================================================

-- /help                → list semua commands
-- /model <name>        → ganti model (gpt-4o, deepseek-chat, o3-mini)
-- /sandbox             → cek/set sandbox mode
-- /clear               → reset conversation
-- /context             → cek context window usage
-- /cost                → cek token usage & cost
-- /diff                → lihat perubahan yang belum committed
-- /undo                → undo last AI edit
-- /init                → generate project config (CODEX.md)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  PROJECT CONFIG: CODEX.md — Ngajarin Codex tentang project lo           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step A: Generate CODEX.md otomatis
-- $ cd ~/SQL-QUERY-JOB
-- $ codex
--   → /init (scan codebase → generate CODEX.md)

-- Step B: Contoh isi CODEX.md manual
--   # SQL-QUERY-JOB Conventions
--
--   ## Tech Stack
--   - PostgreSQL 16, PL/pgSQL
--
--   ## Rules
--   - SQL keywords: UPPERCASE
--   - Never use SELECT *
--   - Always EXPLAIN ANALYZE before new query
--   - Add index before querying production

-- ============================================================================
-- DAILY WORKFLOW — Contoh session Codex CLI
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB
-- $ codex

-- # Di dalam Codex session:
-- /model deepseek-chat                              -- switch ke DeepSeek
-- "Jelaskan struktur database project ini"
-- "Cari semua query yang pake SELECT * dan ganti"
-- "Tambah index di kolom yang sering di-join"
-- "Grill me on indexing strategy buat vu_kasir_belum_lunas"

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: codex: command not found
-- Fix:     Install ulang:
--          $ curl -fsSL https://chatgpt.com/codex/install.sh | sh
--          ATAU cek PATH: echo $PATH | grep codex

-- Problem: Authentication loop (login terus-menerus)
-- Fix:     $ rm -rf ~/.codex/auth.json
--          $ codex (login ulang)

-- Problem: "Model not available" (DeepSeek ga muncul)
-- Fix:     Pastiin environment variables:
--          $ echo $OPENAI_API_BASE    → harus https://api.deepseek.com/v1
--          $ source ~/.bashrc

-- Problem: Sandbox elevated too risky
-- Fix:     $ codex --sandbox unelevated
--          Atau set default di ~/.codex/config.json

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- Official installer:
-- $ rm -rf ~/.codex
-- $ rm $(which codex)

-- npm:
-- $ npm uninstall -g @openai/codex

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Codex CLI GitHub:    https://github.com/openai/codex
-- Codex changelog:     https://developers.openai.com/codex/changelog/
-- Codex releases:      https://github.com/openai/codex/releases
-- DeepSeek API docs:   https://api-docs.deepseek.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Selamat ngoding dengan Codex CLI! 🚀
-- ============================================================================
