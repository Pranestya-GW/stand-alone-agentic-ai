-- ============================================================================
-- Aider Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- Complete step-by-step guide to install Aider MANUALLY.
-- No shell scripts — just copy-paste each block.
-- Run commands one by one in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Python via uv        → runtime (no Node.js needed)
--   Layer 2: Aider install        → the agent itself
--   Layer 3: DeepSeek provider    → cheapest model, 500M free
--   Layer 4: Multi-model config   → Claude, GPT, Gemini, Ollama, OpenRouter
--   Layer 5: Git-native workflow  → auto-commit, diff, undo, branching
--   Layer 6: Advanced features    → architect mode, voice, linting
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Make sure environment is ready                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (or macOS, Windows)
 *   - Python 3.9+ (check: python3 --version)
 *   - Git (sudo apt-get install -y git)
 *   - API key for your chosen model (DeepSeek, OpenAI, Anthropic, etc.)
 *
 * WHY AIDER?
 *   - 100+ model support! (Claude, GPT, DeepSeek, Gemini, local Ollama)
 *   - Git-native: auto-commit, diff, undo, branching
 *   - Tiered models: expensive model for complex tasks, cheap for simple ones
 *   - Architect mode: plan before editing
 *   - Open-source (Apache 2.0) — no subscription fee
 *   - Bring your own API key — full cost control
 *
 * GitHub:  https://github.com/aider-ai/aider
 * Docs:    https://aider.chat/docs
 */

-- Check OS
-- $ uname -a
-- Check Python — must be 3.9+
-- $ python3 --version
-- Check Git
-- $ git --version

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: PYTHON ENVIRONMENT                                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * uv = next-gen Python package manager — 10-100x faster than pip.
 */

-- Step 1.1: Install uv (recommended)
-- $ curl -LsSf https://astral.sh/uv/install.sh | sh
-- $ source ~/.bashrc

-- Step 1.2: Install Python 3.12 via uv (if Python < 3.9)
-- $ uv python install 3.12

-- Step 1.3: Alternative — pip + venv
-- $ python3 -m venv aider-env && source aider-env/bin/activate

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: AIDER — Install AI pair programming agent                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 2.1: Install Aider via uv (RECOMMENDED)
-- $ uv tool install --force --python python3.12 --with pip aider-chat@latest

-- Alternative: pip
-- $ python3 -m pip install -U --upgrade-strategy only-if-needed aider-chat

-- Alternative: pipx (best isolation)
-- $ python3 -m pip install pipx && pipx install aider-chat

-- Step 2.2: Verify
-- $ aider --version

-- Step 2.3: First run
-- $ cd ~/SQL-QUERY-JOB && git init && aider
--   → Aider scans codebase & builds repo map → interactive prompt: aider >

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Best budget model for Aider                ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Aider supports DeepSeek NATIVELY. Simplest setup of all agents!
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 3.1: Get API key → platform.deepseek.com/api_keys → copy key

-- Step 3.2: Save permanently
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-key"' >> ~/.bashrc && source ~/.bashrc

-- Step 3.3: Easiest way — just run with DeepSeek
-- $ aider --model deepseek
--   Aider auto-detects API key & config. No setup needed.

-- Step 3.4: Tiered models — cheap + powerful
-- $ aider --model deepseek/deepseek-chat --weak-model deepseek/deepseek-v4-flash

-- Step 3.5: Persistent config (~/.aider.conf.yml)
--   model: deepseek/deepseek-chat
--   weak-model: deepseek/deepseek-v4-flash
--   auto-commits: true

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: MULTI-MODEL CONFIG — 100+ models, 1 tool                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: Provider shortcuts (built-in)
--   aider --model deepseek              → deepseek/deepseek-chat
--   aider --model sonnet                → claude-sonnet-4
--   aider --model o3-mini               → openai/o3-mini
--   aider --model gemini                → gemini/gemini-2.5-pro
--   aider --model ollama/qwen3-coder    → local model (FREE!)

-- Step 4.2: API keys — set per provider
-- $ echo 'export OPENAI_API_KEY="sk-..."' >> ~/.bashrc
-- $ echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
--   Or create .env file in project directory

-- Step 4.3: Model switch mid-session
--   aider > /model deepseek/deepseek-chat
--   aider > /model claude-sonnet-4-20250514
--   aider > /model openrouter/anthropic/claude-opus-4.6

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: GIT-NATIVE WORKFLOW                                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Core commands
--   /add file.sql           → add file to editable context
--   /read docs.md           → read-only context (save tokens)
--   /drop file.sql          → remove from context
--   /undo                   → undo last AI edit (git revert)
--   /diff                   → view uncommitted changes
--   /commit                 → manual git commit
--   /run pytest             → execute shell command
--   /test pytest            → run tests + auto-fix failures

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: ADVANCED FEATURES                                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Architect mode — plan before edit
-- $ aider --chat-mode architect
--   → Proposes plan only, NO file edits → /chat-mode code → execute

-- Step 6.2: Chat modes
--   /chat-mode code         → edit files (default)
--   /chat-mode architect    → plan only, no edits
--   /chat-mode ask          → questions only, no edits (save tokens)

-- Step 6.3: Auto-linting
--   ~/.aider.conf.yml: auto-lint: true

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Python 3.9+             → python3 --version
-- [ ] Aider installed         → aider --version
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] Git repo initialized    → git status
-- [ ] Config file             → ls ~/.aider.conf.yml

-- ============================================================================
-- IN-SESSION COMMANDS
-- ============================================================================

-- /help, /model, /chat-mode, /add, /read, /drop, /undo, /diff, /commit
-- /run, /test, /clear, /tokens, /voice, /map, /web

-- ============================================================================
-- COST COMPARISON — Per 1M tokens (July 2026)
-- ============================================================================

-- Model                  Input     Output
-- deepseek-v4-flash      $0.14     $0.28     (RECOMMENDED daily)
-- deepseek-chat (v3)     $0.27     $1.10     (Complex tasks)
-- GPT-4o                 $2.50     $10.00
-- Claude Sonnet 4        $3.00     $15.00
-- Gemini 2.5 Flash       FREE*     FREE*
-- Ollama (local)         $0        $0         (Private, offline)
--
-- *Gemini free tier: 60 req/min, 1,000 req/day

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: aider: command not found
-- Fix:     $ uv tool list | grep aider  OR  check PATH

-- Problem: "Git repo required"
-- Fix:     $ git init && git add -A && git commit -m "initial"

-- Problem: "Unknown model" warning
-- Fix:     Safe to ignore — your model still works fine

-- Problem: DeepSeek API rate limit
-- Fix:     Check usage at https://platform.deepseek.com/usage

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Aider website:       https://aider.chat
-- Aider docs:          https://aider.chat/docs
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Ollama:              https://ollama.com

-- ============================================================================
-- EOF — Happy pair programming with Aider! 🐍
-- ============================================================================
