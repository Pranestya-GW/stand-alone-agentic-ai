-- ============================================================================
-- pi.dev Standalone Setup Guide (Manual — No Scripts)
-- ============================================================================
-- 
-- This file is a complete, step-by-step guide to install pi.dev and the full
-- recommended stack MANUALLY — no shell scripts, just copy-paste each block.
-- 
-- Each section is an SQL comment block. Run the commands inside one by one
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
 * ║  LAYER 0: PREREQUISITES — Pastikan environment siap                      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Requirements:
 *   - WSL2 / Ubuntu 22.04+
 *   - curl (sudo apt-get install -y curl)
 *   - git  (sudo apt-get install -y git)
 */

-- Cek OS — harus Linux/WSL
-- $ uname -a

-- Cek RAM — minimal 4GB, rekomendasi 8GB+
-- $ free -h

-- Cek disk — butuh ~2GB free
-- $ df -h ~

-- Install curl & git kalo belum ada
-- $ sudo apt-get update && sudo apt-get install -y curl git

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 1: NODE.JS — pi.dev butuh Node.js 18+                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Kita pake fnm (Fast Node Manager) — lebih ringan dari nvm, lebih cepat.
 * Kenapa fnm? Bisa ganti-ganti versi Node.js dengan mudah, cocok buat
 * development environment yang butuh multiple versions.
 */

-- Step 1.1: Install fnm
-- $ curl -fsSL https://fnm.vercel.app/install | bash

-- Step 1.2: Reload shell (atau tutup-buka terminal)
-- $ source ~/.bashrc
--   ATAU manual:
-- $ export PATH="$HOME/.local/share/fnm:$PATH"
-- $ eval "$(fnm env)"

-- Step 1.3: Install Node.js 22 (LTS — paling stabil buat pi.dev)
-- $ fnm install 22
-- $ fnm use 22
-- $ fnm default 22          -- biar permanen, ga perlu ketik ulang tiap buka terminal

-- Step 1.4: Verifikasi
-- $ node --version           -- harus v22.x.x
-- $ npm --version            -- harus 10.x.x

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 2: PI.DEV BINARY — Install agent inti                             ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * pi.dev adalah open-source terminal coding agent.
 * Bisa baca codebase, eksekusi bash, edit file, search, pake multiple models.
 *
 * Docs:    https://pi.dev
 * GitHub:  https://github.com/earendil-works/pi
 */

-- Step 2.1: Install pi.dev secara global
-- $ npm install -g @earendil-works/pi-coding-agent

-- Step 2.2: Verifikasi
-- $ pi --version             -- harus menampilkan versi

-- Step 2.3: Test jalan (first run akan minta signup — gratis)
-- $ cd ~
-- $ pi "Hello, what can you do?"

-- Step 2.4: Basic commands reference
-- $ pi                        -- interactive session
-- $ pi "query here"           -- one-shot query
-- $ pi --model <model> "..."  -- pakai model spesifik

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 3: PI-SETUP — Safety guard + themes + file review + sync          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * pi-setup nambahin:
 *   🔒 Safety guard      — konfirmasi sebelum command berbahaya (rm -rf, force push, sudo)
 *   📝 File review       — lihat semua file yang diubah Pi, accept/undo
 *   🎨 10 themes         — dracula, nord, tokyo-night, catppuccin, dll
 *   📊 Token counter     — pantau usage context window real-time
 *   🤖 Local models      — konek ke Ollama / LM Studio
 *   🔄 Sync backup       — backup config Pi ke GitHub
 *
 * GitHub: https://github.com/abhinand5/pi-setup
 */

-- Step 3.1: Clone pi-setup
-- $ git clone https://github.com/abhinand5/pi-setup.git ~/pi-setup

-- Step 3.2: Install
-- $ cd ~/pi-setup
-- $ ./install.sh --restore --copy-config

-- Step 3.3: Fix warning "no existing Pi binary found" (kalo muncul)
-- $ echo 'export PI_REAL_BIN=$HOME/.local/share/fnm/node-versions/v22.14.0/installation/bin/pi' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 3.4: Commands yang bisa dipakai di dalam Pi setelah pi-setup
--   /filechanges              → lihat semua file yang diubah + diff
--   /filechanges-accept        → keep semua perubahan
--   /filechanges-decline       → undo semua perubahan
--   /safety                    → cek safety guard on/off
--   /context                   → cek usage context window
--   /local-models              → tambah local model (Ollama/LM Studio)
--   /theme                     → ganti tema (10 pilihan)
--   /welcome updates on        → update notice pas startup

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 4: DEEPSEEK PROVIDER — Model termurah buat daily coding           ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Kenapa DeepSeek?
 *   - Termurah: $0.14/$0.28 per 1M token (input/output)
 *   - 500M token GRATIS pas signup
 *   - deepseek-v4-flash: cepat + bagus buat daily coding
 *   - Support OpenAI-compatible API → compatible sama pi.dev
 *
 * Docs:     https://api-docs.deepseek.com/
 * API Base: https://api.deepseek.com/v1
 * Key:      https://platform.deepseek.com/api_keys
 */

-- Step 4.1: Dapatkan API key
--   Buka: https://platform.deepseek.com/api_keys
--   Sign up (gratis) → copy API key (format: sk-...)

-- Step 4.2: Simpan permanent di ~/.bashrc
-- $ echo 'export DEEPSEEK_API_KEY="sk-your-deepseek-key-here"' >> ~/.bashrc
-- $ source ~/.bashrc

-- Step 4.3: Verifikasi key jalan
-- $ curl https://api.deepseek.com/v1/models \
--     -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Step 4.4: Cara pakai di pi.dev
-- $ pi --model deepseek-v4-flash "Jelaskan codebase ini"
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
 *
 * Masalah: Pi punya context window terbatas (~200K token). Kalo session
 *          panjang, dia bisa "lupa" percakapan awal.
 *
 * Solusi:  context-mode otomatis compress conversation history, jadi
 *          context window tetap efisien meskipun session panjang.
 *
 * Docs: https://pi.dev/packages/context-mode
 */

-- Step 5.1: Install
-- $ pi install npm:context-mode

-- Step 5.2: Cara pakai (di dalam Pi session)
--   /context-mode on         → enable, auto-compress pas context mau penuh
--   /context-mode off        → disable, full context (default)
--   /context-mode smart      → smart compression (rekomendasi)
--   /context-mode manual     → compress hanya pas disuruh
--   /context-mode status     → cek mode sekarang

-- Step 5.3: Kapan pakai?
--   - Refactoring besar (banyak file diubah)
--   - Eksplorasi codebase yang belum dikenal
--   - Session panjang > 30 menit
--   - Debugging kompleks yang butuh banyak bolak-balik

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 2 — pi-deepseek-search (Web Search buat DeepSeek)      ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Masalah: DeepSeek model ga punya akses internet. Jadi kalo nanya soal
 *          library versi terbaru atau API ter-update, jawabannya bisa basi.
 *
 * Solusi:  pi-deepseek-search ngasih DeepSeek kemampuan web search —
 *          dia bakal fetch docs terbaru, npm registry, StackOverflow, dll.
 *
 * Docs: https://pi.dev/packages/pi-deepseek-search
 */

-- Step 5.4: Install
-- $ pi install npm:pi-deepseek-search

-- Step 5.5: Cara pakai (di dalam Pi session — tanya natural aja)
--   "Search for the latest React 19 API changes and update our hooks"
--   "Find the npm package for PostgreSQL connection pooling and add it"
--   "Look up how to configure Tailwind v4 with Vite"
--   "Cari cara terbaru setup Prisma dengan PostgreSQL 16"
--
--   Atau explicit search command:
--   /search "PostgreSQL 16 parallel query improvements"

-- Step 5.6: Kapan pakai?
--   - Kerja dengan library/framework versi baru
--   - Cek docs terbaru sebelum implementasi
--   - Debugging error yang ga known di training data
--   - Research best practice terbaru

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 3 — pi-codex-goal (Goal Mode)                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Masalah: Kalo task-nya besar, Pi bisa lupa objektif di tengah jalan
 *          atau berbelok ke hal lain tanpa selesaiin goal awal.
 *
 * Solusi:  Goal mode — persistent objective tracking ala Codex. Pi bakal:
 *          1. Nyimpen objective + token budget di session (persist across reload/fork)
 *          2. Tracking elapsed time aktif & token usage real-time di footer
 *          3. Kirim steering prompt kalo token budget abis atau goal idle
 *          4. Agent tools: create_goal, get_goal, update_goal (dipanggil otomatis)
 *
 * Status goal: active | paused | budgetLimited | complete
 *
 * Docs: https://github.com/fitchmultz/pi-codex-goal
 */

-- Step 5.7: Install
-- $ pi install npm:pi-codex-goal

-- Step 5.8: Cara pakai (di dalam Pi session)
--   /goal "Add user authentication with JWT to this Express app"
--     → Mulai goal baru (atau replace yang existing — ada konfirmasi)
--   /goal "Set up CI/CD with GitHub Actions — budget 50K tokens"
--     → Goal dengan token budget (agent berhenti pas limit tercapai)
--   /goal
--     → Lihat objective saat ini + status + token usage + elapsed time
--   /goal pause
--     → Pause goal (agent bisa kerjain hal lain dulu)
--   /goal resume
--     → Lanjutin goal yang di-pause
--   /goal clear
--     → Hapus goal (selesai atau batal)
--
--   Agent juga bisa manggil tools ini sendiri:
--     create_goal({ objective, token_budget? })
--     get_goal({})
--     update_goal({ status: "complete" })

-- Step 5.9: Kapan pakai?
--   - Task besar yang butuh multiple session (auth, payment, notification)
--   - Migrasi panjang (JS→TS, REST→GraphQL, PG 10→16)
--   - Mau batasi token per task (budget control)
--   - Normalisasi database besar — track progress antar session
--   - Fitur kompleks yang dikerjain nyicil (pause/resume)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 5: PLUGIN 4 — rpiv-ask-user-question (Interactive Decisions)     ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Masalah: Pi kadang "nebak" keputusan arsitektur — misal milih SQLite
 *          padahal lu maunya PostgreSQL. Bikin frustasi.
 *
 * Solusi:  Plugin ini bikin Pi NANYA dulu sebelum ambil keputusan penting.
 *          Lu yang megang kendali penuh.
 *
 * Docs: https://pi.dev/packages/@juicesharp/rpiv-ask-user-question
 */

-- Step 5.10: Install
-- $ pi install npm:@juicesharp/rpiv-ask-user-question

-- Step 5.11: Cara pakai (otomatis aktif — Pi bakal nanya)
--   Pi: "Should I use PostgreSQL or SQLite for this?"
--   Lu: [1] PostgreSQL  [2] SQLite  [3] Custom...
--
--   Pi: "Which port should the dev server run on? (default: 3000)"
--   Lu: 8080
--
--   Pi: "Keep the existing error handling or rewrite?"
--   Lu: [1] Keep  [2] Rewrite

-- Step 5.12: Konfigurasi mode (di dalam Pi session)
--   /ask-user-question mode always     → tanya SEMUA keputusan (full control)
--   /ask-user-question mode blockers   → tanya hanya pas buntu (rekomendasi)
--   /ask-user-question mode off        → disable, biarin Pi nebak (auto-pilot)

-- Step 5.13: Kapan pakai?
--   - Arsitektur project baru
--   - Code review (pengen kontrol penuh atas perubahan)
--   - Pair programming dengan Pi
--   - Team lead / senior role (keputusan ada di lu, Pi eksekutor)

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  LAYER 6: GRILLING SKILL — Stress-Test Rencana & Desain                 ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 *
 * Masalah: Sebelum refactor besar atau fitur baru, sering ada blind spot —
 *          asumsi yang ga di-challenge, edge case yang ga kepikiran.
 *
 * Solusi:  Grilling skill (by Matt Pocock) bikin Pi "interogasi" lu tentang
 *          setiap aspek rencana. Jalanin semua cabang decision tree sampe
 *          semua keputusan resolved dan lu + Pi punya shared understanding.
 *
 * Docs: https://www.skills.sh/mattpocock/skills/grilling
 */

-- Step 6.1: Install
-- $ npx skills add https://github.com/mattpocock/skills --skill grilling

-- Step 6.2: Cara pakai (di dalam Pi session — trigger dengan "grill me")
--   "I want to add Redis caching to the API — grill me"
--   "Here's my database schema plan — grill me on it"
--   "Rencana normalisasi database HIS — grill me"
--   "Mau migrasi dari PostgreSQL 10 ke 16 — grill me on the migration plan"
--
--   Apa yang terjadi:
--   - Pi interview lu relentlessly tentang setiap aspek
--   - Walk down tiap cabang decision tree
--   - Stop pas semua keputusan resolved
--   - Hasil: crystal-clear shared understanding (lu dan Pi sepaham)

-- Step 6.3: Kapan pakai?
--   - Sebelum refactor besar
--   - Sebelum architectur change
--   - Planning fitur baru yang kompleks
--   - Sebelum migrasi database
--   - Code review major changes
--   - KAPAN AJA dimana "salah itu mahal"

/*
 * ╔═══════════════════════════════════════════════════════════════════════════╗
 * ║  QUICK REFERENCE: Semua Command dalam 1 Tempat                          ║
 * ╚═══════════════════════════════════════════════════════════════════════════╝
 */

-- ============================================================================
-- INSTALLATION CHECKLIST (centang pas udah keinstall)
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
-- DAILY WORKFLOW — Contoh session Pi
-- ============================================================================

-- $ cd ~/SQL-QUERY-JOB                  -- masuk ke project
-- $ pi                                   -- start Pi

-- # Di dalam Pi session:
-- /context-mode smart                    -- hemat context (optional)
-- "Jelaskan struktur database project ini"
-- "Cari semua query yang pake SELECT * dan ganti dengan explicit columns"
-- "Tambah index di kolom yang sering di-join tapi belum ada index-nya"
-- /goal "Normalisasi tabel t_bayar — tambah FK + bersihin orphan rows"
-- "Grill me on this indexing strategy buat vu_kasir_belum_lunas"

-- ============================================================================
-- TROUBLESHOOTING
-- ============================================================================

-- Problem: pi: command not found
-- Fix:     $ export PATH="$HOME/.local/share/fnm/node-versions/v22.14.0/installation/bin:$PATH"
--          $ source ~/.bashrc

-- Problem: Warning: no existing Pi binary found (setelah install pi-setup)
-- Fix:     $ echo 'export PI_REAL_BIN=$HOME/.local/share/fnm/node-versions/v22.14.0/installation/bin/pi' >> ~/.bashrc
--          $ source ~/.bashrc

-- Problem: DeepSeek API key not recognized
-- Fix:     $ echo $DEEPSEEK_API_KEY                          -- cek apakah ke-set
--          $ source ~/.bashrc                                 -- reload
--          $ curl https://api.deepseek.com/v1/models \       -- test API
--              -H "Authorization: Bearer $DEEPSEEK_API_KEY"

-- Problem: npm install gagal (permission error)
-- Fix:     $ mkdir ~/.npm-global
--          $ npm config set prefix '~/.npm-global'
--          $ echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
--          $ source ~/.bashrc

-- Problem: Ollama / local model lambat di WSL
-- Fix:     Bikin %USERPROFILE%\.wslconfig di Windows:
--          [wsl2]
--          memory=16GB
--          processors=8

-- ============================================================================
-- UNINSTALL — Balikin ke vanilla Pi (hapus pi-setup aja, Pi binary tetap ada)
-- ============================================================================

-- $ cd ~/pi-setup
-- $ ./uninstall.sh                     -- hapus extensions, themes, config
-- $ npm uninstall -g @earendil-works/pi-coding-agent   -- hapus Pi binary (optional)

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
-- pi install help:   https://github.com/earendil-works/pi (see packages.md)
-- Full lab docs:      ../agentic-ai-lab/

-- ============================================================================
-- EOF — Selamat ngoding dengan Pi! 🚀
-- ============================================================================
