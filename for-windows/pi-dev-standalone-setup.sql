-- ============================================================================
-- pi.dev Standalone Setup Guide (Manual — No Scripts) — WINDOWS NATIVE
-- ============================================================================
-- Sprint 27 — Juli 2026 | Exploration
--
-- This file is a complete, step-by-step guide to install pi.dev and the full
-- recommended stack MANUALLY on WINDOWS (PowerShell) — no WSL needed.
-- Each section is an SQL comment block. Copy-paste each PowerShell block.
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
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - Windows 10 build 1809+ / Windows 11
 *   - PowerShell 5.1+ (bawaan Windows)
 *   - Git for Windows (download dari https://git-scm.com)
 *
 * Jalankan SEMUA command di PowerShell (Klik Kanan → Run as Administrator
 * untuk install global tools).
 */

-- Cek Windows version
-- PS> [System.Environment]::OSVersion.Version
-- PS> winver

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- PS> Get-CimInstance Win32_ComputerSystem | Select TotalPhysicalMemory

-- Cek disk — butuh ~2GB free
-- PS> Get-PSDrive C

-- Install Git for Windows kalo belum ada
--   Download: https://git-scm.com/download/win
--   Install dengan opsi: "Git from the command line and also from 3rd-party software"
--   Centang: "Use Git and optional Unix tools from Command Prompt"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS — pi.dev butuh Node.js 18+                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Di Windows ada 3 cara install Node.js:
 *   1. nvm-windows (RECOMMENDED) — ganti versi Node.js dengan mudah
 *   2. fnm (via PowerShell script)
 *   3. Installer langsung dari nodejs.org
 *
 * Kita pake nvm-windows karena paling simpel di Windows.
 */

-- Step 1.1: Install nvm-windows
--   Download: https://github.com/coreybutler/nvm-windows/releases
--   Pilih nvm-setup.exe → install → NEXT semua
--   TUTUP & BUKA ULANG PowerShell setelah install

-- Step 1.2: Install Node.js 22 (LTS)
-- PS> nvm install 22
-- PS> nvm use 22

-- Step 1.3: Verifikasi
-- PS> node --version           -- harus v22.x.x
-- PS> npm --version            -- harus 10.x.x

-- Step 1.4: KONFIGURASI npm global path (cegah permission error)
-- PS> mkdir $env:USERPROFILE\.npm-global
-- PS> npm config set prefix "$env:USERPROFILE\.npm-global"
-- PS> [Environment]::SetEnvironmentVariable("Path", "$env:USERPROFILE\.npm-global" + ";$env:USERPROFILE\AppData\Roaming\npm;node_modules\.bin;" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
--   TUTUP & BUKA ULANG PowerShell

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: PI.DEV BINARY — Install agent inti                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * pi.dev adalah open-source terminal coding agent.
 * Bisa baca codebase, eksekusi shell, edit file, search, pake multiple models.
 *
 * Docs:    https://pi.dev
 * GitHub:  https://github.com/earendil-works/pi
 */

-- Step 2.1: Install pi.dev secara global
-- PS> npm install -g @earendil-works/pi-coding-agent

-- Step 2.2: Verifikasi
-- PS> pi --version

-- Step 2.3: Test jalan (first run akan minta signup — gratis)
-- PS> cd ~
-- PS> pi "Hello, what can you do?"

-- Step 2.4: Basic commands reference
-- PS> pi                        -- interactive session
-- PS> pi "query here"           -- one-shot query
-- PS> pi --model <model> "..."  -- pakai model spesifik

-- Step 2.5: Fix "pi: command not found" (kalo muncul)
-- PS> $npmPath = npm root -g
-- PS> [Environment]::SetEnvironmentVariable("Path", $npmPath + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")
--   TUTUP & BUKA ULANG PowerShell

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: PI-SETUP — Safety guard + themes + file review + sync          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * pi-setup nambahin:
 *   🔒 Safety guard      — konfirmasi sebelum command berbahaya
 *   📝 File review       — lihat semua file yang diubah Pi, accept/undo
 *   🎨 10 themes         — dracula, nord, tokyo-night, dll
 *   📊 Token counter     — pantau usage context window
 *   🤖 Local models      — konek ke Ollama / LM Studio
 *   🔄 Sync backup       — backup config Pi ke GitHub
 *
 * GitHub: https://github.com/abhinand5/pi-setup
 */

-- Step 3.1: Clone pi-setup
-- PS> git clone https://github.com/abhinand5/pi-setup.git $env:USERPROFILE\pi-setup

-- Step 3.2: Install
-- PS> cd $env:USERPROFILE\pi-setup
-- PS> bash install.sh --restore --copy-config
--   CATATAN: install.sh perlu Git Bash (udah include pas install Git for Windows)
--   Kalo ga bisa: buka Git Bash terpisah dan jalankan dari sana

-- Step 3.3: Fix path buat pi binary
-- PS> [Environment]::SetEnvironmentVariable("PI_REAL_BIN", "$env:USERPROFILE\AppData\Roaming\npm\pi.cmd", "User")

-- Step 3.4: Commands yang bisa dipakai di dalam Pi setelah pi-setup
--   /filechanges              → lihat semua file yang diubah + diff
--   /filechanges-accept        → keep semua perubahan
--   /filechanges-decline       → undo semua perubahan
--   /safety                    → cek safety guard on/off
--   /context                   → cek usage context window
--   /local-models              → tambah local model (Ollama/LM Studio)
--   /theme                     → ganti tema (10 pilihan)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: DEEPSEEK PROVIDER — Model termurah buat daily coding           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Kenapa DeepSeek?
 *   - Termurah: $0.14/$0.28 per 1M token (input/output)
 *   - 500M token GRATIS pas signup
 *   - deepseek-v4-flash: cepat + bagus
 *   - Support OpenAI-compatible API → compatible sama pi.dev
 *
 * Docs:     https://api-docs.deepseek.com/
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 4.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys
--   Sign up (gratis) → copy API key (format: sk-...)

-- Step 4.2: Simpan permanent di Windows Environment Variables
-- PS> [Environment]::SetEnvironmentVariable("DEEPSEEK_API_KEY", "sk-your-deepseek-key-here", "User")
--   TUTUP & BUKA ULANG PowerShell

-- Step 4.3: Verifikasi key jalan
-- PS> $headers = @{ Authorization = "Bearer $env:DEEPSEEK_API_KEY" }
-- PS> Invoke-RestMethod -Uri "https://api.deepseek.com/v1/models" -Headers $headers

-- Step 4.4: Cara pakai di pi.dev
-- PS> pi --model deepseek-v4-flash "Jelaskan codebase ini"
--
--   Atau ganti model mid-session di dalam Pi:
--   /model deepseek-v4-flash

-- Step 4.5: Model lain dari DeepSeek (referensi)
--   deepseek-v4-flash       → cepat, murah, daily use   ($0.14/$0.28)
--   deepseek-chat-v3        → reasoning lebih bagus      ($0.27/$1.10)
--   deepseek-reasoner       → deep thinking, math/logic   (price TBD)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 1 — context-mode (Hemat Context Window)                ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.1: Install
-- PS> pi install npm:context-mode

-- Step 5.2: Cara pakai (di dalam Pi session)
--   /context-mode on         → enable auto-compress
--   /context-mode smart      → smart compression (rekomendasi)
--   /context-mode status     → cek mode sekarang

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 2 — pi-deepseek-search (Web Search buat DeepSeek)     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.3: Install
-- PS> pi install npm:pi-deepseek-search

-- Step 5.4: Cara pakai (di dalam Pi session — tanya natural aja)
--   "Search for the latest React 19 API changes and update our hooks"
--   "Find the npm package for PostgreSQL connection pooling"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 3 — pi-codex-goal (Goal Mode)                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.5: Install
-- PS> pi install npm:pi-codex-goal

-- Step 5.6: Cara pakai (di dalam Pi session)
--   /goal "Add user authentication with JWT to this app"
--   /goal "Set up CI/CD with GitHub Actions — budget 50K tokens"
--   /goal    → Lihat objective saat ini + status + token usage

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 4 — rpiv-ask-user-question (Interactive Decisions)    ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 5.7: Install
-- PS> pi install npm:@juicesharp/rpiv-ask-user-question

-- Step 5.8: Cara pakai (otomatis aktif — Pi bakal nanya)
--   /ask-user-question mode always     → tanya SEMUA keputusan
--   /ask-user-question mode blockers   → tanya hanya pas buntu (rekomendasi)
--   /ask-user-question mode off        → biarin Pi nebak

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: GRILLING SKILL — Stress-Test Rencana & Desain                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- Step 6.1: Install
-- PS> npx skills add https://github.com/mattpocock/skills --skill grilling

-- Step 6.2: Cara pakai (di dalam Pi session — trigger dengan "grill me")
--   "Mau migrasi dari PostgreSQL 10 ke 16 — grill me on the migration plan"
--   "Rencana normalisasi database HIS — grill me"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
-- ============================================================================

-- [ ] Git for Windows        → git --version
-- [ ] nvm-windows            → nvm version
-- [ ] Node.js 22             → node --version
-- [ ] pi.dev binary          → pi --version
-- [ ] pi-setup               → ls $env:USERPROFILE\pi-setup
-- [ ] DeepSeek key           → echo $env:DEEPSEEK_API_KEY
-- [ ] context-mode           → pi list
-- [ ] deepseek-search        → pi list
-- [ ] codex-goal             → pi list
-- [ ] ask-user-question      → pi list
-- [ ] grilling skill         → ls $env:USERPROFILE\.pi\agent\skills\

-- ============================================================================
-- DAILY WORKFLOW — Contoh session Pi di Windows
-- ============================================================================

-- PS> cd C:\Users\RYZEN\Desktop\SQL-QUERY-JOB
-- PS> pi

-- # Di dalam Pi session:
-- /context-mode smart
-- "Jelaskan struktur database project ini"
-- "Cari semua query yang pake SELECT * dan ganti"
-- /goal "Normalisasi tabel t_bayar"
-- "Grill me on this indexing strategy"

-- ============================================================================
-- TROUBLESHOOTING (Windows-specific)
-- ============================================================================

-- Problem: nvm not recognized
-- Fix:     TUTUP & BUKA ULANG PowerShell setelah install nvm-windows

-- Problem: pi: command not found
-- Fix:     $npmPath = npm root -g
--          [Environment]::SetEnvironmentVariable("Path", $npmPath + ";" + [Environment]::GetEnvironmentVariable("Path", "User"), "User")

-- Problem: npm install gagal (permission error)
-- Fix:     Run PowerShell as Administrator ATAU configure npm prefix (Step 1.4)

-- Problem: Execution policy blocks scripts
-- Fix:     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

-- Problem: pi-setup install.sh ga jalan
-- Fix:     Buka Git Bash (ada di Start Menu setelah install Git for Windows)
--          cd ~/pi-setup && ./install.sh --restore --copy-config

-- Problem: Path terlalu panjang (Windows 260 char limit)
-- Fix:     Enable long paths:
--          reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f
--          (Run as Administrator)

-- ============================================================================
-- UNINSTALL
-- ============================================================================

-- PS> npm uninstall -g @earendil-works/pi-coding-agent
-- PS> Remove-Item -Recurse -Force $env:USERPROFILE\pi-setup
-- PS> Remove-Item -Recurse -Force $env:USERPROFILE\.pi

-- ============================================================================
-- RESOURCES
-- ============================================================================

-- pi.dev docs:       https://pi.dev
-- pi.dev GitHub:     https://github.com/earendil-works/pi
-- pi-setup GitHub:   https://github.com/abhinand5/pi-setup
-- nvm-windows:       https://github.com/coreybutler/nvm-windows
-- DeepSeek key:      https://platform.deepseek.com/api_keys
-- Skills directory:  https://www.skills.sh/
-- Git for Windows:   https://git-scm.com/download/win

-- ============================================================================
-- EOF — Selamat ngoding dengan Pi di Windows! 🚀
-- ============================================================================
