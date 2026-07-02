-- ============================================================================
-- Cursor CLI Standalone Setup Guide — WINDOWS (PowerShell)
-- ============================================================================
--
-- Complete guide to install Cursor CLI on WINDOWS. NO WSL needed.
-- Native Windows build with standalone binary.
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements: Windows 10 1809+ / 11, Git for Windows, PowerShell 5.1+
 * Cursor account: Hobby (free limited), Pro ($20/mo), or Teams
 *
 * Docs: https://cursor.com/cli
 */

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CURSOR CLI — Native Windows installer                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Command on Windows: agent (not cursor-agent)
 * Install location: C:\Users\<user>\AppData\Local\cursor-agent\
 */

-- Step 1.1: Install (one-liner)
-- PS> irm 'https://cursor.com/install?win32=true' | iex

-- Alternative: Download & run
-- PS> irm https://cursor.com/install -OutFile install.ps1; .\install.ps1

-- Step 1.2: PATH fix (if "agent" not found)
-- PS> $p = "$env:USERPROFILE\AppData\Local\cursor-agent"
-- PS> [Environment]::SetEnvironmentVariable("Path", $p + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

-- Step 1.3: Optional: install ripgrep
-- PS> winget install BurntSushi.ripgrep.msvc

-- Step 1.4: Verify → PS> agent --version

-- Step 1.5: Launch
-- PS> agent   → Login with Cursor account (Pro $20/mo or Hobby free)

-- Step 1.6: Commands
-- PS> agent                                              -- interactive TUI
-- PS> agent -p "Explain this codebase"                   -- headless
-- PS> agent --model composer-2 "Refactor this query"     -- specific model

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER — Alternative cheap model                    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Set permanent env var
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-key", "User")
--   CLOSE & REOPEN PowerShell

-- Step 2.2: Custom provider — %USERPROFILE%\.cursor\config.json
--   { "providers": { "deepseek": { "type": "openai-compatible",
--     "baseUrl": "https://api.deepseek.com/v1", "apiKey": "env:DEEPSEEK_API_KEY",
--     "models": ["deepseek-chat", "deepseek-v4-flash"] } } }

-- Step 2.3: Switch model → /model deepseek-chat  OR  /model Auto

-- Step 2.4: Built-in models (Pro subscription)
--   Composer 2.5, GPT-5.5, Claude Opus 4.8, Gemini 3.1 Pro

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: MCP + SDK + SKILLS + HOOKS                                     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- MCP: %USERPROFILE%\.cursor\mcp.json (use \\ for Windows paths!)
-- SDK: npm install @cursor/sdk → TypeScript programmatic agents
-- Skills: npx skills add https://github.com/mattpocock/skills --skill grilling
-- Hooks: %USERPROFILE%\.cursor\hooks\ (pre-edit.ps1, post-edit.ps1)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE                                                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

-- /help, /model, /model Auto, /review, /clear, /context, /cost, /diff
-- @filename (inject file), !command (run shell mid-convo)

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: agent not found → Check %USERPROFILE%\AppData\Local\cursor-agent\ in PATH
-- Problem: ripgrep (rg.exe) not found → winget install BurntSushi.ripgrep.msvc
-- Problem: ExecutionPolicy → Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Cursor: https://cursor.com/cli  |  DeepSeek: https://platform.deepseek.com/api_keys

-- ============================================================================
-- EOF — Happy coding with Cursor CLI on Windows! 🖱️
-- ============================================================================
