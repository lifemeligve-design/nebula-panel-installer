<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="Price" src="https://img.shields.io/badge/Pro-$5_lifetime-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>The complete, self-hosted Telegram bot & management platform — installed in one line.</h3>
</div>

<div align="center">

**🌐 Language:** **English** · [فارسی](README.fa.md) · [العربية](README.ar.md) · [Türkçe](README.tr.md) · [中文](README.zh.md) · [Deutsch](README.de.md) · [Svenska](README.sv.md)

</div>

---

## 🌌 What is Nebula AI Platform?

**Nebula AI Platform** is an all-in-one, self-hosted ecosystem for running a professional Telegram service. It bundles a **Telegram bot**, a modern **multilingual admin panel**, **VPN/server management**, **crypto payments**, a **referral system**, **broadcasts**, **anti-fraud tooling**, and a professional **licensing system** — all shipped as a single sealed Docker image and installed with **one command**.

It is built for **non-developers**: run one line on a fresh Ubuntu server and everything (Docker, database, panel, bot service, SSL) is provisioned automatically. Afterwards you manage everything from a graphical menu or the web panel — no code, no config files.

---

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner-hero.svg" alt="Nebula Ecosystem" width="100%"/>
</div>

## ⚡ Quick Install

On a fresh **Ubuntu 22.04 / 24.04 / 26.04** server, run:

```bash
bash <(curl -Ls https://nebulapanel.cloud/install)
```

```
   ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗      █████╗
   ████╗  ██║██╔════╝██╔══██╗██║   ██║██║     ██╔══██╗
   ██╔██╗ ██║█████╗  ██████╔╝██║   ██║██║     ███████║
   ██║╚██╗██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║
   ██║ ╚████║███████╗██████╔╝╚██████╔╝███████╗██║  ██║
   ╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
         N E B U L A   A I   P L A T F O R M
```

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/install-architecture.svg" alt="Install Flow & Architecture" width="100%"/>
</div>

1. Pick your language (English · Türkçe · 中文 · Deutsch · Svenska · Farsi).
2. Choose **Install** — a progress bar shows Docker, config, image pull, and startup.
3. When it finishes you get a **login URL, username, and password**.
4. Open the panel, connect your Telegram bot token, and change your password.

Navigate with **arrow keys** (or number keys / `j`,`k` on mobile & Termux).

---

## 💎 Pricing & License

Nebula AI Platform is **freemium**:

- 🆓 **Free forever:** the core sections — **Dashboard, Users, Groups** — work without any license.
- 💎 **Pro (lifetime):** unlock everything else — Servers & VPN panels, Subscriptions, Follow-guard, Submissions, Broadcasts, Agents, Transactions, Transfers, Referrals, Backup, and License management.

**One-time payment of just $5** to [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot) gives you a **lifetime** Pro license — pay once, use forever. The license is bound to your bot, travels with your backups, and never expires.

**How to buy:** open [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot), send your bot ID (shown in your panel under "My License"), pay $5 in crypto, and receive your key instantly. Paste it into your panel — done.

---

## 🐳 Manual / Docker Install

Prefer to do it by hand, or already have Docker? The platform ships as a pre-built image on Docker Hub: **`weblinuxi/nebula-platform`**.

### Docker Compose

```yaml
services:
  nebula:
    image: weblinuxi/nebula-platform:latest
    container_name: nebula
    restart: unless-stopped
    env_file: [ .env ]
    ports: [ "3000:3000" ]
    volumes: [ nebula-data:/app/data ]
volumes:
  nebula-data:
    name: nebula-data
```

`.env`:

```env
ADMIN_USERNAME=admin
ADMIN_PASSWORD=change_this_now
SESSION_SECRET=replace_with_a_64_char_random_hex
NODE_ENV=production
PORT=3000
DB_PATH=/app/data/bot.db
SECURE_COOKIES=false
BOT_TOKEN=
```

```bash
docker compose up -d
```

---

## 🛠 Management Commands

After installation, the `nebula` command is available on the server:

| Command | What it does |
|---|---|
| `nebula` | Open the graphical management menu |
| `nebula start` / `stop` / `restart` | Start / stop / restart |
| `nebula status` | Service status, version, panel URL (+ HTTPS) |
| `nebula logs` | Follow live logs |
| `nebula update` | Update to newest version (data kept) |
| `nebula password` | Show the panel password |
| `nebula ssl <domain>` | Free HTTPS for a domain |
| `nebula ssl auto` | Free HTTPS on the server IP (no domain) |
| `nebula uninstall` | Remove everything |

---

## 🔒 Enabling HTTPS / SSL

Nebula uses free **Let's Encrypt** certificates with an automatic Nginx reverse proxy.

**With your own domain** — point an `A` record at your server (proxy off / DNS-only), then:

```bash
nebula ssl panel.yourdomain.com
```

**Without a domain** — get a valid certificate on your IP via `sslip.io`:

```bash
nebula ssl auto
```

Both install Nginx + Certbot, issue the certificate, enable secure cookies, and redirect `http → https`.

---

## ✨ Full Feature List

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/platform-overview.svg" alt="All Modules" width="100%"/>
</div>


### Installer & Operations

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key and number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### Admin Panel

✅ Modern, responsive dashboard with live server stats  
✅ 7-language UI (fa · en · ar · tr · zh · de · sv) with full RTL  
✅ Users — balances, history, profiles, avatars  
✅ Tasks & rewards — configurable gigabyte rewards  
✅ Referrals — invite tracking, leaderboards, bonus tiers  
✅ Transactions & transfers — full ledger  
✅ Groups — auto-responses, schedules, stats, locks  
✅ Follow-guard — reclaim rewards / cut subs when users leave a channel  
✅ Subscriptions & VPN panels — server & config management  
✅ Support — in-panel live chat with users  
✅ Submissions — screenshot anti-fraud approvals  
✅ Broadcasts — message all users with live progress  
✅ Emergency notifier — reach users through any bot token  
✅ Anti-bot — blocks promo-bot button spam (even channel-posted ads)  
✅ Agents — limited sub-admins with per-section permissions  
✅ Backups — scheduled, with restore & channel delivery  
✅ Settings — bot control, maintenance mode, messages, password  

### Telegram Bot

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### Security & Licensing

✅ Ed25519-signed licenses — industry-standard asymmetric crypto  
✅ Licenses bound to a specific bot ID (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys cannot be forged on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 Requirements

- A server running **Ubuntu 22.04 / 24.04 / 26.04**
- **Root** access (the installer handles the rest)
- A **Telegram bot token** from [@BotFather](https://t.me/BotFather) — added later, from the panel
- A modern terminal for best graphics (Windows Terminal, iTerm2, most SSH clients, Termux)

---

## 🆘 Support

<div align="center">

Questions, updates, and announcements:

### [→ Join our Telegram: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ Engineered by the Nebula AI Team</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
