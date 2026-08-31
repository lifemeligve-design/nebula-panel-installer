<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="Price" src="https://img.shields.io/badge/Pro-$5_lifetime-a855f7?style=for-the-badge">
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

## 💎 Pris & Licens

Nebula AI Platform är **freemium**:

- 🆓 **Gratis för alltid:** kärnsektionerna — **Instrumentpanel, Användare, Grupper** — fungerar utan licens.
- 💎 **Pro (livstid):** lås upp allt annat — Servrar & VPN-paneler, Prenumerationer, Follow-guard, Inlämningar, Utskick, Agenter, Transaktioner, Överföringar, Hänvisningar, Säkerhetskopiering och Licenshantering.

En **engångsbetalning på bara 5 $** till [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot) ger dig en **livstids** Pro-licens — betala en gång, använd för alltid. Licensen är bunden till din bot, följer med dina säkerhetskopior och löper aldrig ut.

**Så köper du:** öppna [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot), skicka ditt bot-ID (visas i panelen under "Min licens"), betala 5 $ i krypto och få din nyckel direkt. Klistra in den i panelen — klart.

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

## 🛠 Hanteringskommandon

Efter installationen är kommandot `nebula` tillgängligt på servern:

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

✅ Enradsinstallation på Ubuntu 22 / 24 / 26  
✅ Grafiskt animerat gränssnitt — stjärnfält, gradientlogga, förloppsindikatorer  
✅ Installer på 6 språk med sparat val  
✅ Navigering med piltangenter och siffertangenter (mobil / Termux-vänlig)  
✅ Docker-baserad — förseglad, kompilerad avbild; källkoden förblir privat  
✅ Gratis SSL för en domän eller en ren IP  
✅ Uppdateringar och säkerhetskopior med ett kommando  
✅ Inbyggt `nebula`-hanteringskommando  

### Adminpanel

✅ Modern, responsiv panel med live serverstatistik  
✅ 7-språkigt gränssnitt (fa · en · ar · tr · zh · de · sv) med fullt RTL  
✅ Användare — saldon, historik, profiler, avatarer  
✅ Uppdrag & belöningar — konfigurerbara gigabyte-belöningar  
✅ Hänvisningar — inbjudningsspårning, topplistor, bonusnivåer  
✅ Transaktioner & överföringar — fullständig liggare  
✅ Grupper — autosvar, scheman, statistik, lås  
✅ Follow-guard — återta belöning / kapa prenumerationer när användare lämnar en kanal  
✅ Prenumerationer & VPN-paneler — server- & konfigurationshantering  
✅ Support — livechatt med användare i panelen  
✅ Inlämningar — skärmdump-bedrägerigodkännande  
✅ Utskick — meddela alla användare med live-förlopp  
✅ Nödaviserare — nå användare via valfri bot-token  
✅ Anti-bot — blockerar reklambot-knappspam (även kanalpostade annonser)  
✅ Agenter — begränsade underadmins med behörighet per sektion  
✅ Säkerhetskopior — schemalagda, med återställning & kanalleverans  
✅ Inställningar — botkontroll, underhållsläge, meddelanden, lösenord  

### Telegram-bot

✅ Gigabyte-plånbokssystem  
✅ Uppdrag med riktig verifiering (kanalmedlemskap m.m.)  
✅ Hänvisningskoder & belöningar  
✅ Krypto-betalning & uttag  
✅ Obligatorisk kanal-grindvakt  
✅ Licensköp i boten  
✅ Grupphantering via `/panel` (anti-spam, anti-bot, lås)  

### Säkerhet & Licensiering

✅ Ed25519-signerade licenser — asymmetrisk krypto enligt branschstandard  
✅ Licenser bundna till ett specifikt bot-ID (anti-delning)  
✅ Nyckelutfärdning endast på leverantörens masterserver  
✅ Signerade nycklar kan inte förfalskas på kundinstallationer  
✅ Nyckelleverans per köpare (betald order eller manuellt via Telegram-ID)  

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
