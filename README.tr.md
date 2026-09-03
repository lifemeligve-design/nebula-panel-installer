<div align="center">

<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner.svg" alt="Nebula AI Platform" width="100%"/>

<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1.0-8b5cf6?style=for-the-badge">
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-22·24·26-6366f1?style=for-the-badge&logo=ubuntu&logoColor=white">
  <img alt="Docker" src="https://img.shields.io/badge/Docker-ready-38bdf8?style=for-the-badge&logo=docker&logoColor=white">
  <img alt="Price" src="https://img.shields.io/badge/Pro-$5_lifetime-a855f7?style=for-the-badge">
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

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/banner-hero.svg" alt="Nebula Ecosystem" width="100%"/>
</div>

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

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/install-architecture.svg" alt="Install Flow & Architecture" width="100%"/>
</div>

1. Dilinizi seçin (İngilizce · Türkçe · Çince · Almanca · İsveççe · Farsça).
2. **Kur**'u seçin — ilerleme çubuğu Docker, yapılandırma, imaj çekme ve başlatmayı gösterir.
3. Bittiğinde bir **giriş URL'si, kullanıcı adı ve şifre** alırsınız.
4. Paneli açın, Telegram bot tokenini bağlayın ve şifrenizi değiştirin.

**Ok tuşlarıyla** gezinin (veya mobil & Termux'ta sayı tuşları / `j`,`k`).

---

## 💎 Fiyat & Lisans

Nebula AI Platform **freemium**'dir:

- 🆓 **Sonsuza dek ücretsiz:** çekirdek bölümler — **Panel, Kullanıcılar, Gruplar** — lisanssız çalışır.
- 💎 **Pro (ömür boyu):** geri kalan her şeyi açar — Sunucular & VPN panelleri, Abonelikler, Takip koruması, Gönderimler, Toplu mesajlar, Temsilciler, İşlemler, Transferler, Referanslar, Yedekleme ve Lisans yönetimi.

[@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot)'a **tek seferlik sadece 5 dolar** ödeme ile **ömür boyu** Pro lisansı alırsınız — bir kez öde, sonsuza dek kullan. Lisans botunuza bağlıdır, yedeklerinizle taşınır ve asla sona ermez.

**Nasıl satın alınır:** [@NebulaAi_HQ_bot](https://t.me/NebulaAi_HQ_bot)'u açın, bot ID'nizi gönderin (panelde "Lisansım" altında görünür), 5 dolar kripto ödeyin ve anahtarınızı anında alın. Panele yapıştırın — tamam.

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

## 🛠 Yönetim Komutları

Kurulumdan sonra sunucuda `nebula` komutu kullanılabilir:

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

<div align="center">
<img src="https://raw.githubusercontent.com/lifemeligve-design/nebula-panel-installer/main/platform-overview.svg" alt="All Modules" width="100%"/>
</div>


### Kurulum & İşlemler

✅ Ubuntu 22 / 24 / 26 üzerinde tek satırda kurulum  
✅ Grafik animasyonlu arayüz — yıldız alanı, degrade logo, ilerleme çubukları  
✅ Tercih kaydeden 6 dilli kurulum  
✅ Ok tuşu ve sayı tuşu ile gezinme (mobil / Termux dostu)  
✅ Docker tabanlı — mühürlü, derlenmiş imaj; kaynak gizli kalır  
✅ Alan adı veya çıplak IP için ücretsiz SSL  
✅ Tek komutla güncelleme ve yedekleme  
✅ Yerleşik `nebula` yönetim aracı  

### Yönetim Paneli

✅ Canlı sunucu istatistikleriyle modern, duyarlı panel  
✅ 7 dilli arayüz (fa · en · ar · tr · zh · de · sv) tam RTL desteğiyle  
✅ Kullanıcılar — bakiye, geçmiş, profiller, avatarlar  
✅ Görevler & ödüller — yapılandırılabilir gigabayt ödülleri  
✅ Referanslar — davet takibi, lider tabloları, bonus kademeleri  
✅ İşlemler & transferler — tam defter  
✅ Gruplar — otomatik yanıtlar, zamanlama, istatistik, kilitler  
✅ Takip koruması — kanaldan ayrılınca ödülü geri al / aboneliği kes  
✅ Abonelikler & VPN panelleri — sunucu & yapılandırma yönetimi  
✅ Destek — panel içi canlı sohbet  
✅ Gönderimler — ekran görüntüsü sahtekârlık onayı  
✅ Toplu mesajlar — canlı ilerlemeyle tüm kullanıcılara  
✅ Acil bildirici — herhangi bir bot tokeniyle kullanıcılara ulaş  
✅ Anti-bot — reklam botu düğme spamını engeller (kanal gönderimleri dahil)  
✅ Temsilciler — bölüm bazlı izinli sınırlı alt yöneticiler  
✅ Yedekler — zamanlanmış, geri yükleme & kanala teslim  
✅ Ayarlar — bot kontrolü, bakım modu, mesajlar, şifre  

### Telegram Botu

✅ Gigabayt cüzdan sistemi  
✅ Gerçek doğrulamalı görevler (kanal üyeliği vb.)  
✅ Referans kodları & ödüller  
✅ Kripto ödeme & çekim  
✅ Zorunlu kanal kontrolü  
✅ Bot içi lisans satın alma  
✅ `/panel` ile grup yönetimi (anti-spam, anti-bot, kilitler)  

### Güvenlik & Lisans

✅ Ed25519 imzalı lisanslar — endüstri standardı asimetrik kripto  
✅ Belirli bir bot ID'sine bağlı lisanslar (paylaşım önleme)  
✅ Anahtar üretimi yalnızca satıcı ana sunucusunda  
✅ İmzalı anahtarlar müşteri kurulumlarında taklit edilemez  
✅ Alıcıya özel anahtar teslimi (ödemeli sipariş veya Telegram ID ile manuel)  

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
