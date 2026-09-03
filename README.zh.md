<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="Price" src="https://img.shields.io/badge/Pro-$5_lifetime-a855f7?style=for-the-badge">
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

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner-hero.svg" alt="Nebula Ecosystem" width="100%"/>
</div>

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

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/install-architecture.svg" alt="Install Flow & Architecture" width="100%"/>
</div>

1. 选择语言（英语 · 土耳其语 · 中文 · 德语 · 瑞典语 · 波斯语）。
2. 选择**安装**——进度条显示 Docker、配置、拉取镜像和启动。
3. 完成后你会得到**登录网址、用户名和密码**。
4. 打开面板，连接你的 Telegram 机器人令牌，并更改密码。

用**方向键**导航（手机和 Termux 上用数字键 / `j`、`k`）。

---

## 💎 定价与许可

Nebula AI Platform 采用**免费增值**模式：

- 🆓 **永久免费：** 核心板块——**仪表板、用户、群组**——无需任何许可证即可使用。
- 💎 **Pro（终身）：** 解锁其他所有功能——服务器与 VPN 面板、订阅、取关监控、提交、广播、代理、交易、转账、推荐、备份和许可证管理。

向 [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot) **一次性支付仅 5 美元**，即可获得**终身** Pro 许可证——付一次，永久使用。许可证绑定到你的机器人，随备份迁移，永不过期。

**如何购买：** 打开 [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot)，发送你的机器人 ID（在面板"我的许可证"中显示），支付 5 美元加密货币，立即收到密钥。粘贴到面板即可。

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

## 🛠 管理命令

安装后，服务器上可使用 `nebula` 命令：

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

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/platform-overview.svg" alt="All Modules" width="100%"/>
</div>


### 安装与运维

✅ 在 Ubuntu 22 / 24 / 26 上一行安装  
✅ 图形化动画界面——星空、渐变徽标、进度条  
✅ 6 种语言安装程序，记住偏好  
✅ 方向键和数字键导航（适合手机 / Termux）  
✅ 基于 Docker——密封的编译镜像；源码保持私有  
✅ 为域名或纯 IP 提供免费 SSL  
✅ 一条命令更新和备份  
✅ 内置 `nebula` 管理命令  

### 管理面板

✅ 现代响应式仪表板，含实时服务器统计  
✅ 7 语言界面 (fa · en · ar · tr · zh · de · sv)，完整 RTL 支持  
✅ 用户——余额、历史、资料、头像  
✅ 任务与奖励——可配置的 GB 奖励  
✅ 推荐——邀请追踪、排行榜、奖励层级  
✅ 交易与转账——完整账本  
✅ 群组——自动回复、计划、统计、锁定  
✅ 取关监控——用户离开频道时收回奖励 / 切断订阅  
✅ 订阅与 VPN 面板——服务器与配置管理  
✅ 支持——面板内与用户实时聊天  
✅ 提交——截图反欺诈审批  
✅ 广播——向所有用户发送并显示实时进度  
✅ 紧急通知——通过任何机器人令牌联系用户  
✅ 反机器人——拦截广告机器人按钮垃圾信息（含频道发布的广告）  
✅ 代理——按板块权限的受限子管理员  
✅ 备份——计划备份，支持恢复与频道投递  
✅ 设置——机器人控制、维护模式、消息、密码  

### Telegram 机器人

✅ GB 钱包系统  
✅ 带真实验证的任务（频道成员资格等）  
✅ 推荐码与奖励  
✅ 加密货币支付与提现  
✅ 强制频道加入  
✅ 机器人内购买许可证  
✅ 通过 `/panel` 管理群组（反垃圾、反机器人、锁定）  

### 安全与授权

✅ Ed25519 签名许可证——行业标准非对称加密  
✅ 许可证绑定到特定机器人 ID（防共享）  
✅ 仅在供应商主服务器上签发密钥  
✅ 签名密钥无法在客户安装上伪造  
✅ 按买家交付密钥（付费订单或按 Telegram ID 手动）  

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
