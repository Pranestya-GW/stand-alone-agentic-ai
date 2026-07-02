-- ============================================================================
-- Claude Code Standalone Setup Guide — WINDOWS (PowerShell)
-- ============================================================================
--
-- Complete guide to install Claude Code on WINDOWS using PowerShell.
-- NO WSL needed. Copy-paste each PowerShell block.
--
-- NOTE: Claude Code now has a NATIVE Windows installer — no Node.js needed!
-- ============================================================================

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 0: PREREQUISITES                                                  ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 1809+ / Windows 11
 *   - Git for Windows (https://git-scm.com/download/win)
 *   - Anthropic account: Pro ($20/mo), Max, Teams, or Enterprise
 */

-- PS> winver

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: CLAUDE CODE — Native Windows installer                         ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Docs: https://docs.anthropic.com/en/docs/claude-code
 */

-- Step 1.1: Install (recommended — native)
-- PS> irm https://claude.ai/install.ps1 | iex

-- Alternative: winget
-- PS> winget install Anthropic.ClaudeCode

-- Step 1.2: PATH fix (if "claude" not found)
--   Add %USERPROFILE%\.local\bin to Environment Variables → User Path
--   CLOSE & REOPEN PowerShell

-- Step 1.3: Verify → PS> claude --version

-- Step 1.4: First launch → PS> claude (browser OAuth login)

-- Step 1.5: Git Bash path (if Claude needs it)
-- PS> [Environment]::SetEnvironmentVariable("CLAUDE_CODE_GIT_BASH_PATH", "C:\Program Files\Git\bin\bash.exe", "User")

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: DEEPSEEK PROVIDER                                              ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Key: https://platform.deepseek.com/api_keys
 */

-- Step 2.1: Set permanent environment variables
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-key", "User")
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-your-key", "User")
-- PS> [Environment]::SetEnvironmentVariable("OPENAI_API_BASE", "https://api.deepseek.com/v1", "User")
-- PS> [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-your-key", "User")
--   CLOSE & REOPEN PowerShell

-- Step 2.2: Use DeepSeek → PS> claude --model openai/deepseek-chat "task"

-- Step 2.3: Switch mid-session → /model openai/deepseek-chat

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: MCP SERVERS + CLAUDE.MD + SKILLS                               ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- MCP config: $env:USERPROFILE\.claude\mcp.json (use \\ for Windows paths!)
-- CLAUDE.md: /init inside Claude session → scans codebase
-- Skills: npx skills add https://github.com/mattpocock/skills --skill grilling

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: claude not found → add %USERPROFILE%\.local\bin to PATH
-- Problem: ExecutionPolicy → Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
-- Problem: Git Bash not found → Install Git for Windows first

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- Claude Code: https://docs.anthropic.com/en/docs/claude-code
-- DeepSeek: https://platform.deepseek.com/api_keys
-- Git for Windows: https://git-scm.com/download/win

-- ============================================================================
-- EOF — Happy coding with Claude Code on Windows! 🤖
-- ============================================================================
