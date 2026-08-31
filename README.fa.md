<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>پلتفرم کامل و سلف‌هاست ربات تلگرام و مدیریت — نصب با یک خط دستور.</h3>
</div>

<div align="center">

**🌐 Language:** [English](README.md) · **فارسی** · [العربية](README.ar.md) · [Türkçe](README.tr.md) · [中文](README.zh.md) · [Deutsch](README.de.md) · [Svenska](README.sv.md)

</div>

---

## 🌌 Nebula AI Platform چیست؟

**Nebula AI Platform** یک اکوسیستم همه‌کاره و سلف‌هاست برای اجرای یک سرویس حرفه‌ای تلگرام است. این پلتفرم شامل یک **ربات تلگرام**، یک **پنل مدیریت چندزبانه**‌ی مدرن، **مدیریت VPN/سرور**، **پرداخت کریپتو**، **سیستم دعوت**، **پیام همگانی**، **ابزار ضدتقلب** و یک **سیستم لایسنس** حرفه‌ای است — همه در قالب یک ایمیج داکر دربسته و با **یک دستور** نصب می‌شود.

برای **افراد غیربرنامه‌نویس** ساخته شده: یک خط روی سرور اوبونتو تازه اجرا کنید و همه‌چیز (داکر، دیتابیس، پنل، سرویس ربات، SSL) خودکار راه‌اندازی می‌شود. بعد از آن همه‌چیز را از یک منوی گرافیکی یا پنل وب مدیریت می‌کنید — بدون کد، بدون فایل تنظیمات.

---

## ⚡ نصب سریع

روی یک سرور **اوبونتو ۲۲.۰۴ / ۲۴.۰۴ / ۲۶.۰۴** تازه، این را اجرا کنید:

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

۱. زبان خود را انتخاب کنید (انگلیسی · ترکی · چینی · آلمانی · سوئدی · فارسی).
۲. گزینه‌ی **نصب** را انتخاب کنید — یک نوار پیشرفت مراحل داکر، تنظیمات، دریافت ایمیج و راه‌اندازی را نشان می‌دهد.
۳. در پایان یک **لینک ورود، نام کاربری و رمز عبور** دریافت می‌کنید.
۴. پنل را باز کنید، توکن ربات تلگرام را وصل کنید و رمز خود را عوض کنید.

با **کلیدهای جهت‌دار** حرکت کنید (یا کلید عدد / `j`,`k` روی موبایل و ترمکس).

---

## 🐳 نصب دستی / داکر

ترجیح می‌دهید دستی انجام دهید یا از قبل داکر دارید؟ پلتفرم به‌صورت یک ایمیج آماده روی Docker Hub منتشر شده: **`weblinuxi/nebula-platform`**.

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

## 🛠 دستورات مدیریت

بعد از نصب، دستور `nebula` روی سرور در دسترس است:

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

## 🔒 فعال‌سازی HTTPS / SSL

Nebula از گواهی‌های رایگان **Let's Encrypt** به‌همراه پراکسی معکوس خودکار Nginx استفاده می‌کند.

**با دامنه‌ی خودتان** — یک رکورد `A` به سرورتان اشاره دهید (پراکسی خاموش / فقط DNS)، سپس:

```bash
nebula ssl panel.yourdomain.com
```

**بدون دامنه** — یک گواهی معتبر روی IP خود با `sslip.io` بگیرید:

```bash
nebula ssl auto
```

هر دو Nginx + Certbot نصب می‌کنند، گواهی صادر می‌کنند، کوکی امن را فعال می‌کنند و `http → https` را ریدایرکت می‌کنند.

---

## ✨ لیست کامل ویژگی‌ها

### نصب و عملیات

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### پنل مدیریت

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

### ربات تلگرام

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### امنیت و لایسنس

✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto  
✅ Licenses bound to a specific **bot ID** (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys **cannot be forged** on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 نیازمندی‌ها

- سروری با **اوبونتو ۲۲.۰۴ / ۲۴.۰۴ / ۲۶.۰۴**
- دسترسی **root** (نصب‌کننده بقیه را انجام می‌دهد)
- یک **توکن ربات تلگرام** از [@BotFather](https://t.me/BotFather) — بعداً از پنل اضافه می‌شود
- یک ترمینال مدرن برای بهترین گرافیک (Windows Terminal، iTerm2، اکثر کلاینت‌های SSH، Termux)

---

## 🆘 پشتیبانی

<div align="center">

سؤالات، به‌روزرسانی‌ها و اطلاعیه‌ها:

### [→ به تلگرام ما بپیوندید: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ توسعه‌یافته توسط تیم Nebula AI</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
