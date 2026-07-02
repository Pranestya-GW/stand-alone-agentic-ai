# 🚀 Stand-Alone Agentic AI Setup

**Terminal AI agent installation guides — no scripts, just copy-paste.**

Complete installation guides for 6 terminal-based AI coding agents. Each SQL file is a step-by-step tutorial you can copy-paste directly into your terminal. Available in **English** and **Bahasa Indonesia**, for **WSL/Linux** and **Windows** (PowerShell).

---

## 📂 Repo Structure

```
stand-alone-agentic-ai/
├── README.md
├── en/                          ← English
│   ├── for-wsl-linux/           ← For WSL2 / Ubuntu / macOS
│   │   ├── pi-dev-standalone-setup.sql
│   │   ├── claude-code-standalone-setup.sql
│   │   ├── codex-cli-standalone-setup.sql
│   │   ├── gemini-cli-standalone-setup.sql
│   │   ├── aider-standalone-setup.sql
│   │   └── cursor-cli-standalone-setup.sql
│   └── for-windows/             ← For Windows native (PowerShell)
│       └── (same 6 agents)
└── id/                          ← Bahasa Indonesia
    ├── for-wsl-linux/
    └── for-windows/
```

---

## 🤖 Agents Covered

| Agent | Creator | Price | Best For |
|---|---|---|---|
| **[pi.dev](https://pi.dev)** | Earendil Works | Free | Open-source, extensible, skills ecosystem |
| **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** | Anthropic | $20/mo Pro | MCP-native, CLAUDE.md, hooks |
| **[Codex CLI](https://github.com/openai/codex)** | OpenAI | $20/mo Plus | Standalone binary, sandbox, CI/CD |
| **[Gemini CLI](https://geminicli.com)** | Google | **Free tier** | 1M context, Google Search grounding |
| **[Aider](https://aider.chat)** | Open Source | Pay-per-use | 100+ models, Git-native, no subscription |
| **[Cursor CLI](https://cursor.com/cli)** | Cursor | $20/mo Pro | Composer engine, TypeScript SDK |

---

## ⚡ Quick Start

### WSL / Linux / macOS

```bash
# English guide:
cat en/for-wsl-linux/aider-standalone-setup.sql

# Indonesian guide:
cat id/for-wsl-linux/aider-standalone-setup.sql
```

### Windows (PowerShell)

```powershell
# English guide:
cat .\en\for-windows\aider-standalone-setup.sql

# Indonesian guide:
cat .\id\for-windows\aider-standalone-setup.sql
```

---

## 📐 How Each Guide is Structured

Each `.sql` file uses **SQL comment documentation** format — all content lives inside `/* */` and `--` blocks, so it won't execute as SQL. Layer structure per file:

1. **Layer 0 — Prerequisites** → check OS, RAM, disk, install curl/git
2. **Layer 1 — Runtime** → Node.js (fnm/nvm) or Python (uv/pip)
3. **Layer 2 — Agent Binary** → install command + verification
4. **Layer 3 — DeepSeek Provider** → API key + config (all agents support DeepSeek!)
5. **Layer 4+ — Ecosystem** → MCP servers, project config, themes, skills
6. **Quick Reference** → checklist + slash commands + daily workflow
7. **Troubleshooting** → common problems & fixes
8. **Resources** → links to docs & tools

---

## 🔑 DeepSeek Integration

**All agents** in this repo are configured to support **DeepSeek** as an alternative provider:

- 💰 **Cheapest**: $0.14/$0.28 per 1M tokens (input/output)
- 🎁 **500M tokens FREE** on signup at [platform.deepseek.com](https://platform.deepseek.com/api_keys)
- ⚡ **deepseek-v4-flash**: fast + great for daily coding

| Agent | DeepSeek Support |
|---|---|
| pi.dev | Native via custom provider |
| Claude Code | Via `OPENAI_API_BASE` custom endpoint |
| Codex CLI | Via `OPENAI_API_BASE` env var |
| Gemini CLI | Via settings.json custom provider |
| Aider | **NATIVE** — `aider --model deepseek` |
| Cursor CLI | Via config.json custom provider |

---

## 🛠️ Common Stack (All Agents)

Tools needed by most agents:

| Tool | Windows | Linux/WSL |
|---|---|---|
| Git | [git-scm.com](https://git-scm.com/download/win) | `sudo apt install git` |
| Node.js 22 | [nodejs.org](https://nodejs.org) or nvm-windows | fnm or nvm |
| Python 3.12 | [python.org](https://python.org) | `sudo apt install python3` |
| DeepSeek Key | [platform.deepseek.com](https://platform.deepseek.com/api_keys) | same |

---

## 📖 How to Use the Files

1. **Open the `.sql` file** for the agent you want in any editor (VS Code, Notepad++, etc.)
2. **Read layer by layer** — each section explains the why and what
3. **Copy-paste commands** into your terminal (PowerShell / bash) one by one
4. **Check off the checklist** at the bottom once installed
5. **Done!** Your agent is ready to use

> 💡 **Tip:** All files use SQL comment format. Open in any SQL editor (DBeaver, pgAdmin, DataGrip) for nice syntax highlighting — or simply view as plain text.

---

## 📋 Agent Comparison Matrix

| Feature | pi.dev | Claude Code | Codex CLI | Gemini CLI | Aider | Cursor CLI |
|---|---|---|---|---|---|---|
| **Open Source** | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **Free Tier** | ✅ | ❌ | ❌ | ✅ 60/min | Pay-per-use | Limited |
| **No Runtime Needed** | ❌ | ✅ native | ✅ native | ❌ | ❌ | ✅ native |
| **Git Integration** | Basic | Via MCP | Via MCP | Via MCP | **Native** | Via MCP |
| **MCP Support** | ✅ | ✅ | ✅ | ✅ | Via tools | ✅ |
| **Multi-Model** | ✅ | Via custom | Via custom | Via custom | ✅ **100+** | ✅ |
| **CI/CD Ready** | ❌ | `-p` flag | `exec` | `-p` flag | `--message` | `-p` flag |
| **Windows Native** | Via npm | ✅ | ✅ | Via npm | Via pip | ✅ |
| **Context Window** | ~200K | ~200K | ~200K | **1M** | Varies | ~200K |

---

## 🔗 Resources

| Resource | URL |
|---|---|
| DeepSeek API Key | [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys) |
| Skills Directory | [skills.sh](https://www.skills.sh) |
| MCP Documentation | [modelcontextprotocol.io](https://modelcontextprotocol.io) |
| Git for Windows | [git-scm.com](https://git-scm.com/download/win) |
| Node.js | [nodejs.org](https://nodejs.org) |
| Python | [python.org](https://python.org) |

---

## 📝 License

MIT — feel free to use, modify, and share. If it helps, give the repo a ⭐!

---

**Happy coding with AI agents! 🤖🚀**
