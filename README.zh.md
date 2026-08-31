<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-Pro-a855f7?style=for-the-badge">
</p>
<p><a href="https://t.me/NebulaAiHQ"><img alt="Telegram" src="https://img.shields.io/badge/Telegram-@NebulaAiHQ-229ED9?style=for-the-badge&logo=telegram&logoColor=white"></a></p>
<h3>完整的自托管 Telegram 机器人与管理平台 — 一行命令即可安装。</h3>
</div>

<div align="center">

**🌐 Language:** [English](README.md) · [فارسی](README.fa.md) · [العربية](README.ar.md) · [Türkçe](README.tr.md) · **中文** · [Deutsch](README.de.md) · [Svenska](README.sv.md)

</div>

---

## 🌌 什么是 Nebula AI Platform？

**Nebula AI Platform** 是一个一体化、自托管的生态系统，用于运行专业的 Telegram 服务。它集成了 **Telegram 机器人**、现代**多语言管理面板**、**VPN/服务器管理**、**加密货币支付**、**推荐系统**、**广播**、**反欺诈工具**和专业的**许可证系统**——全部作为单个密封的 Docker 镜像，**一条命令**即可安装。

它为**非开发者**打造：在全新的 Ubuntu 服务器上运行一行命令，一切（Docker、数据库、面板、机器人服务、SSL）都会自动配置。之后你可以通过图形菜单或 Web 面板管理一切——无需代码，无需配置文件。

---

## ⚡ 快速安装

在全新的 **Ubuntu 22.04 / 24.04 / 26.04** 服务器上运行：

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

1. 选择语言（英语 · 土耳其语 · 中文 · 德语 · 瑞典语 · 波斯语）。
2. 选择**安装**——进度条显示 Docker、配置、拉取镜像和启动。
3. 完成后你会得到**登录网址、用户名和密码**。
4. 打开面板，连接你的 Telegram 机器人令牌，并更改密码。

用**方向键**导航（手机和 Termux 上用数字键 / `j`、`k`）。

---

## 🐳 手动 / Docker 安装

想手动操作，或已经装了 Docker？平台以预构建镜像发布在 Docker Hub：**`weblinuxi/nebula-platform`**。

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

## 🛠 管理命令

安装后，服务器上可使用 `nebula` 命令：

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

## 🔒 启用 HTTPS / SSL

Nebula 使用免费的 **Let's Encrypt** 证书并自动配置 Nginx 反向代理。

**使用你的域名**——将 `A` 记录指向你的服务器（关闭代理 / 仅 DNS），然后：

```bash
nebula ssl panel.yourdomain.com
```

**没有域名**——通过 `sslip.io` 在你的 IP 上获取有效证书：

```bash
nebula ssl auto
```

两者都会安装 Nginx + Certbot、签发证书、启用安全 cookie，并重定向 `http → https`。

---

## ✨ 完整功能列表

### 安装与运维

✅ One-line install on Ubuntu 22 / 24 / 26  
✅ Graphical animated TUI — starfield, gradient logo, progress bars  
✅ 6-language installer with saved preference  
✅ Arrow-key **and** number-key navigation (mobile / Termux friendly)  
✅ Docker-based — sealed, compiled image; source stays private  
✅ Free SSL for a domain or a bare IP  
✅ One-command updates and backups  
✅ Built-in `nebula` management CLI  

### 管理面板

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

### Telegram 机器人

✅ Gigabyte wallet system  
✅ Missions / tasks with real verification (channel membership, etc.)  
✅ Referral codes & rewards  
✅ Crypto checkout & withdrawals  
✅ Required-channel gating  
✅ In-bot license purchase flow  
✅ Group management via `/panel` (anti-spam, anti-bot, locks)  

### 安全与授权

✅ **Ed25519-signed licenses** — industry-standard asymmetric crypto  
✅ Licenses bound to a specific **bot ID** (anti-sharing)  
✅ Key issuing only on the vendor master server  
✅ Signed keys **cannot be forged** on customer installs  
✅ Per-buyer key delivery (paid orders or manual by Telegram ID)  

---

## 💻 系统要求

- 运行 **Ubuntu 22.04 / 24.04 / 26.04** 的服务器
- **Root** 权限（安装程序处理其余部分）
- 来自 [@BotFather](https://t.me/BotFather) 的 **Telegram 机器人令牌**——稍后从面板添加
- 现代终端以获得最佳图形（Windows Terminal、iTerm2、大多数 SSH 客户端、Termux）

---

## 🆘 支持

<div align="center">

问题、更新和公告：

### [→ 加入我们的 Telegram：@NebulaAiHQ](https://t.me/NebulaAiHQ)

</div>

---

<div align="center">
<sub>⑂ 由 Nebula AI 团队开发</sub><br/>
<sub>© 2026 Nebula AI Platform.</sub>
</div>
