-- ============================================================================
-- Aider Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- This file is a complete, step-by-step guide to install Aider
-- and the recommended stack MANUALLY — no shell scripts, just copy-paste each block.
--
-- Each section is an SQL comment block. Run the commands inside one by one
-- in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Python via uv        → runtime requirement (no Node.js needed)
--   Layer 2: Aider install        → the agent itself
--   Layer 3: DeepSeek provider    → cheapest model, 500M free tokens
--   Layer 4: Multi-model config   → Claude, GPT, Gemini, Ollama, OpenRouter
--   Layer 5: Git-native workflow  → auto-commit, diff, undo, branching
--   Layer 6: Skills + advanced    → architect mode, voice, linting
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (atau macOS, Windows)
 *   - Python 3.9+ (check: python3 --version)
 *   - Git (sudo apt-get install -y git)
 *   - API key untuk model yang dipake (DeepSeek, OpenAI, Anthropic, dll)
 *
 * KENAPA AIDER?
 *   - 100+ model support! (Claude, GPT, DeepSeek, Gemini, local Ollama)
 *   - Git-native: auto-commit, diff, undo, branching
 *   - Tiered models: model mahal buat task kompleks, model murah buat sisanya
 *   - Architect mode: plan dulu sebelum edit
 *   - Open-source (Apache 2.0) — ga ada subscription fee
 *   - Bawa API key sendiri — full control cost
 *
 * GitHub:  https://github.com/aider-ai/aider
 * Docs:    https://aider.chat/docs
 */

-- Cek OS
-- $ uname -a

-- Cek Python — harus 3.9+
-- $ python3 --version
--   Kalo belom ada: sudo apt-get install -y python3 python3-pip python3-venv

-- Cek Git
-- $ git --version
--   Kalo belom ada: sudo apt-get install -y git

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- $ free -h

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: PYTHON ENVIRONMENT — Setup Python & package manager            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider butuh Python 3.9+. Pake uv (recommended) atau pip.
 * uv = next-gen Python package manager — 10-100x lebih cepat dari pip.
 */

-- Step 1.1: Install uv (recommended package manager)
-- $ curl -LsSf https://astral.sh/uv/install.sh | sh
-- $ source ~/.bashrc
--   Atau:
-- $ python3 -m pip install uv

-- Step 1.2: Install Python 3.12 via uv (kalo Python lo di bawah 3.9)
-- $ uv python install 3.12
-- $ uv python pin 3.12

-- Step 1.3: Alternatif — pake pip + venv (kalo ga mau uv)
-- $ mkdir ~/aider-project
-- $ cd ~/aider-project
-- $ python3 -m venv aider-env
-- $ source aider-env/bin/activate

-- Step 1.4: Verifikasi Python
-- $ python3 --version         -- harus 3.9+

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: AIDER — Install AI pair programming agent                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider = AI pair programming di terminal. Kerja langsung di codebase lo
 * dengan Git integration — baca file, edit, commit otomatis.
 */

-- Step 2.1: Install Aider via uv (RECOMMENDED)
-- $ uv tool install --force --python python3.12 --with pip aider-chat@latest

-- Step 2.2: Alternatif — install via pip
-- $ python3 -m pip install -U --upgrade-strategy only-if-needed aider-chat

-- Step 2.3: Alternatif — install via pipx (best isolation)
-- $ python3 -m pip install pipx
-- $ pipx install aider-chat

-- Step 2.4: Verifikasi instalasi
-- $ aider --version
--   Expected: aider 0.x.x

-- Step 2.5: First run
-- $ cd ~/SQL-QUERY-JOB
-- $ git init              -- Aider BUTUH git repo (kalo belom)
-- $ aider
--   → Aider bakal scan codebase & build repo map
--   → Masuk ke interactive prompt: aider >

-- Step 2.6: Basic commands
-- $ aider                                              -- interactive mode
-- $ aider --message "Explain this codebase"             -- one-shot
-- $ aider --model deepseek --message "Refactor query"   -- dengan model

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Best budget model buat Aider             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider support 100+ models — termasuk DeepSeek! Ini provider TERMURAH
 * buat daily coding. Bisa digabung dengan model mahal buat task kompleks
 * (tiered: DeepSeek buat simple tasks, Claude/GPT buat complex reasoning).
 *
 * Kenapa DeepSeek?
 *   - Termurah: $0.14/$0.28 per 1M token (input/output)
 *   - 500M token GRATIS pas signup
 *   - Support native di Aider → ga perlu custom config rumit
 *   - deepseek-chat: performance setara GPT-4o di banyak task
 *
 * Docs:     https://api-docs.deepseek.com/
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

-- Step 3.4: Cara paling simpel — langsung run pake DeepSeek
-- $ aider --model deepseek
--   Aider auto-set API base & key. Ga perlu config.
--
--   ATAU explicit:
-- $ aider --model deepseek/deepseek-chat
-- $ aider --model deepseek/deepseek-v4-flash

-- Step 3.5: Tiered models — kombinasi DeepSeek + model mahal
--   Model mahal buat task kompleks (architect/edit),
--   DeepSeek buat task ringan (ask, comment, simple edits):
--
-- $ aider --model deepseek --weak-model deepseek
--   → Semua pake DeepSeek (paling hemat)
--
-- $ aider --model claude-sonnet-4-20250514 --weak-model deepseek/deepseek-chat
--   → Claude buat edit kompleks, DeepSeek buat sisanya (seimbang)

-- Step 3.6: Persistent config — biar ga ketik ulang
--   Bikin file ~/.aider.conf.yml:
--
--   model: deepseek/deepseek-chat
--   weak-model: deepseek/deepseek-v4-flash
--
--   ATAU environment variable:
-- $ echo 'export AIDER_MODEL="deepseek/deepseek-chat"' >> ~/.bashrc
-- $ echo 'export AIDER_WEAK_MODEL="deepseek/deepseek-v4-flash"' >> ~/.bashrc

-- Step 3.7: Model DeepSeek yang tersedia (referensi)
--   deepseek-chat (v3)       → reasoning bagus, standar       ($0.27/$1.10)
--   deepseek-v4-flash        → cepat, murah, daily use         ($0.14/$0.28)
--   deepseek-reasoner        → deep thinking, math/logic       (price TBD)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: MULTI-MODEL CONFIG — 100+ models, 1 tool                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider bisa pake SEMUA model ini. Bawa API key sendiri.
 * Bisa switch mid-session dengan /model.
 */

-- Step 4.1: API keys setup (set sesuai provider yang lu punya)
-- $ echo 'export OPENAI_API_KEY="sk-..."' >> ~/.bashrc
-- $ echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-..."' >> ~/.bashrc
--   Atau bikin .env file di project:
--   OPENAI_API_KEY=sk-...
--   ANTHROPIC_API_KEY=sk-ant-...
--   DEEPSEEK_API_KEY=sk-...

-- Step 4.2: Model switch mid-session
--   aider > /model deepseek/deepseek-chat
--   aider > /model claude-sonnet-4-20250514
--   aider > /model o3-mini
--   aider > /model openrouter/anthropic/claude-opus-4.6

-- Step 4.3: Provider shortcuts (built-in Aider)
--   aider --model deepseek              → deepseek/deepseek-chat
--   aider --model sonnet                → claude-sonnet-4-20250514
--   aider --model opus                  → claude-opus-4-20250514
--   aider --model o3-mini               → openai/o3-mini
--   aider --model gpt-4o                → openai/gpt-4o
--   aider --model gemini                → gemini/gemini-2.5-pro

-- Step 4.4: Local models via Ollama (GRATIS, 100% private)
-- $ ollama pull qwen3-coder:30b-a3b     -- model coding lokal
-- $ aider --model ollama/qwen3-coder:30b-a3b
--   → Jalan di GPU lokal, ga perlu API key, no internet needed

-- Step 4.5: OpenRouter (akses semua model dari 1 API key)
-- $ echo 'export OPENROUTER_API_KEY="sk-or-..."' >> ~/.bashrc
-- $ aider --model openrouter/anthropic/claude-opus-4.6
--   → 1 key, semua provider. Bayar per token.

-- Step 4.6: YAML config persistent (~/.aider.conf.yml)
--   model: deepseek/deepseek-chat
--   weak-model: deepseek/deepseek-v4-flash
--   edit-format: diff
--   auto-lint: true
--   auto-commits: true
--   dark-mode: true
--   map-tokens: 2048

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: GIT-NATIVE WORKFLOW — Auto-commit, diff, undo, branching      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider adalah AI agent dengan Git integration TERBAIK.
 * Setiap edit langsung di-commit secara otomatis dengan descriptive message.
 */

-- Step 5.1: First run — Aider butuh git repo
-- $ cd ~/SQL-QUERY-JOB
-- $ git init                          -- kalo belom git repo
-- $ git add -A && git commit -m "initial"   -- kalo belom ada commit

-- Step 5.2: Aider auto-commit workflow
--   aider > "Refactor this query to use CTE instead of subquery"
--   → Aider edit file, show diff
--   → Approval: [y] Accept  [n] Reject  [e] Edit
--   → Terima → auto-commit dengan message descriptive:
--     "Refactored payment query to use CTE for better readability"

-- Step 5.3: Git commands di dalam Aider
--   /add file.sql           → tambah file ke context (editable)
--   /read docs.md           → tambah file READONLY (hemat token)
--   /drop file.sql          → remove dari context
--   /undo                   → undo last AI edit (git revert)
--   /commit                 → manual commit
--   /diff                   → lihat uncommitted changes
--   /git log --oneline      → lihat riwayat commit (via /run)
--   /run git branch         → cek branch

-- Step 5.4: Branching strategy
-- $ git checkout -b feature/new-query
-- $ aider
--   → Kerja di branch baru, aman. Merge kalo udah ok.

-- Step 5.5: /run — eksekusi command dari dalam Aider
--   aider > /run psql -d mydb -f test_query.sql
--   aider > /run npm test
--   aider > /run git status

-- Step 5.6: /test — auto-fix failed tests
--   aider > /test pytest
--   → Jalanin tests, kalo fail → Aider auto-fix error
--   → Loop sampe semua pass atau lo stop

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: ADVANCED FEATURES — Architect, voice, lint, browser            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Architect mode — plan dulu sebelum edit
-- $ aider --chat-mode architect
--   aider > "Design a new indexing strategy for the billing system"
--   → Aider cuma propose plan, GA AKAN edit file
--   → Review, approve, baru switch ke edit mode:
--   aider > /chat-mode code

-- Step 6.2: Chat mode comparison
--   /chat-mode code         → edit files (default)
--   /chat-mode architect    → plan & design only, NO edits
--   /chat-mode ask          → tanya-tanya, NO edits, hemat token

-- Step 6.3: Auto-linting — fix formatting errors otomatis
--   ~/.aider.conf.yml:
--   auto-lint: true
--   lint-cmd: "sqlfluff lint {file}"      -- linter SQL
--
--   Aider bakal auto-run linter setelah setiap edit,
--   dan FIX otomatis kalo ada error.

-- Step 6.4: Voice input (butuh PortAudio)
-- $ sudo apt-get install -y portaudio19-dev
-- $ aider --voice
--   → Speak commands instead of typing

-- Step 6.5: Browser mode (experimental)
-- $ aider --browser
--   → Web-based chat UI instead of terminal

-- Step 6.6: Custom edit formats
--   edit-format: diff        → unified diff (default, recommended)
--   edit-format: whole       → rewrite entire file (buat file kecil)
--   edit-format: udiff       → unified diff with context

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
-- ============================================================================

-- [ ] Python 3.9+             → python3 --version
-- [ ] uv installed            → uv --version
-- [ ] Aider installed         → aider --version
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] Git repo initialized    → git status (di project)
-- [ ] Config file             → ls ~/.aider.conf.yml

-- ============================================================================
-- IN-SESSION COMMANDS — Dalam Aider prompt (aider >)
-- ============================================================================

-- /help                → list semua commands
-- /model <name>        → switch model (deepseek, sonnet, o3-mini, ollama/...)
-- /chat-mode <mode>    → code | architect | ask
-- /add <file>          → tambah file ke editable context
-- /read <file>         → tambah file READONLY (hemat token)
-- /drop <file>         → remove file dari context
-- /undo                → undo last AI edit (git revert)
-- /diff                → lihat uncommitted changes
-- /commit              → manual git commit
-- /run <command>       → execute shell command
-- /test <command>      → run tests + auto-fix failures
-- /clear               → reset chat history
-- /tokens              → cek token usage
-- /voice               → toggle voice input
-- /map                 → cek repo map
-- /web                 → web search (butuh API key)

-- ============================================================================
-- DAILY WORKFLOW — Contoh session Aider
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB
-- $ aider --model deepseek --weak-model deepseek

-- # Di dalam Aider session:
-- aider > /add vu_kasir_belum_lunas.sql     -- tambah file ke context
-- aider > /read schema.sql                  -- readonly context (hemat token)
-- aider > /chat-mode architect              -- plan dulu
-- "Design indexing strategy for the payment views"
-- aider > /chat-mode code                   -- baru eksekusi
-- "Implement the indexing plan we discussed"
-- aider > /test psql -d testdb -f test.sql  -- test + auto-fix

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: aider: command not found
-- Fix:     Pastiin di PATH:
--          $ uv tool list | grep aider
--          $ echo $PATH | grep .local/bin

-- Problem: "Git repo required" error
-- Fix:     $ git init
--          $ git add -A && git commit -m "initial commit"

-- Problem: "Unknown model" warning
-- Fix:     Safe to ignore — model lu tetep jalan. Aider cuma
--          ngecek internal DB, bukan berarti model ga support.

-- Problem: pip install lambat / stuck di "Downloading cpython"
-- Fix:     Install Python 3.12 manual dulu:
--          $ sudo apt-get install -y python3.12 python3.12-venv
--          $ python3.12 -m pip install aider-chat

-- Problem: SSL certificate errors
-- Fix:     $ pip install --trusted-host pypi.org \
--              --trusted-host files.pythonhosted.org aider-chat

-- Problem: DeepSeek API error (rate limit)
-- Fix:     Cek usage di https://platform.deepseek.com/usage
--          Top up kalo abis (masih murah banget)

-- ============================================================================
-- COST COMPARISON — Per 1M token (Juli 2026)
-- ============================================================================

-- Model                  Input     Output    Buat apa?
-- ────────────────────────────────────────────────────
-- deepseek-v4-flash      $0.14     $0.28     Daily coding (RECOMMENDED)
-- deepseek-chat (v3)     $0.27     $1.10     Complex reasoning
-- GPT-4o                 $2.50     $10.00    Best quality
-- Claude Sonnet 4        $3.00     $15.00    Code generation
-- Gemini 2.5 Flash       FREE*     FREE*     Free tier (limited)
-- Ollama (local)         $0        $0        Private, offline
--
-- *Gemini free tier: 60 req/min, 1000 req/day

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- $ uv tool uninstall aider-chat
--   ATAU:
-- $ pip uninstall aider-chat
-- $ rm -f ~/.aider.conf.yml

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Aider website:       https://aider.chat
-- Aider GitHub:        https://github.com/aider-ai/aider
-- Aider docs:          https://aider.chat/docs
-- Aider models:        https://aider.chat/docs/llms.html
-- DeepSeek API docs:   https://api-docs.deepseek.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Ollama:              https://ollama.com
-- OpenRouter:          https://openrouter.ai

-- ============================================================================
-- EOF — Selamat pair programming dengan Aider! 🐍
-- ============================================================================
