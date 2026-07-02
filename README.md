# Stand-Alone Agentic AI Setup — Terminal AI Agent Installation Guides

> Complete step-by-step installation guides for 6 terminal-based AI coding agents. Copy-paste directly into your terminal — no scripts, no automation. Available in English and Bahasa Indonesia, for both WSL/Linux and Windows (PowerShell).

---

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Agents Covered](#agents-covered)
- [How Each Guide is Structured](#how-each-guide-is-structured)
- [DeepSeek Integration](#deepseek-integration)
- [Common Stack](#common-stack)
- [Project Structure](#project-structure)
- [Agent Comparison](#agent-comparison)
- [How to Use the Files](#how-to-use-the-files)
- [Resources](#resources)
- [License](#license)

---

## Overview

Every `.sql` file in this repo is a standalone installation manual for a specific AI coding agent. Content lives entirely inside SQL comment blocks (`/* */` and `--`), so the files are readable in any text editor or SQL IDE — but they never execute as SQL.

```
┌─────────────────────┐     ┌──────────────────────┐     ┌─────────────────────┐
│  Pick an agent       │────▶│  Open the .sql file  │────▶│  Copy-paste commands │
│                      │     │                      │     │  into your terminal  │
│  • pi.dev            │     │  Each layer explains │     │                      │
│  • Claude Code       │     │  the why & what      │     │  • PowerShell        │
│  • Codex CLI         │     │                      │     │  • bash              │
│  • Gemini CLI        │     │  Read → understand   │     │                      │
│  • Aider             │     │  → execute           │     │  One step at a time  │
│  • Cursor CLI        │     │                      │     │                      │
└─────────────────────┘     └──────────────────────┘     └─────────────────────┘
```

### Why Use This?

| Problem | Solution |
|---------|----------|
| Agent docs are scattered across different sites | All 6 agents documented in one consistent format |
| Windows guides assume WSL | Native **PowerShell** guides — no WSL required |
| Tutorials skip the "why" | Each layer explains the reasoning before the command |
| Hard to compare agents side-by-side | Agent comparison matrix with features, pricing, context windows |
| Setup fails without troubleshooting | Every guide includes platform-specific troubleshooting |
| Language barrier for Indonesian devs | `id/` folder with full Bahasa Indonesia commentary |

---

## Quick Start

### Prerequisites

- **Terminal**: bash (WSL/Linux/macOS) **or** PowerShell (Windows 10+/11)
- **Git** (`sudo apt install git` or [git-scm.com](https://git-scm.com/download/win))
- **Internet connection** for downloads

### 1. Choose your agent

Pick from 6 agents — see the [comparison matrix](#agent-comparison) to decide.

### 2. Open the guide

```bash
# English, WSL/Linux:
cat en/for-wsl-linux/aider-standalone-setup.sql

# Bahasa Indonesia, WSL/Linux:
cat id/for-wsl-linux/aider-standalone-setup.sql
```

```powershell
# English, Windows:
cat .\en\for-windows\aider-standalone-setup.sql

# Bahasa Indonesia, Windows:
cat .\id\for-windows\aider-standalone-setup.sql
```

### 3. Copy-paste, layer by layer

Each file is divided into numbered layers. Run each layer's commands one at a time.

### 4. Check the checklist

Every guide ends with a checkbox checklist — tick off items as you install them.

---

## Agents Covered

| Agent | Creator | Price | Best For |
|---|---|---|---|
| **[pi.dev](https://pi.dev)** | Earendil Works | Free | Open-source, extensible, skills ecosystem |
| **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** | Anthropic | $20/mo Pro | MCP-native, CLAUDE.md, hooks |
| **[Codex CLI](https://github.com/openai/codex)** | OpenAI | $20/mo Plus | Standalone binary, sandbox, CI/CD |
| **[Gemini CLI](https://geminicli.com)** | Google | **Free tier** | 1M context, Google Search grounding |
| **[Aider](https://aider.chat)** | Open Source | Pay-per-use | 100+ models, Git-native, no subscription |
| **[Cursor CLI](https://cursor.com/cli)** | Cursor | $20/mo Pro | Composer engine, TypeScript SDK |

---

## How Each Guide is Structured

Every `.sql` file follows the same layered architecture:

```
Layer 0: Prerequisites     → Check OS, RAM, disk, install curl & git
Layer 1: Runtime           → Node.js (fnm/nvm) or Python (uv/pip)
Layer 2: Agent Binary      → Install command + verification
Layer 3: DeepSeek Provider → API key setup + config (all agents support this!)
Layer 4+: Ecosystem        → MCP servers, project config, themes, skills
Quick Reference            → Checklist + slash commands + daily workflow
Troubleshooting            → Common problems & platform-specific fixes
Resources                  → Links to official docs & tools
```

Each layer includes:
- **Why**: explanation of what this layer provides
- **What**: the commands to run
- **How**: context on when and how to use the feature

---

## DeepSeek Integration

**Every agent** in this repo is configured to support [DeepSeek](https://platform.deepseek.com/api_keys) as an alternative provider:

- 💰 **Cheapest model**: $0.14/$0.28 per 1M tokens (input/output)
- 🎁 **500M tokens FREE** on signup — no credit card required
- ⚡ **deepseek-v4-flash**: fast enough for daily coding, cheap enough to use all day

| Agent | DeepSeek Support |
|---|---|
| pi.dev | Native via custom provider settings |
| Claude Code | Via `OPENAI_API_BASE` custom endpoint |
| Codex CLI | Via `OPENAI_API_BASE` environment variable |
| Gemini CLI | Via `settings.json` custom provider block |
| Aider | **NATIVE** — `aider --model deepseek` (no config needed!) |
| Cursor CLI | Via `config.json` custom provider block |

---

## Common Stack

Tools needed by most agents across both platforms:

| Tool | Windows | Linux/WSL |
|---|---|---|
| Git | [git-scm.com](https://git-scm.com/download/win) | `sudo apt install git` |
| Node.js 22 | [nodejs.org](https://nodejs.org) or nvm-windows | fnm or nvm |
| Python 3.12 | [python.org](https://python.org) | `sudo apt install python3` |
| DeepSeek API Key | [platform.deepseek.com](https://platform.deepseek.com/api_keys) | same |

---

## Project Structure

```
stand-alone-agentic-ai/
├── README.md                            # This documentation
│
├── en/                                  # English guides
│   ├── for-wsl-linux/                   # For WSL2 / Ubuntu / macOS
│   │   ├── pi-dev-standalone-setup.sql
│   │   ├── claude-code-standalone-setup.sql
│   │   ├── codex-cli-standalone-setup.sql
│   │   ├── gemini-cli-standalone-setup.sql
│   │   ├── aider-standalone-setup.sql
│   │   └── cursor-cli-standalone-setup.sql
│   └── for-windows/                     # For Windows native (PowerShell)
│       ├── pi-dev-standalone-setup.sql
│       ├── claude-code-standalone-setup.sql
│       ├── codex-cli-standalone-setup.sql
│       ├── gemini-cli-standalone-setup.sql
│       ├── aider-standalone-setup.sql
│       └── cursor-cli-standalone-setup.sql
│
└── id/                                  # Panduan Bahasa Indonesia
    ├── for-wsl-linux/
    │   └── (6 files — same agents)
    └── for-windows/
        └── (6 files — same agents)
```

> 📂 **24 SQL files** total: 6 agents × 2 languages × 2 platforms.

---

## Agent Comparison

| Feature | pi.dev | Claude Code | Codex CLI | Gemini CLI | Aider | Cursor CLI |
|---|---|---|---|---|---|---|
| **Open Source** | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Free Tier** | ✅ | ❌ | ❌ | ✅ 60/min | Pay-per-use | Limited |
| **No Runtime Needed** | ❌ | ✅ native | ✅ native | ❌ | ❌ | ✅ native |
| **Runtime** | Node.js | Node.js | None | Node.js | Python | None |
| **Git Integration** | Basic | Via MCP | Via MCP | Via MCP | **Native** | Via MCP |
| **MCP Support** | ✅ | ✅ | ✅ | ✅ | Via tools | ✅ |
| **Multi-Model** | ✅ | Via custom | Via custom | Via custom | ✅ **100+** | ✅ |
| **CI/CD Ready** | ❌ | `-p` flag | `exec` | `-p` flag | `--message` | `-p` flag |
| **Windows Native** | Via npm | ✅ installer | ✅ installer | Via npm | Via pip | ✅ installer |
| **Context Window** | ~200K | ~200K | ~200K | **1M** | Varies | ~200K |
| **Auto-Commit** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Voice Input** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **Architect Mode** | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ |
| **SDK Available** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ TypeScript |

---

## How to Use the Files

1. **Open the `.sql` file** for your chosen agent in any editor (VS Code, Notepad++, DataGrip, DBeaver)
2. **Read each layer** — the commentary explains _why_ you're installing each piece
3. **Copy-paste commands** into your terminal **one at a time** — you stay in full control
4. **Verify each step** before moving to the next layer
5. **Check off the checklist** at the bottom of the file
6. **Done!** Jump to the daily workflow section to start using your agent

> 💡 **Tip:** Opening the files in a SQL editor (DBeaver, pgAdmin, DataGrip) gives you nice syntax highlighting. The SQL comment format means the file will never execute — it's purely documentation.

---

## Resources

| Resource | URL |
|---|---|
| DeepSeek API Key | [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys) |
| Skills Directory | [skills.sh](https://www.skills.sh) |
| MCP Documentation | [modelcontextprotocol.io](https://modelcontextprotocol.io) |
| Git for Windows | [git-scm.com/download/win](https://git-scm.com/download/win) |
| Node.js | [nodejs.org](https://nodejs.org) |
| Python | [python.org](https://python.org) |

---

## License

MIT — feel free to use, modify, and share. If this helps, give the repo a ⭐!

---

**Happy coding with AI agents! 🤖🚀**
