-- ============================================================================
-- Claude Code Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- Complete step-by-step guide to install Claude Code (Anthropic)
-- MANUALLY. No shell scripts — just copy-paste each block.
-- Run commands one by one in your WSL/Linux terminal.
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
 * ║  LAYER 0: PREREQUISITES — Make sure environment is ready                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 *   - Anthropic account: Pro ($20/mo), Max, Teams, or Enterprise
 */

-- Check OS — must be Linux/WSL
-- $ uname -a

-- Check RAM — minimum 4GB, recommended 8GB+
-- $ free -h

-- Check disk — ~2GB free needed
-- $ df -h ~

-- Install curl & git if not available
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS — Claude Code requires Node.js 18+                     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 1.1: Install fnm
-- $ curl -fsSL https://fnm.vercel.app/install | bash

-- Step 1.2: Reload shell
-- $ source ~/.bashrc
--   OR manually:
-- $ export PATH="$HOME/.local/share/fnm:$PATH"
-- $ eval "$(fnm env)"

-- Step 1.3: Install Node.js 22 (LTS)
-- $ fnm install 22
-- $ fnm use 22
-- $ fnm default 22

-- Step 1.4: Verify
-- $ node --version           -- should be v22.x.x
-- $ npm --version            -- should be 10.x.x

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: CLAUDE CODE — Install the Anthropic agent                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Claude Code is Anthropic's terminal coding agent.
 * Reads codebases, edits multi-file, executes bash, MCP integration.
 *
 * REQUIRED: Anthropic paid account (Pro $20/mo, Max, Teams, Enterprise).
 *           Free-tier accounts won't work.
 *
 * Docs:    https://docs.anthropic.com/en/docs/claude-code
 * GitHub:  https://github.com/anthropics/claude-code
 */

-- Step 2.1: Install Claude Code globally (via npm)
-- $ npm install -g @anthropic-ai/claude-code

-- Alternative: Native installer (no Node.js needed, auto-update)
-- $ curl -fsSL https://claude.ai/install.sh | bash

-- Alternative: Homebrew (macOS)
-- $ brew install claude-code

-- Step 2.2: Verify installation
-- $ claude --version

-- Step 2.3: Fix PATH if "claude: command not found"
-- $ mkdir -p ~/.npm-global
-- $ npm config set prefix '~/.npm-global'
-- $ echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 2.4: Launch Claude Code (first run — OAuth authentication)
-- $ cd ~/SQL-QUERY-JOB
-- $ claude
--   → Browser opens for Anthropic login
--   → No browser? Copy the URL from terminal, open manually

-- Step 2.5: Basic commands reference
-- $ claude                                    -- interactive session
-- $ claude -p "explain this codebase"         -- one-shot prompt (headless)
-- $ claude --model claude-sonnet-4-20250514   -- use specific model
-- $ claude doctor                             -- diagnostics

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: DEEPSEEK PROVIDER — Additional cheap provider                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * NOTE: Claude Code natively uses Anthropic models. DeepSeek can be used
 *       as an OPENAI-COMPATIBLE provider via custom endpoint.
 *
 * Why add DeepSeek?
 *   - $0.14/$0.28 per 1M tokens (input/output) — much cheaper
 *   - 500M tokens FREE on signup
 *   - Great for lightweight tasks that don't need complex reasoning
 *
 * Docs:     https://api-docs.deepseek.com/
 * API Base: https://api.deepseek.com/v1
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 3.1: Get API key
--   Open: https://platform.deepseek.com/api_keys
--   Sign up (free) → copy API key (format: sk-...)

-- Step 3.2: Save permanently in ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 3.3: Verify key works
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 3.4: How to use DeepSeek in Claude Code
--   Set environment variables:
-- $ export ANTHROPIC_API_KEY="sk-ant-..."     -- Anthropic key (required for Claude)
-- $ export OPENAI_API_KEY="$DEEPSEEK_API_KEY"
-- $ export OPENAI_API_BASE="https://api.deepseek.com/v1"
--
--   Inside Claude Code:
--   /model openai/deepseek-chat               -- switch to DeepSeek
--
--   OR via flags at launch:
-- $ claude --model openai/deepseek-chat

-- Step 3.5: DeepSeek models available (reference)
--   deepseek-chat (v3)       → general purpose, good reasoning  ($0.27/$1.10)
--   deepseek-v4-flash        → fast, cheap, daily use            ($0.14/$0.28)
--   deepseek-reasoner        → deep thinking, math/logic         (price TBD)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: MCP SERVERS — Extend Claude Code with external tools          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * MCP (Model Context Protocol) is the standard for connecting AI agents
 * to external tools — grep code search, filesystem, git, database, etc.
 *
 * Docs: https://modelcontextprotocol.io
 */

-- Step 4.1: Create MCP config directory
-- $ mkdir -p ~/.claude

-- Step 4.2: Add MCP servers — edit ~/.claude/mcp.json:
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

-- Step 4.3: MCP commands inside Claude Code
--   /mcp list                  → list all active MCP servers
--   /mcp status                → check connection per server
--   /mcp tools                 → view tools provided by MCP

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: CLAUDE.MD + HOOKS — Project context & automation               ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Create CLAUDE.md in project root
-- $ cd ~/SQL-QUERY-JOB
-- $ claude
--   → Type /init → Claude scans codebase and generates CLAUDE.md

-- Step 5.2: Manual CLAUDE.md example
--   # SQL-QUERY-JOB Conventions
--   ## Tech Stack
--   - PostgreSQL 16, PL/pgSQL
--   ## Code Style
--   - SQL keywords UPPERCASE: SELECT, FROM, WHERE
--   - Never use SELECT *
--   ## Rules
--   - NEVER drop tables without /safety confirm
--   - Always EXPLAIN ANALYZE before new queries

-- Step 5.3: Hooks (~/.claude/hooks/)
--   pre-edit, post-edit, pre-commit, post-commit, session-start

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: SKILLS — Pre-built agent behaviors                            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Install skills
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling
-- $ npx skills add https://github.com/mattpocock/skills --skill diagnose
-- $ npx skills add https://github.com/mattpocock/skills --skill handoff

-- Step 6.2: How to use skills (inside Claude session)
--   "Here's my database migration plan — grill me on it"
--   "Diagnose why this query is slow"
--   "Handoff this session to another agent"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: All Commands in One Place                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST
-- ============================================================================

-- [ ] Node.js 22              → node --version
-- [ ] Claude Code binary      → claude --version
-- [ ] Anthropic account        → claude (must login)
-- [ ] DeepSeek key            → echo $DEEPSEEK_API_KEY
-- [ ] MCP servers             → ls ~/.claude/mcp.json
-- [ ] CLAUDE.md               → ls ~/SQL-QUERY-JOB/CLAUDE.md
-- [ ] Grilling skill          → ls ~/.claude/skills/ | grep grill

-- ============================================================================
-- SLASH COMMANDS — Inside Claude Code session
-- ============================================================================

-- /help, /model, /init, /clear, /compact, /doctor, /context, /mcp list
-- /add-dir, /permissions, /review, /cost

-- ============================================================================
-- DAILY WORKFLOW
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB
-- $ claude
-- /model openai/deepseek-chat                        -- switch to DeepSeek (optional)
-- "Explain the database structure of this project"
-- "Find all queries using SELECT * and replace"
-- "Add indexes on frequently joined columns"

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: claude: command not found
-- Fix:     $ echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc

-- Problem: npm install fails (permission error)
-- Fix:     $ mkdir ~/.npm-global && npm config set prefix '~/.npm-global'

-- Problem: Authentication failed
-- Fix:     $ claude logout && claude login

-- Problem: "No available models" (DeepSeek not showing)
-- Fix:     Verify environment variables: echo $OPENAI_API_KEY && echo $OPENAI_API_BASE

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- $ npm uninstall -g @anthropic-ai/claude-code
-- $ rm -rf ~/.claude

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Claude Code docs:    https://docs.anthropic.com/en/docs/claude-code
-- MCP docs:            https://modelcontextprotocol.io
-- DeepSeek key:        https://platform.deepseek.com/api_keys
-- Skills directory:    https://www.skills.sh/

-- ============================================================================
-- EOF — Happy coding with Claude Code! 🤖
-- ============================================================================
