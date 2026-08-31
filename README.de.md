<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>Die komplette, selbst gehostete Telegram-Bot- & Verwaltungsplattform — in einer Zeile installiert.</h3>
</div>

<div align="center">

**🌐 Language:** [English](README.md) · [فارسی](README.fa.md) · [العربية](README.ar.md) · [Türkçe](README.tr.md) · [中文](README.zh.md) · **Deutsch** · [Svenska](README.sv.md)

</div>

---

## 🌌 Was ist die Nebula AI Platform?

**Nebula AI Platform** ist ein All-in-one-, selbst gehostetes Ökosystem für einen professionellen Telegram-Dienst. Es vereint einen **Telegram-Bot**, ein modernes **mehrsprachiges Admin-Panel**, **VPN-/Serververwaltung**, **Krypto-Zahlungen**, ein **Empfehlungssystem**, **Rundrufe**, **Betrugsschutz** und ein professionelles **Lizenzsystem** — alles als ein einziges versiegeltes Docker-Image, installiert mit **einem Befehl**.

Es ist für **Nicht-Entwickler** gebaut: eine Zeile auf einem frischen Ubuntu-Server ausführen und alles wird automatisch eingerichtet. Danach verwaltest du alles über ein grafisches Menü oder das Web-Panel — kein Code, keine Konfigurationsdateien.

---

## ⚡ Schnellinstallation

Führe auf einem frischen **Ubuntu 22.04 / 24.04 / 26.04** Server aus:

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

1. Sprache wählen (Englisch · Türkisch · Chinesisch · Deutsch · Schwedisch · Farsi).
2. **Installieren** wählen — ein Fortschrittsbalken zeigt Docker, Konfiguration, Image-Download und Start.
3. Am Ende erhältst du eine **Login-URL, Benutzername und Passwort**.
4. Panel öffnen, Telegram-Bot-Token verbinden und Passwort ändern.

Mit **Pfeiltasten** navigieren (oder Zifferntasten / `j`,`k` auf Mobil & Termux).

---

## 🐳 Manuelle / Docker-Installation

Lieber manuell, oder Docker schon vorhanden? Die Plattform wird als vorgefertigtes Image auf Docker Hub bereitgestellt: **`weblinuxi/nebula-platform`**.

### Docker Compose

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
BOT_USERNAME=
```

```bash
docker compose up -d
```

---

## 🛠 Verwaltungsbefehle

Nach der Installation ist der Befehl `nebula` auf dem Server verfügbar:

| Command | What it does |
|---|---|
| `nebula` | Open the graphical management menu |
| `nebula start` | Start the platform |
| `nebula stop` | Stop it |
| `nebula restart` | Restart it |
| `nebula status` | Service status, version, panel URL (+ HTTPS if set) |
| `nebula logs` | Follow live logs |
| `nebula update` | Update to the newest version (data kept) |
| `nebula version` | Show installed version |
| `nebula password` | Show the panel password |
| `nebula ssl <domain>` | Free HTTPS for a domain |
| `nebula ssl auto` | Free HTTPS on the server IP (no domain) |
| `nebula uninstall` | Remove everything |

---

## 🔒 HTTPS / SSL aktivieren

Nebula nutzt kostenlose **Let's Encrypt**-Zertifikate mit automatischem Nginx-Reverse-Proxy.

**Mit eigener Domain** — richte einen `A`-Eintrag auf deinen Server (Proxy aus / nur DNS), dann:

```bash
nebula ssl panel.yourdomain.com
```

**Ohne Domain** — hol dir ein gültiges Zertifikat auf deiner IP via `sslip.io`:

```bash
nebula ssl auto
```

Beide installieren Nginx + Certbot, stellen das Zertifikat aus, aktivieren sichere Cookies und leiten `http → https` um.

---

## ✨ Vollständige Funktionsliste

### Installer & Betrieb

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### Admin-Panel

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

### Telegram-Bot

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### Sicherheit & Lizenzierung

✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto  
✅ Licenses bound to a specific **bot ID** (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys **cannot be forged** on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 Voraussetzungen

- Ein Server mit **Ubuntu 22.04 / 24.04 / 26.04**
- **Root**-Zugriff (den Rest erledigt der Installer)
- Ein **Telegram-Bot-Token** von [@BotFather](https://t.me/BotFather) — später im Panel hinzugefügt
- Ein modernes Terminal für beste Grafik (Windows Terminal, iTerm2, die meisten SSH-Clients, Termux)

---

## 🆘 Support

<div align="center">

Fragen, Updates und Ankündigungen:

### [→ Tritt unserem Telegram bei: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ Entwickelt vom Nebula AI Team</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
