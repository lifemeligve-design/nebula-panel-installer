<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<br/>

<p>
  <img alt="Version"  src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu"   src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker"   src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="Node"     src="https://img.shields.io/badge/Node.js-20-3c873a?style=for-the-badge&logo=nodedotjs&logoColor=white">
  <img alt="License"  src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>

<p>
  <a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a>
</p>

<h3>The complete, self-hosted Telegram bot &amp; management platform — installed in one line.</h3>

</div>

---

## 📖 Table of Contents

- [What is Nebula AI Platform?](#-what-is-nebula-ai-platform)
- [Quick Install (one line)](#-quick-install)
- [Manual / Docker Install](#-manual--docker-install)
- [Management Commands](#-management-commands)
- [Enabling HTTPS / SSL](#-enabling-https--ssl)
- [Full Feature List](#-full-feature-list)
- [The Admin Panel](#-the-admin-panel)
- [The Telegram Bot](#-the-telegram-bot)
- [Licensing System](#-licensing-system)
- [Backups &amp; Migration](#-backups--migration)
- [Updating](#-updating)
- [Requirements](#-requirements)
- [FAQ](#-faq)
- [Support](#-support)

---

## 🌌 What is Nebula AI Platform?

**Nebula AI Platform** is an all-in-one, self-hosted ecosystem for running a professional Telegram service. It bundles a **Telegram bot**, a modern **multilingual admin panel**, **VPN/server management**, **crypto payments**, a **referral system**, **broadcasts**, **anti-fraud tooling**, and a professional **licensing system** — all shipped as a single sealed Docker image and installed with **one command**.

It's built for people who are **not developers**: you run one line on a fresh Ubuntu server, and everything (Docker, database, panel, bot service, SSL) is provisioned automatically. Afterwards you manage everything from a beautiful graphical menu or the web panel — no code, no config files.

---

## ⚡ Quick Install

On a fresh **Ubuntu 22.04 / 24.04 / 26.04** server, run:

```bash
bash <(curl -Ls https://nebulapanel.cloud/install)
```

A graphical installer opens:

```
   ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗      █████╗
   ████╗  ██║██╔════╝██╔══██╗██║   ██║██║     ██╔══██╗
   ██╔██╗ ██║█████╗  ██████╔╝██║   ██║██║     ███████║
   ██║╚██╗██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║
   ██║ ╚████║███████╗██████╔╝╚██████╔╝███████╗██║  ██║
   ╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
         N E B U L A   A I   P L A T F O R M
   ──────────────────────────────────────────────────
    ▸  1. 🚀  Install / Setup
       2. ⬆️   Update
       3. 🔒  Enable HTTPS (SSL)
       4. 📊  Status
       ...
   ↑↓ move · ⏎ select · 1-9 pick · q quit
```

1. Pick your language (English · Türkçe · 中文 · Deutsch · Svenska · Farsi).
2. Choose **Install** — a progress bar shows Docker, config, image pull, and startup.
3. When it finishes you get a **login URL, username, and password**.
4. Open the panel, connect your Telegram bot token, and change your password.

That's the whole process. Navigate with **arrow keys** (or number keys / `j`,`k` on mobile & Termux).

---

## 🐳 Manual / Docker Install

Prefer to do it by hand, or already have Docker? The platform ships as a pre-built image on Docker Hub: **`weblinuxi/nebula-platform`**.

### Option A — Docker Compose (recommended)

Create a folder and a `docker-compose.yml`:

```yaml
services:
  nebula:
    image: weblinuxi/nebula-platform:latest
    container_name: nebula
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "3000:3000"
    volumes:
      - nebula-data:/app/data
volumes:
  nebula-data:
    name: nebula-data
```

Create a `.env` next to it:

```env
# Admin panel login (change from the panel later)
ADMIN_USERNAME=admin
ADMIN_PASSWORD=change_this_now

# Security — use a long random string
SESSION_SECRET=replace_with_a_64_char_random_hex

# Runtime
NODE_ENV=production
PORT=3000
DB_PATH=/app/data/bot.db

# Set to true only when behind HTTPS (domain + SSL)
SECURE_COOKIES=false

# Telegram bot token — leave empty; set it from the panel after first login
BOT_TOKEN=
BOT_USERNAME=
```

Then start it:

```bash
docker compose up -d
```

Open `http://YOUR_SERVER_IP:3000/admin/login` and sign in.

### Option B — plain `docker run`

```bash
docker volume create nebula-data
docker run -d --name nebula --restart unless-stopped \
  -p 3000:3000 \
  -e ADMIN_USERNAME=admin \
  -e ADMIN_PASSWORD=change_this_now \
  -e SESSION_SECRET=replace_with_random_hex \
  -e NODE_ENV=production \
  -e DB_PATH=/app/data/bot.db \
  -v nebula-data:/app/data \
  weblinuxi/nebula-platform:latest
```

> **Tip:** the one-line installer does all of the above for you *and* adds the `nebula` management command, SSL automation, and the graphical menu. Manual install is only for advanced users.

---

## 🛠 Management Commands

After installation, the `nebula` command is available on the server:

| Command | What it does |
|---|---|
| `nebula` | Open the graphical management menu |
| `nebula start` | Start the platform |
| `nebula stop` | Stop it |
| `nebula restart` | Restart it |
| `nebula status` | Service status, version, panel URL (+ HTTPS if set) |
| `nebula logs` | Follow live logs |
| `nebula update` | Update to the newest version (data is kept) |
| `nebula version` | Show the installed version |
| `nebula password` | Show the panel password |
| `nebula ssl <domain>` | Free HTTPS for a domain |
| `nebula ssl auto` | Free HTTPS on the server's IP (no domain) |
| `nebula uninstall` | Remove everything |

---

## 🔒 Enabling HTTPS / SSL

Nebula uses free **Let's Encrypt** certificates and sets up an Nginx reverse proxy automatically.

**With your own domain** — point an `A` record at your server (proxy **off** / DNS-only), then:

```bash
nebula ssl panel.yourdomain.com
```

**Without a domain** — get a valid certificate right on your server's IP via `sslip.io`:

```bash
nebula ssl auto
```

Both automatically:
- install Nginx + Certbot,
- issue and install the certificate,
- turn on `SECURE_COOKIES`,
- redirect `http → https`.

Your panel then lives at `https://your-domain` (or `https://<ip>.sslip.io`).

---

## ✨ Full Feature List

### Installer &amp; Operations
- ✅ **One-line install** on Ubuntu 22 / 24 / 26
- ✅ **Graphical animated TUI** — starfield, gradient logo, progress bars
- ✅ **6-language installer** (en · tr · zh · de · sv · Farsi) with saved preference
- ✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)
- ✅ **Docker-based** — sealed, compiled image; your source stays private
- ✅ **Free SSL** for domain or bare IP
- ✅ One-command **updates** and **backups**
- ✅ Built-in `nebula` management CLI

### Admin Panel
- ✅ Modern, responsive dashboard
- ✅ **7-language UI** (fa · en · ar · tr · zh · de · sv) with full RTL support
- ✅ **Users** — balances, history, profiles, avatars
- ✅ **Tasks &amp; rewards** — configurable gigabyte rewards
- ✅ **Referrals** — invite tracking, leaderboards, bonus tiers
- ✅ **Transactions &amp; transfers** — full ledger
- ✅ **Groups management** — auto-responses, schedules, stats, locks
- ✅ **Follow-guard (رصد آنفالو)** — reclaim rewards / cut subs when users leave a channel
- ✅ **Subscriptions &amp; VPN panels** — server &amp; config management
- ✅ **Support** — in-panel live chat with users
- ✅ **Submissions** — screenshot anti-fraud approvals
- ✅ **Broadcasts** — message all users, with live progress
- ✅ **Emergency notifier** — reach users through any bot token
- ✅ **Anti-bot** — blocks promo bots (Binance-style button spam), even channel-posted ads
- ✅ **Agents** — limited sub-admin logins with per-section permissions
- ✅ **Backups** — scheduled, with restore &amp; channel delivery
- ✅ **Settings** — bot control, maintenance mode, messages, password
- ✅ **Bot connection** — set/verify your token from the panel (no env editing)

### Telegram Bot
- ✅ Gigabyte wallet system
- ✅ Missions / tasks with real verification (channel membership, etc.)
- ✅ Referral codes &amp; rewards
- ✅ Crypto checkout &amp; withdrawals
- ✅ Required-channel gating
- ✅ In-bot license purchase flow
- ✅ Group management via `/panel` (anti-spam, anti-bot, locks)

### Security &amp; Licensing
- ✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto
- ✅ Licenses bound to a specific **bot ID** (anti-sharing)
- ✅ Key-issuing only on the vendor's master server
- ✅ Signed keys **cannot be forged** on customer installs
- ✅ Per-buyer key delivery (paid orders *or* manually issued to a Telegram ID)

---

## 🖥️ The Admin Panel

The heart of Nebula. A single dashboard to run everything:

- **Dashboard** — live stats: users, servers, uptime, memory, Node version, server clock.
- **Users / Tasks / Groups** — the free core, always available.
- **Pro sections** — servers &amp; VPN panels, subscriptions, follow-guard, submissions, broadcasts, agents, transactions, transfers, referrals, backup, license management — unlocked by a Pro license.
- **7 languages** with automatic RTL for Persian &amp; Arabic.
- **Agents** — create limited logins that only see the sections you allow.

Everything the bot does is configurable here — you rarely touch the server after install.

---

## 🤖 The Telegram Bot

The bot is the user-facing side:

- Users register, earn gigabytes from tasks, invite friends, and manage subscriptions.
- Real verification (e.g. channel membership) via the Telegram API.
- Crypto payments handled in-bot.
- Group admins get a `/panel` menu inside Telegram with anti-spam, anti-bot, and content locks.

The bot token is **set from the panel** after install (Settings → connect bot). It's stored in the database, so it survives restarts and travels with backups.

---

## 🔑 Licensing System

Nebula uses professional **asymmetric (Ed25519) licensing**:

- The **private key** lives only with the vendor — used to *issue* keys.
- The **public key** ships in the code — it can only *verify*, never create.
- Even though every install has the verification code, **no customer can mint a working license**.
- Each license is tied to a specific **bot ID**, so a key shared to another bot simply won't work.
- The license-management page is hidden on customer installs and only appears on the vendor's master server.

Free sections (dashboard, users, groups) always work. Pro sections require a valid license.

---

## 💾 Backups &amp; Migration

- The database lives in a persistent Docker volume (`nebula-data`), so it survives updates and restarts.
- The **signing secret and vendor key travel with your backup**, so restoring on a new server keeps licenses working.
- Move to a new server anytime: install Nebula, restore your backup, done.

---

## ⬆️ Updating

```bash
nebula update
```

This pulls the newest image from Docker Hub and restarts the container. **Your database, settings, and licenses are kept.** Because builds are automated, every code update is published as a fresh image automatically.

---

## 💻 Requirements

- A server running **Ubuntu 22.04 / 24.04 / 26.04**
- **Root** access (the installer handles everything else)
- A **Telegram bot token** from [@BotFather](https://t.me/BotFather) — added later, from inside the panel
- A modern terminal for the best graphics (Windows Terminal, iTerm2, most SSH clients, Termux)

---

## ❓ FAQ

**Do I need to know how to code?**
No. One line installs everything; the rest is done from a graphical menu and the web panel.

**Is my data safe when I update or move servers?**
Yes — the database is on a persistent volume and travels with your backups.

**Can I use it without a domain?**
Yes. Access via `http://IP:3000`, or get free HTTPS on your IP with `nebula ssl auto`.

**Which languages are supported?**
The installer is in 6 languages; the admin panel is in 7 (Persian, English, Arabic, Turkish, Chinese, German, Swedish).

**Where is the source code?**
The platform ships as a sealed, compiled Docker image. The installer &amp; docs in this repo are open; the application image is distributed under a Pro license.

---

## 🆘 Support

<div align="center">

Questions, updates, and announcements:

### [→ Join our Telegram: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ Engineered by the <b>Nebula AI Team</b></sub><br/>
<sub>© 2026 Nebula AI Platform. All rights reserved.</sub>
</div>
