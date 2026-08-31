<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>منصة تيليجرام الكاملة المُستضافة ذاتيًا لإدارة البوت — تُثبَّت بأمر واحد.</h3>
</div>

<div align="center">

**🌐 Language:** [English](README.md) · [فارسی](README.fa.md) · **العربية** · [Türkçe](README.tr.md) · [中文](README.zh.md) · [Deutsch](README.de.md) · [Svenska](README.sv.md)

</div>

---

## 🌌 ما هي Nebula AI Platform؟

**Nebula AI Platform** هي منظومة متكاملة ومُستضافة ذاتيًا لتشغيل خدمة تيليجرام احترافية. تجمع بين **بوت تيليجرام** و**لوحة إدارة متعددة اللغات** حديثة و**إدارة VPN/الخوادم** و**مدفوعات العملات الرقمية** و**نظام إحالة** و**الرسائل الجماعية** و**أدوات مكافحة الاحتيال** و**نظام ترخيص** احترافي — كلها في صورة Docker مغلقة تُثبَّت **بأمر واحد**.

مصممة لغير المبرمجين: نفّذ سطرًا واحدًا على خادم Ubuntu جديد وسيُهيَّأ كل شيء تلقائيًا. بعدها تدير كل شيء من قائمة رسومية أو لوحة الويب — دون كود ودون ملفات إعداد.

---

## ⚡ التثبيت السريع

على خادم **Ubuntu 22.04 / 24.04 / 26.04** جديد، شغّل:

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

1. اختر لغتك (الإنجليزية · التركية · الصينية · الألمانية · السويدية · الفارسية).
2. اختر **التثبيت** — يعرض شريط التقدم Docker والإعداد وجلب الصورة والتشغيل.
3. عند الانتهاء تحصل على **رابط الدخول واسم المستخدم وكلمة المرور**.
4. افتح اللوحة، اربط توكن بوت تيليجرام، وغيّر كلمة المرور.

تنقّل بمفاتيح **الأسهم** (أو مفاتيح الأرقام / `j`,`k` على الجوال وTermux).

---

## 🐳 التثبيت اليدوي / Docker

تفضّل القيام بذلك يدويًا أو لديك Docker بالفعل؟ تُنشر المنصة كصورة جاهزة على Docker Hub: **`weblinuxi/nebula-platform`**.

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

## 🛠 أوامر الإدارة

بعد التثبيت، يتوفر أمر `nebula` على الخادم:

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

## 🔒 تفعيل HTTPS / SSL

تستخدم Nebula شهادات **Let's Encrypt** المجانية مع بروكسي Nginx عكسي تلقائي.

**بنطاقك الخاص** — وجّه سجل `A` إلى خادمك (البروكسي مطفأ / DNS فقط)، ثم:

```bash
nebula ssl panel.yourdomain.com
```

**بدون نطاق** — احصل على شهادة صالحة على IP عبر `sslip.io`:

```bash
nebula ssl auto
```

كلاهما يثبّت Nginx + Certbot، ويصدر الشهادة، ويفعّل الكوكيز الآمنة، ويعيد التوجيه `http → https`.

---

## ✨ قائمة الميزات الكاملة

### المُثبِّت والعمليات

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### لوحة الإدارة

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

### بوت تيليجرام

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### الأمان والترخيص

✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto  
✅ Licenses bound to a specific **bot ID** (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys **cannot be forged** on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 المتطلبات

- خادم يعمل بـ **Ubuntu 22.04 / 24.04 / 26.04**
- صلاحية **root** (المُثبِّت يتولى الباقي)
- **توكن بوت تيليجرام** من [@BotFather](https://t.me/BotFather) — يُضاف لاحقًا من اللوحة
- طرفية حديثة لأفضل رسوميات (Windows Terminal، iTerm2، معظم عملاء SSH، Termux)

---

## 🆘 الدعم

<div align="center">

الأسئلة والتحديثات والإعلانات:

### [→ انضم إلى تيليجرام: @NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ من تطوير فريق Nebula AI</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
