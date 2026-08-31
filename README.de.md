<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="Price" src="https://img.shields.io/badge/Pro-$5_lifetime-a855f7?style=for-the-badge">
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

## 💎 Preise & Lizenz

Nebula AI Platform ist **Freemium**:

- 🆓 **Für immer kostenlos:** die Kernbereiche — **Dashboard, Nutzer, Gruppen** — funktionieren ohne Lizenz.
- 💎 **Pro (lebenslang):** schaltet alles andere frei — Server & VPN-Panels, Abos, Follow-Guard, Einreichungen, Rundrufe, Agenten, Transaktionen, Überweisungen, Empfehlungen, Backup und Lizenzverwaltung.

Eine **einmalige Zahlung von nur 5 $** an [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot) gibt dir eine **lebenslange** Pro-Lizenz — einmal zahlen, für immer nutzen. Die Lizenz ist an deinen Bot gebunden, wandert mit deinen Backups und läuft nie ab.

**So kaufst du:** öffne [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot), sende deine Bot-ID (im Panel unter "Meine Lizenz"), zahle 5 $ in Krypto und erhalte deinen Schlüssel sofort. Ins Panel einfügen — fertig.

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

## 🛠 Verwaltungsbefehle

Nach der Installation ist der Befehl `nebula` auf dem Server verfügbar:

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

✅ Ein-Zeilen-Installation auf Ubuntu 22 / 24 / 26  
✅ Grafische animierte Oberfläche — Sternenfeld, Farbverlauf-Logo, Fortschrittsbalken  
✅ 6-sprachiger Installer mit gespeicherter Auswahl  
✅ Pfeiltasten- und Zifferntasten-Navigation (mobil / Termux-freundlich)  
✅ Docker-basiert — versiegeltes, kompiliertes Image; Quellcode bleibt privat  
✅ Kostenloses SSL für eine Domain oder eine reine IP  
✅ Updates und Backups mit einem Befehl  
✅ Eingebautes `nebula`-Verwaltungstool  

### Admin-Panel

✅ Modernes, responsives Dashboard mit Live-Serverstatistiken  
✅ 7-sprachige Oberfläche (fa · en · ar · tr · zh · de · sv) mit vollem RTL  
✅ Nutzer — Guthaben, Verlauf, Profile, Avatare  
✅ Aufgaben & Belohnungen — konfigurierbare Gigabyte-Belohnungen  
✅ Empfehlungen — Einladungs-Tracking, Ranglisten, Bonusstufen  
✅ Transaktionen & Überweisungen — vollständiges Hauptbuch  
✅ Gruppen — Auto-Antworten, Zeitpläne, Statistiken, Sperren  
✅ Follow-Guard — Belohnung zurückholen / Abo kappen beim Verlassen eines Kanals  
✅ Abos & VPN-Panels — Server- & Konfigurationsverwaltung  
✅ Support — Live-Chat mit Nutzern im Panel  
✅ Einreichungen — Screenshot-Betrugsprüfung  
✅ Rundrufe — an alle Nutzer mit Live-Fortschritt  
✅ Notfall-Benachrichtiger — Nutzer über einen beliebigen Bot-Token erreichen  
✅ Anti-Bot — blockiert Werbebot-Button-Spam (auch als Kanal gepostet)  
✅ Agenten — eingeschränkte Unter-Admins mit Rechten je Bereich  
✅ Backups — geplant, mit Wiederherstellung & Kanal-Zustellung  
✅ Einstellungen — Bot-Steuerung, Wartungsmodus, Nachrichten, Passwort  

### Telegram-Bot

✅ Gigabyte-Wallet-System  
✅ Missionen mit echter Verifizierung (Kanalmitgliedschaft usw.)  
✅ Empfehlungscodes & Belohnungen  
✅ Krypto-Zahlung & Auszahlung  
✅ Pflicht-Kanal-Gating  
✅ Lizenzkauf im Bot  
✅ Gruppenverwaltung über `/panel` (Anti-Spam, Anti-Bot, Sperren)  

### Sicherheit & Lizenzierung

✅ Ed25519-signierte Lizenzen — asymmetrische Krypto nach Industriestandard  
✅ Lizenzen an eine bestimmte Bot-ID gebunden (Anti-Sharing)  
✅ Schlüsselausgabe nur auf dem Anbieter-Masterserver  
✅ Signierte Schlüssel können auf Kundeninstallationen nicht gefälscht werden  
✅ Schlüsselzustellung pro Käufer (bezahlte Bestellung oder manuell per Telegram-ID)  

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
