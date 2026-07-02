-- ============================================================================
-- Codex CLI Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- Complete step-by-step guide to install OpenAI Codex CLI MANUALLY.
-- No shell scripts — just copy-paste each block.
-- Run commands one by one in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: Codex CLI binary        → the agent (standalone, no Node.js needed)
--   Layer 2: DeepSeek provider       → cheapest model, 500M free tokens
--   Layer 3: Sandbox modes           → safety: elevated vs unelevated
--   Layer 4: CI/CD integration       → `codex exec` for automation
--   Layer 5: Skills + MCP            → pre-built behaviors & tools
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES — Make sure environment is ready                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (or macOS 13+)
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - OpenAI account: Plus ($20/mo), Pro, Team, Edu, or Enterprise
 *     OR OpenAI API key (billed to platform account)
 *
 * WHY CODEX CLI?
 *   - Standalone binary — NO Node.js, NO Python, NO dependencies!
 *   - Open-source: github.com/openai/codex
 *   - Sandbox: auto-confirm low-risk, ask on high-risk
 *   - `codex exec`: headless mode for CI/CD
 *   - Polished Terminal UI (TUI)
 */

-- Check OS
-- $ uname -a

-- Check RAM — minimum 4GB
-- $ free -h

-- Check disk — ~1GB free
-- $ df -h ~

-- Install curl & git if not available
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CODEX CLI — Install agent (standalone binary)                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI is OpenAI's open-source terminal coding agent.
 * Latest: v0.142.3 (June 2026)
 *
 * Docs:    https://github.com/openai/codex
 */

-- Step 1.1: Install Codex CLI (recommended — official installer)
-- $ curl -fsSL https://chatgpt.com/codex/install.sh | sh

-- Alternative: npm (if Node.js already installed)
-- $ npm install -g @openai/codex

-- Alternative: Homebrew (macOS)
-- $ brew install --cask codex

-- Step 1.2: Verify installation
-- $ codex --version
--   Expected: codex-cli 0.142.3 (or later)

-- Step 1.3: Launch Codex CLI (first run — authentication)
-- $ cd ~/SQL-QUERY-JOB
-- $ codex
--   → Select "Sign in with ChatGPT" (browser OAuth)
--   → OR "Sign in with API Key" (headless/CI)

-- Step 1.4: Basic commands
-- $ codex                                       -- interactive TUI
-- $ codex "explain this codebase"               -- direct prompt
-- $ codex exec "fix the CI failure"             -- headless/CI mode
-- $ codex --model gpt-4o "refactor this"        -- specific model

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Cheapest model for Codex CLI               ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Codex CLI natively uses OpenAI models (GPT-4o, o3, o4-mini).
 * BUT supports OpenAI-compatible providers — including DeepSeek!
 *
 * Why DeepSeek?
 *   - Cheapest: $0.14/$0.28 per 1M tokens
 *   - 500M tokens FREE on signup — no OpenAI billing needed
 *   - OpenAI-compatible API → Codex CLI directly supports it
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Get API key
--   Open: https://platform.deepseek.com/api_keys → Sign up (free) → copy key

-- Step 2.2: Save permanently in ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 2.3: Set DeepSeek as provider in Codex CLI
-- $ export OPENAI_API_KEY="$DEEPSEEK_API_KEY"
-- $ export OPENAI_API_BASE="https://api.deepseek.com/v1"
--
--   Make permanent:
-- $ echo 'export OPENAI_API_KEY="$DEEPSEEK_API_KEY"' >> ~/.bashrc
-- $ echo 'export OPENAI_API_BASE="https://api.deepseek.com/v1"' >> ~/.bashrc

-- Step 2.4: Verify API key
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 2.5: How to use DeepSeek
-- $ codex --model deepseek-chat "Explain this codebase"
-- $ codex --model deepseek-v4-flash "Refactor this query"
--
--   OR switch model mid-session: /model deepseek-chat

-- Step 2.6: DeepSeek models reference
--   deepseek-chat (v3)       → complex tasks                  ($0.27/$1.10)
--   deepseek-v4-flash        → fast, cheap, daily use          ($0.14/$0.28)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: SANDBOX MODES — Safety first, no surprises                     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: Check sandbox mode
-- $ codex --sandbox status

-- Step 3.2: Set sandbox mode
-- $ codex --sandbox unelevated    → ask before executing (RECOMMENDED)
-- $ codex --sandbox elevated      → auto-approve all (careful!)
-- $ codex --sandbox safe          → read-only, cannot edit files

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: CI/CD + CODEX.MD                                              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: `codex exec` — headless mode for CI/CD
-- $ codex exec "Fix all TypeScript errors in src/"
-- $ codex exec --approve "Run database migration and verify"

-- Step 4.2: GitHub Actions example
--   - uses: actions/checkout@v4
--   - run: curl -fsSL https://chatgpt.com/codex/install.sh | sh
--   - run: codex exec --approve "Review this PR for bugs"
--     env:
--       OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

-- Step 4.3: Generate CODEX.md — project context
-- $ cd ~/SQL-QUERY-JOB
-- $ codex
--   → /init (scans codebase → generates CODEX.md)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS + MCP                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install skills
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 5.2: MCP config — ~/.codex/mcp.json
--   {
--     "mcpServers": {
--       "grep": {
--         "command": "npx",
--         "args": ["-y", "@anthropic/mcp-server-grep"]
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

-- [ ] Codex CLI binary        → codex --version
-- [ ] Authenticated           → codex (must login)
-- [ ] DeepSeek key            → echo $OPENAI_API_KEY
-- [ ] Sandbox mode            → codex --sandbox status

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /sandbox, /clear, /context, /cost, /diff, /undo, /init

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: codex: command not found
-- Fix:     Reinstall: $ curl -fsSL https://chatgpt.com/codex/install.sh | sh

-- Problem: Authentication loop
-- Fix:     $ rm -rf ~/.codex/auth.json && codex

-- Problem: "Model not available" (DeepSeek)
-- Fix:     Verify $ echo $OPENAI_API_BASE (should be https://api.deepseek.com/v1)

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Codex CLI GitHub:    https://github.com/openai/codex
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Happy coding with Codex CLI! 🚀
-- ============================================================================
