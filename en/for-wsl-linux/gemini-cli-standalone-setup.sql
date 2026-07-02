-- ============================================================================
-- Gemini CLI Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- Complete step-by-step guide to install Gemini CLI (Google) MANUALLY.
-- No shell scripts — just copy-paste each block.
-- Run commands one by one in your WSL/Linux terminal.
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
 * ║  LAYER 0: PREREQUISITES — Make sure environment is ready                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (or macOS 15+, Windows 11 24H2+)
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - Google Account (free — free tier: 60 req/min, 1,000 req/day)
 *
 * WHY GEMINI CLI?
 *   - FREE TIER! No payment needed to start (60 req/min, 1,000 req/day)
 *   - 1M token context window — one of the largest
 *   - Built-in Google Search grounding (real-time fact checking)
 *   - MCP support + GEMINI.md project config
 *   - Open-source: github.com/google-gemini/gemini-cli
 */

-- Check OS
-- $ uname -a

-- Check RAM — minimum 4GB
-- $ free -h

-- Check disk — ~2GB free
-- $ df -h ~

-- Install curl & git if not available
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS — Gemini CLI requires Node.js 20+                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 1.1: Install fnm
-- $ curl -fsSL https://fnm.vercel.app/install | bash

-- Step 1.2: Reload shell
-- $ source ~/.bashrc

-- Step 1.3: Install Node.js 22 (LTS)
-- $ fnm install 22
-- $ fnm use 22
-- $ fnm default 22

-- Step 1.4: Verify
-- $ node --version           -- should be v22.x.x
-- $ npm --version            -- should be 10.x.x

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: GEMINI CLI — Install Google's agent                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI is Google DeepMind's open-source terminal agent.
 * FREE TIER: 60 req/min, 1,000 req/day — enough for personal dev.
 * Models: Gemini 2.5 Pro, Gemini 3 Flash, etc. with 1M context.
 *
 * Docs:    https://geminicli.com/docs/
 * GitHub:  https://github.com/google-gemini/gemini-cli
 */

-- Step 2.1: Install Gemini CLI globally (via npm)
-- $ npm install -g @google/gemini-cli

-- Alternative: npx (no install — ephemeral)
-- $ npx @google/gemini-cli

-- Alternative: Homebrew (macOS/Linux)
-- $ brew install gemini-cli

-- Step 2.2: Verify installation
-- $ gemini --version

-- Step 2.3: Launch Gemini CLI (first run — OAuth authentication)
-- $ cd ~/SQL-QUERY-JOB
-- $ gemini
--   → Select "Login with Google" (browser OAuth — FREE)
--   → OR: export GEMINI_API_KEY="YOUR_KEY" (API key for CI/CD)

-- Step 2.4: Basic commands
-- $ gemini                                          -- interactive TUI
-- $ gemini -p "Explain this codebase"               -- one-shot
-- $ gemini -m "gemini-2.5-flash" "Refactor this"    -- specific model
-- $ gemini -y "Run all tests"                       -- auto-approve

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Alternative super-cheap model              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Gemini CLI natively uses Google Gemini models (free tier is enough).
 * BUT you can add DeepSeek as an OPENAI-COMPATIBLE provider.
 *
 * Why add DeepSeek?
 *   - When Gemini free tier runs out (1,000 req/day)
 *   - 500M tokens FREE on DeepSeek signup
 *   - $0.14/$0.28 per 1M tokens (much cheaper than GPT-4o)
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 3.1: Get API key
--   Open: https://platform.deepseek.com/api_keys → Sign up (free) → copy key

-- Step 3.2: Save permanently
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 3.3: Verify key
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 3.4: How to use DeepSeek in Gemini CLI
--   Edit ~/.gemini/settings.json:
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
--   Then switch: /model deepseek-chat

-- Step 3.5: Google built-in models (free tier)
--   gemini-2.5-flash         → fast, general purpose           (FREE)
--   gemini-2.5-pro           → best reasoning + tools          (FREE)
--   auto                     → auto-select best model          (DEFAULT)

-- Step 3.6: DeepSeek models reference
--   deepseek-chat (v3)       → complex tasks                   ($0.27/$1.10)
--   deepseek-v4-flash        → fast, cheap, daily use          ($0.14/$0.28)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: GEMINI.MD — Project context & conventions                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: Create GEMINI.md in project root
-- $ cd ~/SQL-QUERY-JOB
--   # SQL-QUERY-JOB Conventions
--   ## Tech Stack: PostgreSQL 16, PL/pgSQL
--   ## Rules: UPPERCASE SQL, no SELECT *, EXPLAIN ANALYZE before queries

-- Step 4.2: Gemini CLI auto-reads GEMINI.md every session — no manual load needed

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: MCP SERVERS                                                   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: MCP config — ~/.gemini/mcp.json
--   Same structure as other agents (grep, filesystem, git)

-- Step 5.2: Built-in tools (no MCP needed)
--   Google Search grounding, file operations, shell commands, web fetching

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: THEMES + SETTINGS                                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Settings ~/.gemini/settings.json
--   { "ui": { "theme": "tokyo-night" }, "model": { "default": "gemini-2.5-flash" } }

-- Step 6.2: Commands: /theme, /settings, /stats, /docs, /clear

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 7: SKILLS                                                        ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 7.1: Install skills
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

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
-- [ ] Google auth             → gemini (must login)
-- [ ] GEMINI.md               → ls ~/SQL-QUERY-JOB/GEMINI.md
-- [ ] MCP servers             → ls ~/.gemini/mcp.json
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /theme, /settings, /stats, /docs, /clear, /mcp list

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: gemini: command not found
-- Fix:     $ npm install -g @google/gemini-cli

-- Problem: Rate limit (60 req/min exceeded)
-- Fix:     Wait 1 minute OR upgrade to paid tier with API key

-- Problem: Authentication loop
-- Fix:     $ rm -rf ~/.gemini/auth && gemini

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Gemini CLI docs:     https://geminicli.com/docs/
-- Google AI Studio:    https://aistudio.google.com/
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Happy coding with Gemini CLI! 💎
-- ============================================================================
