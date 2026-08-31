<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>Eksiksiz, kendi kendine barındırılan Telegram bot & yönetim platformu — tek satırda kurulur.</h3>
</div>

<div align="center">

**🌐 Language:** [English](README.md) · [فارسی](README.fa.md) · [العربية](README.ar.md) · **Türkçe** · [中文](README.zh.md) · [Deutsch](README.de.md) · [Svenska](README.sv.md)

</div>

---

## 🌌 Nebula AI Platform nedir?

**Nebula AI Platform**, profesyonel bir Telegram hizmeti çalıştırmak için hepsi bir arada, kendi kendine barındırılan bir ekosistemdir. Bir **Telegram botu**, modern **çok dilli yönetim paneli**, **VPN/sunucu yönetimi**, **kripto ödemeleri**, **referans sistemi**, **toplu mesajlar**, **sahtekârlık önleme** ve profesyonel bir **lisans sistemi** içerir — tümü tek bir mühürlü Docker imajı olarak **tek komutla** kurulur.

**Geliştirici olmayanlar** için tasarlanmıştır: yeni bir Ubuntu sunucusunda tek satır çalıştırın, her şey otomatik kurulur. Sonrasında her şeyi grafik menüden veya web panelinden yönetirsiniz — kod yok, yapılandırma dosyası yok.

---

## ⚡ Hızlı Kurulum

Yeni bir **Ubuntu 22.04 / 24.04 / 26.04** sunucusunda şunu çalıştırın:

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

1. Dilinizi seçin (İngilizce · Türkçe · Çince · Almanca · İsveççe · Farsça).
2. **Kur**'u seçin — ilerleme çubuğu Docker, yapılandırma, imaj çekme ve başlatmayı gösterir.
3. Bittiğinde bir **giriş URL'si, kullanıcı adı ve şifre** alırsınız.
4. Paneli açın, Telegram bot tokenini bağlayın ve şifrenizi değiştirin.

**Ok tuşlarıyla** gezinin (veya mobil & Termux'ta sayı tuşları / `j`,`k`).

---

## 🐳 Manuel / Docker Kurulumu

Elle yapmayı mı tercih ediyorsunuz veya Docker'ınız var mı? Platform Docker Hub'da önceden oluşturulmuş bir imaj olarak sunulur: **`weblinuxi/nebula-platform`**.

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

## 🛠 Yönetim Komutları

Kurulumdan sonra sunucuda `nebula` komutu kullanılabilir:

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

## 🔒 HTTPS / SSL Etkinleştirme

Nebula, otomatik Nginx ters proxy ile ücretsiz **Let's Encrypt** sertifikaları kullanır.

**Kendi alan adınızla** — bir `A` kaydını sunucunuza yönlendirin (proxy kapalı / yalnızca DNS), sonra:

```bash
nebula ssl panel.yourdomain.com
```

**Alan adı olmadan** — `sslip.io` ile IP'nizde geçerli sertifika alın:

```bash
nebula ssl auto
```

Her ikisi de Nginx + Certbot kurar, sertifikayı verir, güvenli çerezleri açar ve `http → https` yönlendirir.

---

## ✨ Tüm Özellikler

### Kurulum & İşlemler

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### Yönetim Paneli

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

### Telegram Botu

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### Güvenlik & Lisans

✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto  
✅ Licenses bound to a specific **bot ID** (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys **cannot be forged** on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 Gereksinimler

- **Ubuntu 22.04 / 24.04 / 26.04** çalıştıran bir sunucu
- **Root** erişimi (gerisini kurulum halleder)
- [@BotFather](https://t.me/BotFather)'dan bir **Telegram bot tokeni** — sonra panelden eklenir
- En iyi grafikler için modern bir terminal (Windows Terminal, iTerm2, çoğu SSH istemcisi, Termux)

---

## 🆘 Destek

<div align="center">

Sorular, güncellemeler ve duyurular:

### [→ Telegram'a katılın: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ Nebula AI Ekibi tarafından geliştirildi</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
