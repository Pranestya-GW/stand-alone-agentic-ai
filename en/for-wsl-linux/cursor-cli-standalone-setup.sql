-- ============================================================================
-- Cursor CLI Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- Complete step-by-step guide to install Cursor CLI MANUALLY.
-- No shell scripts — just copy-paste each block.
-- Run commands one by one in your WSL/Linux terminal.
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
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+ (or macOS 13+, Windows 11)
 *   - curl, git
 *   - Cursor subscription: Hobby (free limited), Pro ($20/mo), or Teams
 *
 * WHY CURSOR CLI?
 *   - Terminal version of Cursor IDE's Composer engine
 *   - Multi-model: Composer 2.5, GPT-5.5, Opus 4.8, Gemini 3.1
 *   - Headless mode for CI/CD
 *   - MCP + Hooks + TypeScript SDK ecosystem
 */

-- Install curl & git if needed
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CURSOR CLI — Install agent (standalone binary)                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Cursor CLI is the terminal version of the Cursor IDE agent.
 * Docs: https://cursor.com
 */

-- Step 1.1: Install Cursor CLI
-- $ curl https://cursor.com/install -fsS | bash

-- Step 1.2: Verify
-- $ cursor-agent --version
--   OR: cursor --version

-- Step 1.3: Login (first run)
-- $ cursor-agent   → Login with Cursor account (Pro $20/mo or Hobby free)

-- Step 1.4: Basic commands
-- $ cursor-agent                                 -- interactive TUI
-- $ cursor-agent -p "Explain this codebase"      -- headless
-- $ cursor-agent --model <name> "task"           -- specific model

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Alternative cheap model                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Cursor CLI natively uses Cursor/OpenAI/Anthropic/Google models.
 * DeepSeek via custom provider in config.json.
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Get API key → platform.deepseek.com/api_keys → copy key

-- Step 2.2: Save permanently
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-key"' >> ~/.bashrc && source ~/.bashrc

-- Step 2.3: Setup custom provider — ~/.cursor/config.json
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
--   /model deepseek-chat  OR  /model Auto (auto-select best)

-- Step 2.5: Built-in Cursor models (with Pro subscription)
--   Composer 2.5, GPT-5.5, Claude Opus 4.8, Gemini 3.1 Pro, Grok 4.3

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: MCP SERVERS                                                   ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 3.1: MCP config — ~/.cursor/mcp.json
--   Same format: grep, git, filesystem, postgres servers

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: @CURSOR/SDK — Programmatic agents (TypeScript)                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 4.1: Install SDK
-- $ npm install @cursor/sdk

-- Step 4.2: Example agent
--   import { Agent } from "@cursor/sdk";
--   const agent = await Agent.create({ apiKey: process.env.CURSOR_API_KEY! });
--   const run = await agent.send("Review this PR");

-- Step 4.3: Run
-- $ CURSOR_API_KEY="your-key" npx tsx review-agent.ts

-- Step 4.4: CI/CD integration (GitHub Actions)
--   - uses: actions/setup-node@v4  with: { node-version: '22' }
--   - run: npm install @cursor/sdk && npx tsx review-agent.ts

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: SKILLS + HOOKS + FULL CONFIG                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install skills
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose

-- Step 5.2: Hooks — ~/.cursor/hooks/ (pre-edit.sh, post-edit.sh)

-- Step 5.3: Full config (~/.cursor/config.json)
--   { "model": { "default": "auto" }, "security": { "confirmShellCommands": true } }

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Cursor CLI binary       → cursor-agent --version
-- [ ] Cursor account          → cursor-agent (must login)
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] MCP servers             → ls ~/.cursor/mcp.json
-- [ ] @cursor/sdk             → npm ls @cursor/sdk

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /model Auto, /review, /clear, /context, /cost
-- @filename, !command, !git status

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: cursor-agent: command not found
-- Fix:     Reinstall: $ curl https://cursor.com/install -fsS | bash

-- Problem: Authentication failed
-- Fix:     $ cursor-agent logout && cursor-agent login

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Cursor website:      https://cursor.com
-- Cursor CLI:          https://cursor.com/cli
-- DeepSeek key:        https://platform.deepseek.com/api_keys

-- ============================================================================
-- EOF — Happy coding with Cursor CLI! 🖱️
-- ============================================================================
