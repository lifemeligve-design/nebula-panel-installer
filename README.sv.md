<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>Den kompletta, självhostade Telegram-bot- & hanteringsplattformen — installeras på en rad.</h3>
</div>

<div align="center">

**🌐 Language:** [English](README.md) · [فارسی](README.fa.md) · [العربية](README.ar.md) · [Türkçe](README.tr.md) · [中文](README.zh.md) · [Deutsch](README.de.md) · **Svenska**

</div>

---

## 🌌 Vad är Nebula AI Platform?

**Nebula AI Platform** är ett allt-i-ett, självhostat ekosystem för att driva en professionell Telegram-tjänst. Det innehåller en **Telegram-bot**, en modern **flerspråkig adminpanel**, **VPN-/serverhantering**, **kryptobetalningar**, ett **hänvisningssystem**, **utskick**, **bedrägeriskydd** och ett professionellt **licenssystem** — allt levererat som en enda förseglad Docker-avbild, installerad med **ett kommando**.

Den är byggd för **icke-utvecklare**: kör en rad på en ny Ubuntu-server så konfigureras allt automatiskt. Därefter hanterar du allt från en grafisk meny eller webbpanelen — ingen kod, inga konfigurationsfiler.

---

## ⚡ Snabbinstallation

På en ny **Ubuntu 22.04 / 24.04 / 26.04**-server, kör:

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

1. Välj språk (Engelska · Turkiska · Kinesiska · Tyska · Svenska · Farsi).
2. Välj **Installera** — en förloppsindikator visar Docker, konfiguration, avbildshämtning och start.
3. När det är klart får du en **inloggnings-URL, användarnamn och lösenord**.
4. Öppna panelen, anslut din Telegram-bot-token och ändra lösenordet.

Navigera med **piltangenter** (eller siffertangenter / `j`,`k` på mobil & Termux).

---

## 🐳 Manuell / Docker-installation

Föredrar du att göra det för hand, eller har du redan Docker? Plattformen levereras som en färdigbyggd avbild på Docker Hub: **`weblinuxi/nebula-platform`**.

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

## 🛠 Hanteringskommandon

Efter installationen är kommandot `nebula` tillgängligt på servern:

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

## 🔒 Aktivera HTTPS / SSL

Nebula använder gratis **Let's Encrypt**-certifikat med automatisk Nginx omvänd proxy.

**Med din egen domän** — peka en `A`-post mot din server (proxy av / endast DNS), sedan:

```bash
nebula ssl panel.yourdomain.com
```

**Utan domän** — få ett giltigt certifikat på din IP via `sslip.io`:

```bash
nebula ssl auto
```

Båda installerar Nginx + Certbot, utfärdar certifikatet, aktiverar säkra cookies och omdirigerar `http → https`.

---

## ✨ Fullständig funktionslista

### Installer & Drift

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### Adminpanel

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

### Telegram-bot

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### Säkerhet & Licensiering

✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto  
✅ Licenses bound to a specific **bot ID** (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys **cannot be forged** on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 Krav

- En server med **Ubuntu 22.04 / 24.04 / 26.04**
- **Root**-åtkomst (installeraren sköter resten)
- En **Telegram-bot-token** från [@BotFather](https://t.me/BotFather) — läggs till senare från panelen
- En modern terminal för bästa grafik (Windows Terminal, iTerm2, de flesta SSH-klienter, Termux)

---

## 🆘 Support

<div align="center">

Frågor, uppdateringar och meddelanden:

### [→ Gå med i vår Telegram: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ Utvecklad av Nebula AI-teamet</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
