-- ============================================================================
-- Codex CLI Standalone Setup Guide — WINDOWS (PowerShell)
-- ============================================================================
--
-- Complete guide to install OpenAI Codex CLI on WINDOWS. NO WSL needed.
-- Codex CLI has native Windows support with a standalone binary.
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements: Windows 10 1809+ / 11, Git for Windows
 * OpenAI account: Plus ($20/mo) OR API key
 *
 * Docs: https://github.com/openai/codex  |  Latest: v0.142.3
 */

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CODEX CLI — Native Windows installer                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 1.1: Install (RECOMMENDED — standalone, no Node.js)
-- PS> powershell -ExecutionPolicy ByPass -c "irm https://chatgpt.com/codex/install.ps1 | iex"

-- Alternative: npm (needs Node.js 20+)
-- PS> npm install -g @openai/codex

-- Alternative: winget
-- PS> winget install OpenAI.Codex

-- Step 1.2: Verify → PS> codex --version (expected: 0.142.x)

-- Step 1.3: Authenticate
-- PS> codex   → "Sign in with ChatGPT" (browser OAuth)
--   OR: codex login --with-api-key

-- Step 1.4: Commands
-- PS> codex                                    -- interactive TUI
-- PS> codex "explain this codebase"            -- direct prompt
-- PS> codex exec "fix the error"               -- headless/CI mode

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER                                              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Set permanent env vars
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-your-deepseek-key", "User")
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_BASE", "https://api.deepseek.com/v1", "User")
--   CLOSE & REOPEN PowerShell

-- Step 2.2: Use DeepSeek
-- PS> codex --model deepseek-chat "Explain this codebase"
--   Mid-session: /model deepseek-chat

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: SANDBOX + CI/CD + SKILLS                                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Sandbox: codex --sandbox unelevated (recommended)
-- CI/CD: codex exec --approve "Review PR for bugs"
-- CODEX.md: /init inside session
-- Skills: npx skills add https://github.com/mattpocock/skills --skill grilling

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: ExecutionPolicy → Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
-- Problem: Elevated sandbox needs admin → Run PowerShell as Administrator
-- Problem: Authentication loop → Remove-Item -Recurse -Force $env:USERPROFILE\.codex\auth.json

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Codex CLI: https://github.com/openai/codex
-- DeepSeek: https://platform.deepseek.com/api_keys

-- ============================================================================
-- EOF — Happy coding with Codex CLI on Windows! 🚀
-- ============================================================================
