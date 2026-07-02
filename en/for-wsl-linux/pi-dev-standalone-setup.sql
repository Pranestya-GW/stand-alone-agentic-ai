-- ============================================================================
-- pi.dev Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
--
-- Complete step-by-step guide to install pi.dev and the full recommended
-- stack MANUALLY. No shell scripts — just copy-paste each block.
--
-- Each section is an SQL comment block. Run commands one by one
-- in your WSL/Linux terminal.
--
-- Stack overview:
--   Layer 1: pi.dev binary          → the agent itself
--   Layer 2: pi-setup               → safety guard, themes, file review, sync
--   Layer 3: DeepSeek provider      → cheapest model, 500M free tokens
--   Layer 4: 4 plugins              → context-mode, search, goal, ask-user
--   Layer 5: grilling skill         → stress-test plans & designs
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
 * ║  LAYER 1: NODE.JS — pi.dev requires Node.js 18+                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * We use fnm (Fast Node Manager) — lighter than nvm, faster.
 * fnm makes switching Node.js versions easy.
 */

-- Step 1.1: Install fnm
-- $ curl -fsSL https://fnm.vercel.app/install | bash

-- Step 1.2: Reload shell (or close & reopen terminal)
-- $ source ~/.bashrc
--   OR manually:
-- $ export PATH="$HOME/.local/share/fnm:$PATH"
-- $ eval "$(fnm env)"

-- Step 1.3: Install Node.js 22 (LTS — most stable for pi.dev)
-- $ fnm install 22
-- $ fnm use 22
-- $ fnm default 22          -- make it permanent

-- Step 1.4: Verify
-- $ node --version           -- should be v22.x.x
-- $ npm --version            -- should be 10.x.x

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: PI.DEV BINARY — Install the core agent                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * pi.dev is an open-source terminal coding agent.
 * Reads codebases, executes bash, edits files, searches, supports multiple models.
 *
 * Docs:    https://pi.dev
 * GitHub:  https://github.com/earendil-works/pi
 */

-- Step 2.1: Install pi.dev globally
-- $ npm install -g @earendil-works/pi-coding-agent

-- Step 2.2: Verify
-- $ pi --version

-- Step 2.3: Test run (first run prompts for free signup)
-- $ cd ~
-- $ pi "Hello, what can you do?"

-- Step 2.4: Basic commands reference
-- $ pi                        -- interactive session
-- $ pi "query here"           -- one-shot query
-- $ pi --model <model> "..."  -- use specific model

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: PI-SETUP — Safety guard + themes + file review + sync          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * pi-setup adds:
 *   🔒 Safety guard      — confirm before dangerous commands
 *   📝 File review       — inspect all files Pi changed, accept/revert
 *   🎨 10 themes         — dracula, nord, tokyo-night, catppuccin, etc.
 *   📊 Token counter     — real-time context window usage
 *   🤖 Local models      — connect to Ollama / LM Studio
 *   🔄 Sync backup       — backup Pi config to GitHub
 *
 * GitHub: https://github.com/abhinand5/pi-setup
 */

-- Step 3.1: Clone pi-setup
-- $ git clone https://github.com/abhinand5/pi-setup.git ~/pi-setup

-- Step 3.2: Install
-- $ cd ~/pi-setup
-- $ ./install.sh --restore --copy-config

-- Step 3.3: Fix "no existing Pi binary found" warning (if it appears)
-- $ echo 'export PI_REAL_BIN=$HOME/.local/share/fnm/node-versions/v22.14.0/installation/bin/pi' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 3.4: Commands available inside Pi after pi-setup
--   /filechanges              → view all changed files + diff
--   /filechanges-accept        → keep all changes
--   /filechanges-decline       → revert all changes
--   /safety                    → check safety guard on/off
--   /context                   → check context window usage
--   /local-models              → add local model (Ollama/LM Studio)
--   /theme                     → switch theme (10 options)
--   /welcome updates on        → update notice at startup

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: DEEPSEEK PROVIDER — Cheapest model for daily coding            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Why DeepSeek?
 *   - Cheapest: $0.14/$0.28 per 1M tokens (input/output)
 *   - 500M tokens FREE on signup
 *   - deepseek-v4-flash: fast + good for daily coding
 *   - OpenAI-compatible API → works with pi.dev
 *
 * Docs:     https://api-docs.deepseek.com/
 * API Base: https://api.deepseek.com/v1
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 4.1: Get API key
--   Open: https://platform.deepseek.com/api_keys
--   Sign up (free) → copy API key (format: sk-...)

-- Step 4.2: Save permanently in ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 4.3: Verify key works
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 4.4: How to use in pi.dev
-- $ pi --model deepseek-v4-flash "Explain this codebase"
--
--   Or switch model mid-session inside Pi:
--   /model deepseek-v4-flash

-- Step 4.5: Other DeepSeek models (reference)
--   deepseek-v4-flash       → fast, cheap, daily use      ($0.14/$0.28)
--   deepseek-chat-v3        → better reasoning             ($0.27/$1.10)
--   deepseek-reasoner       → deep thinking, math/logic    (price TBD)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 1 — context-mode (Save Context Window)                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Problem: Pi has limited context window (~200K tokens). Long sessions
 *          can lose early conversation context.
 *
 * Solution: context-mode auto-compresses conversation history to keep
 *           context efficient even in long sessions.
 *
 * Docs: https://pi.dev/packages/context-mode
 */

-- Step 5.1: Install
-- $ pi install npm:context-mode

-- Step 5.2: How to use (inside Pi session)
--   /context-mode on         → enable, auto-compress when context full
--   /context-mode smart      → smart compression (recommended)
--   /context-mode status     → check current mode

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 2 — pi-deepseek-search (Web Search for DeepSeek)       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Problem: DeepSeek models don't have internet access. Answers about
 *          latest APIs or libraries may be stale.
 *
 * Solution: pi-deepseek-search gives DeepSeek web search capability —
 *           fetches latest docs, npm registry, StackOverflow, etc.
 *
 * Docs: https://pi.dev/packages/pi-deepseek-search
 */

-- Step 5.3: Install
-- $ pi install npm:pi-deepseek-search

-- Step 5.4: How to use (inside Pi session — natural language)
--   "Search for the latest React 19 API changes and update our hooks"
--   "Find the npm package for PostgreSQL connection pooling and add it"
--   "Look up how to configure Tailwind v4 with Vite"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 3 — pi-codex-goal (Goal Mode)                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Problem: Large tasks can cause Pi to forget the objective mid-way.
 *
 * Solution: Goal mode provides persistent objective tracking. Pi will:
 *          1. Store objective + token budget (persists across reload/fork)
 *          2. Track active elapsed time & token usage in footer
 *          3. Send steering prompt when token budget runs out
 *          4. Agent tools: create_goal, get_goal, update_goal
 *
 * Docs: https://github.com/fitchmultz/pi-codex-goal
 */

-- Step 5.5: Install
-- $ pi install npm:pi-codex-goal

-- Step 5.6: How to use (inside Pi session)
--   /goal "Add user authentication with JWT to this Express app"
--     → Start new goal (or replace existing — confirmation prompt)
--   /goal "Set up CI/CD with GitHub Actions — budget 50K tokens"
--     → Goal with token budget (agent stops at limit)
--   /goal
--     → View current objective + status + token usage
--   /goal pause / resume / clear

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 4 — rpiv-ask-user-question (Interactive Decisions)     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Problem: Pi sometimes "guesses" architectural decisions — e.g. choosing
 *          SQLite when you wanted PostgreSQL. Frustrating.
 *
 * Solution: This plugin makes Pi ASK before making important decisions.
 *           You stay in full control.
 *
 * Docs: https://pi.dev/packages/@juicesharp/rpiv-ask-user-question
 */

-- Step 5.7: Install
-- $ pi install npm:@juicesharp/rpiv-ask-user-question

-- Step 5.8: How to use (auto-active — Pi will ask)
--   Pi: "Should I use PostgreSQL or SQLite for this?"
--   You: [1] PostgreSQL  [2] SQLite  [3] Custom...
--
-- Configuration:
--   /ask-user-question mode always     → ask ALL decisions (full control)
--   /ask-user-question mode blockers   → ask only at impasses (recommended)
--   /ask-user-question mode off        → disable, let Pi guess (auto-pilot)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: GRILLING SKILL — Stress-Test Plans & Designs                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Problem: Before big refactors or new features, there are often blind spots —
 *          unchallenged assumptions, unthought edge cases.
 *
 * Solution: Grilling skill (by Matt Pocock) makes Pi "interrogate" you about
 *           every aspect of the plan. Walks down every decision tree branch
 *           until all decisions are resolved.
 *
 * Docs: https://www.skills.sh/mattpocock/skills/grilling
 */

-- Step 6.1: Install
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling

-- Step 6.2: How to use (inside Pi session — trigger with "grill me")
--   "I want to add Redis caching to the API — grill me"
--   "Here's my database schema plan — grill me on it"
--   "Migrating from PostgreSQL 10 to 16 — grill me on the migration plan"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: All Commands in One Place                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (check off when installed)
-- ============================================================================

-- [ ] Node.js 22          → node --version
-- [ ] pi.dev binary       → pi --version
-- [ ] pi-setup            → ls ~/pi-setup
-- [ ] DeepSeek key        → echo $DEEPSEEK_API_KEY
-- [ ] context-mode        → pi list | grep context-mode
-- [ ] deepseek-search     → pi list | grep pi-deepseek-search
-- [ ] codex-goal          → pi list | grep pi-codex-goal
-- [ ] ask-user-question   → pi list | grep rpiv-ask-user-question
-- [ ] grilling skill      → ls ~/.pi/agent/skills/ | grep grill

-- ============================================================================
-- DAILY WORKFLOW — Example Pi session
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB                  -- go to project
-- $ pi                                   -- start Pi

-- # Inside Pi session:
-- /context-mode smart                    -- save context (optional)
-- "Explain the database structure of this project"
-- "Find all queries using SELECT * and replace with explicit columns"
-- "Add indexes on frequently joined columns"
-- /goal "Normalize t_bayar table — add FK + clean orphan rows"
-- "Grill me on this indexing strategy for vu_kasir_belum_lunas"

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: pi: command not found
-- Fix:     $ export PATH="$HOME/.local/share/fnm/node-versions/v22.14.0/installation/bin:$PATH"
--          $ source ~/.bashrc

-- Problem: Warning: no existing Pi binary found (after pi-setup install)
-- Fix:     $ echo 'export PI_REAL_BIN=$HOME/.local/share/fnm/node-versions/v22.14.0/installation/bin/pi' >> ~/.bashrc
--          $ source ~/.bashrc

-- Problem: DeepSeek API key not recognized
-- Fix:     $ echo $DEEPSEEK_API_KEY                          -- check if set
--          $ source ~/.bashrc                                 -- reload
--          $ curl https://api.deepseek.com/v1/models \       -- test API
--              -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Problem: npm install fails (permission error)
-- Fix:     $ mkdir ~/.npm-global
--          $ npm config set prefix '~/.npm-global'
--          $ echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
--          $ source ~/.bashrc

-- ============================================================================
-- UNINSTALL — Revert to vanilla Pi (removes pi-setup only, Pi binary stays)
-- ============================================================================

-- $ cd ~/pi-setup
-- $ ./uninstall.sh                     -- remove extensions, themes, config
-- $ npm uninstall -g @earendil-works/pi-coding-agent   -- remove Pi binary (optional)

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- pi.dev docs:       https://pi.dev
-- pi.dev GitHub:     https://github.com/earendil-works/pi
-- pi-setup GitHub:   https://github.com/abhinand5/pi-setup
-- DeepSeek API docs: https://api-docs.deepseek.com/
-- DeepSeek key:      https://platform.deepseek.com/api_keys
-- Skills directory:  https://www.skills.sh/
-- Pi packages:       https://pi.dev/packages/

-- ============================================================================
-- EOF — Happy coding with Pi! 🚀
-- ============================================================================
