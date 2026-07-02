-- ============================================================================
-- Gemini CLI Standalone Setup Guide — WINDOWS (PowerShell)
-- ============================================================================
--
-- Complete guide to install Google Gemini CLI on WINDOWS. NO WSL needed.
-- FREE TIER: 60 req/min, 1,000 req/day — no payment required!
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements: Windows 10+ / 11, Node.js 20+
 * Google Account (free tier)
 *
 * Docs: https://geminicli.com/docs/
 */

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS + GEMINI CLI                                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 1.1: Install Node.js
--   Download from https://nodejs.org → LTS 22.x → CHECK "Add to PATH"
--   Verify: PS> node --version && npm --version

-- Step 1.2: Install Gemini CLI
-- PS> npm install -g @google/gemini-cli

-- Step 1.3: PATH fix (if "gemini" not found)
--   Add %APPDATA%\npm to Environment Variables → User Path
--   CLOSE & REOPEN PowerShell

-- Step 1.4: Verify → PS> gemini --version

-- Step 1.5: Launch
-- PS> gemini   → "Login with Google" (browser OAuth — FREE)

-- Step 1.6: Commands
-- PS> gemini                                              -- interactive TUI
-- PS> gemini -p "Explain this codebase"                   -- one-shot
-- PS> gemini -m "gemini-2.5-flash" "Refactor this"        -- specific model

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER                                              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Set permanent env var
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-key", "User")
--   CLOSE & REOPEN PowerShell

-- Step 2.2: Setup custom provider in %USERPROFILE%\.gemini\settings.json
--   { "models": { "providers": { "deepseek": { "baseUrl": "https://api.deepseek.com/v1",
--     "apiKey": "env:DEEPSEEK_API_KEY", "models": ["deepseek-chat", "deepseek-v4-flash"] } } } }

-- Step 2.3: Google built-in models (FREE)
--   gemini-2.5-flash (fast), gemini-2.5-pro (best), auto (auto-select)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: GEMINI.MD + MCP + SETTINGS + SKILLS                            ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- GEMINI.md: Create in project root → Gemini auto-reads it
-- MCP config: %USERPROFILE%\.gemini\mcp.json
-- Settings: %USERPROFILE%\.gemini\settings.json (theme, model, security)
-- Skills: npx skills add https://github.com/mattpocock/skills --skill grilling

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: gemini not found → Add %APPDATA%\npm to PATH
-- Problem: EACCES permission → Run as Administrator or npm config set prefix "$env:USERPROFILE\.npm-global"
-- Problem: Rate limit → Wait 1 min or set GEMINI_API_KEY env var

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Gemini CLI: https://geminicli.com/docs/
-- Google AI Studio: https://aistudio.google.com/
-- DeepSeek: https://platform.deepseek.com/api_keys

-- ============================================================================
-- EOF — Happy coding with Gemini CLI on Windows! 💎
-- ============================================================================
