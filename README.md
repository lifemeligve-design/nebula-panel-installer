<!-- ============================================================ -->
<!--  NEBULA AI PLATFORM — README                                 -->
<!-- ============================================================ -->

<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

# 🌌 Nebula AI Platform

### The all-in-one Telegram bot &amp; management platform — installed in **one line**

<p align="center">
  <em>Bot · Admin Panel · VPN &amp; Servers · Crypto · Referrals · Broadcasts · Anti-fraud — all in one closed, licensed image.</em>
</p>

<p align="center">
  <img alt="Version"   src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Platform"  src="https://img.shields.io/badge/Ubuntu-22 · 24 · 26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker"    src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License"   src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>

<p align="center">
  <a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a>
</p>

</div>

---

## ⚡ One-Line Install

Spin up the entire platform on a fresh **Ubuntu** server with a single command:

```bash
bash <(curl -Ls https://nebulapanel.cloud/install)
```

That's it. A beautiful graphical installer opens — pick your language, hit **Install**, and everything (Docker, database, panel, bot) is provisioned automatically. When it's done you get a login link, a username, and a password. 🎉

```
   ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗      █████╗
   ████╗  ██║██╔════╝██╔══██╗██║   ██║██║     ██╔══██╗
   ██╔██╗ ██║█████╗  ██████╔╝██║   ██║██║     ███████║
   ██║╚██╗██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║
   ██║ ╚████║███████╗██████╔╝╚██████╔╝███████╗██║  ██║
   ╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
        ◈ RAM · CPU · Disk      N E B U L A   A I
   ────────────────────────────────────────────────
     ◆  Install / Setup
     ↑  Update
     ⬢  Enable HTTPS (SSL)
     ◈  Status
     ✕  Exit
   🌍  Internet · 🤖 Telegram · ⑂ Git · ⚡ Tech
```

---

## ✨ Highlights

| | Feature | Description |
|---|---|---|
| 🚀 | **One-line install** | Fully automatic — no coding, no config files to edit. |
| 🎨 | **Graphical installer** | Animated cosmic TUI, arrow-key menu, 6 languages. |
| 🐳 | **Docker-based** | Ships as a sealed, compiled image — your data stays yours. |
| 🔒 | **Free HTTPS** | One command for SSL — with a domain *or* even on a bare IP. |
| 🌍 | **Multilingual panel** | Full admin panel in 7 languages (fa · en · ar · tr · zh · de · sv). |
| 🔑 | **License system** | Professional Ed25519-signed licensing, bound to your bot. |
| ♻️ | **Effortless updates** | `nebula update` pulls the newest version, keeps your data. |
| 💾 | **Backups built-in** | Your database travels with you across servers. |

---

## 🛠 Management Commands

After installation, manage everything from the graphical menu — or straight from the shell:

```bash
nebula              # open the graphical menu
nebula update       # update to the newest version
nebula ssl auto     # free HTTPS on this server's IP (no domain needed)
nebula ssl mydomain.com   # free HTTPS for your domain
nebula status       # service status, version, panel URL
nebula logs         # live logs
nebula password     # show the panel password
nebula restart      # restart the platform
```

---

## 🔒 Enable HTTPS

**With your own domain** — point an `A` record at your server, then:

```bash
nebula ssl panel.yourdomain.com
```

**Without a domain** — get a valid certificate right on your IP:

```bash
nebula ssl auto
```

Both use free **Let's Encrypt** certificates and auto-redirect `http → https`.

---

## 📦 What's Inside

Nebula AI Platform is a complete ecosystem:

- 🤖 **Telegram Bot** — gigabyte wallet, tasks &amp; rewards, referral program
- 🖥️ **Admin Panel** — a modern, multilingual dashboard for everything
- 🌐 **VPN &amp; Servers** — subscription &amp; config management
- 💰 **Crypto payments** — in-bot checkout &amp; withdrawals
- 📢 **Broadcasts** — reach all your users at once
- 🛡️ **Anti-fraud &amp; anti-bot** — screenshot verification, promo-bot blocking
- 👥 **Agents** — limited sub-admin logins with per-section permissions

---

## 💻 Requirements

- A server running **Ubuntu 22.04 / 24.04 / 26.04**
- Root access (the installer sets up everything else)
- A Telegram bot token (added later, from inside the panel)

---

## 🆘 Support

<div align="center">

Questions, updates, and announcements:

**[→ Join our Telegram channel: @NebulaAiHQ](https://t.me/NebulaAiHQ)**

</div>

---

<div align="center">
<sub>⑂ Engineered by the <b>Nebula AI Team</b></sub>
</div>
