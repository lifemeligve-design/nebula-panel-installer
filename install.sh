#!/usr/bin/env bash
# ============================================================
# Nebula AI Platform — Interactive Installer  (Ubuntu 22/24/26)
# ============================================================
#   bash <(curl -Ls https://nebulapanel.cloud/install)
#
# A menu-driven, multilingual (7 languages) installer & manager.
# Pick options by NUMBER — no need to type commands. Everything is
# configurable later inside the panel (password, username, bot token).
# ============================================================

set -euo pipefail
cd / 2>/dev/null || true

# ---- constants ---------------------------------------------
IMAGE="weblinuxi/nebula-platform:latest"
APP_DIR="/opt/nebula"
COMPOSE_FILE="$APP_DIR/docker-compose.yml"
ENV_FILE="$APP_DIR/.env"
BIN_PATH="/usr/local/bin/nebula"
DEFAULT_PORT=3000
LANG="${NEBULA_LANG:-en}"   # selected UI language (default en)

# ---- colors ------------------------------------------------
if [ -t 1 ]; then
  B=$(printf '\033[1m');  R=$(printf '\033[0m')
  CYAN=$(printf '\033[38;5;45m');  GREEN=$(printf '\033[38;5;46m')
  YELL=$(printf '\033[38;5;226m'); RED=$(printf '\033[38;5;196m')
  PURP=$(printf '\033[38;5;135m'); GREY=$(printf '\033[38;5;245m')
  BLUE=$(printf '\033[38;5;39m')
else
  B=""; R=""; CYAN=""; GREEN=""; YELL=""; RED=""; PURP=""; GREY=""; BLUE=""
fi

step() { printf "${CYAN}${B}▶ %s${R}\n" "$*"; }
ok()   { printf "${GREEN}  ✓ %s${R}\n" "$*"; }
warn() { printf "${YELL}  ! %s${R}\n" "$*"; }
die()  { printf "${RED}${B}✗ %s${R}\n" "$*" >&2; exit 1; }
# ---- translations (7 languages) ----------------------------
declare -A T_fa T_en T_ar T_tr T_zh T_de T_sv

T_fa["choose_lang"]="زبان را انتخاب کنید"
T_en["choose_lang"]="Choose your language"
T_ar["choose_lang"]="اختر لغتك"
T_tr["choose_lang"]="Dilinizi seçin"
T_zh["choose_lang"]="选择语言"
T_de["choose_lang"]="Sprache wählen"
T_sv["choose_lang"]="Välj språk"

T_fa["menu_title"]="منوی مدیریت"
T_en["menu_title"]="Management Menu"
T_ar["menu_title"]="قائمة الإدارة"
T_tr["menu_title"]="Yönetim Menüsü"
T_zh["menu_title"]="管理菜单"
T_de["menu_title"]="Verwaltungsmenü"
T_sv["menu_title"]="Hanteringsmeny"

T_fa["menu_install"]="نصب / راه‌اندازی"
T_en["menu_install"]="Install / Setup"
T_ar["menu_install"]="تثبيت / إعداد"
T_tr["menu_install"]="Kur / Kurulum"
T_zh["menu_install"]="安装 / 设置"
T_de["menu_install"]="Installieren / Einrichten"
T_sv["menu_install"]="Installera / Konfigurera"

T_fa["menu_update"]="به‌روزرسانی"
T_en["menu_update"]="Update"
T_ar["menu_update"]="تحديث"
T_tr["menu_update"]="Güncelle"
T_zh["menu_update"]="更新"
T_de["menu_update"]="Aktualisieren"
T_sv["menu_update"]="Uppdatera"

T_fa["menu_ssl"]="فعال‌سازی HTTPS (SSL)"
T_en["menu_ssl"]="Enable HTTPS (SSL)"
T_ar["menu_ssl"]="تفعيل HTTPS (SSL)"
T_tr["menu_ssl"]="HTTPS (SSL) etkinleştir"
T_zh["menu_ssl"]="启用 HTTPS (SSL)"
T_de["menu_ssl"]="HTTPS (SSL) aktivieren"
T_sv["menu_ssl"]="Aktivera HTTPS (SSL)"

T_fa["menu_status"]="وضعیت"
T_en["menu_status"]="Status"
T_ar["menu_status"]="الحالة"
T_tr["menu_status"]="Durum"
T_zh["menu_status"]="状态"
T_de["menu_status"]="Status"
T_sv["menu_status"]="Status"

T_fa["menu_logs"]="نمایش لاگ‌ها"
T_en["menu_logs"]="View logs"
T_ar["menu_logs"]="عرض السجلات"
T_tr["menu_logs"]="Günlükleri göster"
T_zh["menu_logs"]="查看日志"
T_de["menu_logs"]="Logs anzeigen"
T_sv["menu_logs"]="Visa loggar"

T_fa["menu_password"]="نمایش رمز پنل"
T_en["menu_password"]="Show panel password"
T_ar["menu_password"]="إظهار كلمة مرور اللوحة"
T_tr["menu_password"]="Panel şifresini göster"
T_zh["menu_password"]="显示面板密码"
T_de["menu_password"]="Panel-Passwort anzeigen"
T_sv["menu_password"]="Visa panellösenord"

T_fa["menu_restart"]="ری‌استارت"
T_en["menu_restart"]="Restart"
T_ar["menu_restart"]="إعادة تشغيل"
T_tr["menu_restart"]="Yeniden başlat"
T_zh["menu_restart"]="重启"
T_de["menu_restart"]="Neustart"
T_sv["menu_restart"]="Starta om"

T_fa["menu_uninstall"]="حذف کامل"
T_en["menu_uninstall"]="Uninstall"
T_ar["menu_uninstall"]="إلغاء التثبيت"
T_tr["menu_uninstall"]="Kaldır"
T_zh["menu_uninstall"]="卸载"
T_de["menu_uninstall"]="Deinstallieren"
T_sv["menu_uninstall"]="Avinstallera"

T_fa["menu_exit"]="خروج"
T_en["menu_exit"]="Exit"
T_ar["menu_exit"]="خروج"
T_tr["menu_exit"]="Çıkış"
T_zh["menu_exit"]="退出"
T_de["menu_exit"]="Beenden"
T_sv["menu_exit"]="Avsluta"

T_fa["prompt_choice"]="شماره گزینه را وارد کنید"
T_en["prompt_choice"]="Enter option number"
T_ar["prompt_choice"]="أدخل رقم الخيار"
T_tr["prompt_choice"]="Seçenek numarasını girin"
T_zh["prompt_choice"]="输入选项编号"
T_de["prompt_choice"]="Optionsnummer eingeben"
T_sv["prompt_choice"]="Ange alternativnummer"

T_fa["checking_sys"]="بررسی سیستم"
T_en["checking_sys"]="Checking system"
T_ar["checking_sys"]="فحص النظام"
T_tr["checking_sys"]="Sistem kontrol ediliyor"
T_zh["checking_sys"]="检查系统"
T_de["checking_sys"]="System wird geprüft"
T_sv["checking_sys"]="Kontrollerar system"

T_fa["installing_docker"]="نصب Docker"
T_en["installing_docker"]="Installing Docker"
T_ar["installing_docker"]="تثبيت Docker"
T_tr["installing_docker"]="Docker kuruluyor"
T_zh["installing_docker"]="安装 Docker"
T_de["installing_docker"]="Docker wird installiert"
T_sv["installing_docker"]="Installerar Docker"

T_fa["docker_present"]="Docker از قبل نصب است"
T_en["docker_present"]="Docker already present"
T_ar["docker_present"]="Docker مثبت مسبقاً"
T_tr["docker_present"]="Docker zaten mevcut"
T_zh["docker_present"]="Docker 已存在"
T_de["docker_present"]="Docker bereits vorhanden"
T_sv["docker_present"]="Docker finns redan"

T_fa["docker_installed"]="Docker نصب شد"
T_en["docker_installed"]="Docker installed"
T_ar["docker_installed"]="تم تثبيت Docker"
T_tr["docker_installed"]="Docker kuruldu"
T_zh["docker_installed"]="Docker 已安装"
T_de["docker_installed"]="Docker installiert"
T_sv["docker_installed"]="Docker installerad"

T_fa["preparing_config"]="آماده‌سازی تنظیمات"
T_en["preparing_config"]="Preparing configuration"
T_ar["preparing_config"]="تحضير الإعدادات"
T_tr["preparing_config"]="Yapılandırma hazırlanıyor"
T_zh["preparing_config"]="准备配置"
T_de["preparing_config"]="Konfiguration wird vorbereitet"
T_sv["preparing_config"]="Förbereder konfiguration"

T_fa["config_kept"]="تنظیمات موجود حفظ شد"
T_en["config_kept"]="Existing settings kept"
T_ar["config_kept"]="تم الاحتفاظ بالإعدادات"
T_tr["config_kept"]="Mevcut ayarlar korundu"
T_zh["config_kept"]="保留现有设置"
T_de["config_kept"]="Vorhandene Einstellungen beibehalten"
T_sv["config_kept"]="Befintliga inställningar behållna"

T_fa["config_generated"]="تنظیمات ساخته شد (رمز امن تصادفی)"
T_en["config_generated"]="Config generated (secure random)"
T_ar["config_generated"]="تم إنشاء الإعدادات"
T_tr["config_generated"]="Yapılandırma oluşturuldu"
T_zh["config_generated"]="已生成配置"
T_de["config_generated"]="Konfiguration erstellt"
T_sv["config_generated"]="Konfiguration skapad"

T_fa["compose_written"]="فایل اجرا نوشته شد"
T_en["compose_written"]="Compose file written"
T_ar["compose_written"]="تمت كتابة ملف compose"
T_tr["compose_written"]="Compose dosyası yazıldı"
T_zh["compose_written"]="已写入 compose 文件"
T_de["compose_written"]="Compose-Datei geschrieben"
T_sv["compose_written"]="Compose-fil skriven"

T_fa["pulling_image"]="دریافت برنامه"
T_en["pulling_image"]="Pulling application image"
T_ar["pulling_image"]="جلب صورة التطبيق"
T_tr["pulling_image"]="Uygulama imajı çekiliyor"
T_zh["pulling_image"]="拉取应用镜像"
T_de["pulling_image"]="Anwendungs-Image wird geladen"
T_sv["pulling_image"]="Hämtar applikationsavbild"

T_fa["image_pulled"]="برنامه دریافت شد"
T_en["image_pulled"]="Image pulled"
T_ar["image_pulled"]="تم جلب الصورة"
T_tr["image_pulled"]="İmaj çekildi"
T_zh["image_pulled"]="镜像已拉取"
T_de["image_pulled"]="Image geladen"
T_sv["image_pulled"]="Avbild hämtad"

T_fa["starting"]="راه‌اندازی Nebula"
T_en["starting"]="Starting Nebula"
T_ar["starting"]="تشغيل Nebula"
T_tr["starting"]="Nebula başlatılıyor"
T_zh["starting"]="启动 Nebula"
T_de["starting"]="Nebula wird gestartet"
T_sv["starting"]="Startar Nebula"

T_fa["container_up"]="کانتینر اجرا شد"
T_en["container_up"]="Container is up"
T_ar["container_up"]="الحاوية تعمل"
T_tr["container_up"]="Konteyner çalışıyor"
T_zh["container_up"]="容器已启动"
T_de["container_up"]="Container läuft"
T_sv["container_up"]="Container igång"

T_fa["cli_ready"]="دستور nebula آماده شد"
T_en["cli_ready"]="nebula command ready"
T_ar["cli_ready"]="أمر nebula جاهز"
T_tr["cli_ready"]="nebula komutu hazır"
T_zh["cli_ready"]="nebula 命令就绪"
T_de["cli_ready"]="nebula-Befehl bereit"
T_sv["cli_ready"]="nebula-kommando redo"

T_fa["is_live"]="Nebula AI Platform فعال شد"
T_en["is_live"]="Nebula AI Platform is LIVE"
T_ar["is_live"]="Nebula AI Platform يعمل الآن"
T_tr["is_live"]="Nebula AI Platform ÇALIŞIYOR"
T_zh["is_live"]="Nebula AI Platform 已上线"
T_de["is_live"]="Nebula AI Platform ist LIVE"
T_sv["is_live"]="Nebula AI Platform är LIVE"

T_fa["panel_url"]="آدرس پنل"
T_en["panel_url"]="Panel URL"
T_ar["panel_url"]="رابط اللوحة"
T_tr["panel_url"]="Panel URL"
T_zh["panel_url"]="面板地址"
T_de["panel_url"]="Panel-URL"
T_sv["panel_url"]="Panel-URL"

T_fa["username"]="نام کاربری"
T_en["username"]="Username"
T_ar["username"]="اسم المستخدم"
T_tr["username"]="Kullanıcı adı"
T_zh["username"]="用户名"
T_de["username"]="Benutzername"
T_sv["username"]="Användarnamn"

T_fa["password"]="رمز عبور"
T_en["password"]="Password"
T_ar["password"]="كلمة المرور"
T_tr["password"]="Şifre"
T_zh["password"]="密码"
T_de["password"]="Passwort"
T_sv["password"]="Lösenord"

T_fa["change_later"]="(بعداً می‌تونی داخل پنل عوضشون کنی)"
T_en["change_later"]="(change both later inside the panel)"
T_ar["change_later"]="(يمكنك تغييرهما لاحقاً)"
T_tr["change_later"]="(ikisini de panelde değiştirebilirsin)"
T_zh["change_later"]="(稍后可在面板中更改)"
T_de["change_later"]="(beides später im Panel änderbar)"
T_sv["change_later"]="(ändra båda senare i panelen)"

T_fa["next_steps"]="قدم‌های بعدی"
T_en["next_steps"]="Next steps"
T_ar["next_steps"]="الخطوات التالية"
T_tr["next_steps"]="Sonraki adımlar"
T_zh["next_steps"]="后续步骤"
T_de["next_steps"]="Nächste Schritte"
T_sv["next_steps"]="Nästa steg"

T_fa["step1"]="پنل رو باز کن و وارد شو."
T_en["step1"]="Open the panel and log in."
T_ar["step1"]="افتح اللوحة وسجّل الدخول."
T_tr["step1"]="Paneli aç ve giriş yap."
T_zh["step1"]="打开面板并登录。"
T_de["step1"]="Panel öffnen und anmelden."
T_sv["step1"]="Öppna panelen och logga in."

T_fa["step2"]="توکن ربات تلگرام رو وصل کن."
T_en["step2"]="Connect your Telegram bot token."
T_ar["step2"]="اربط توكن بوت تيليجرام."
T_tr["step2"]="Telegram bot tokenini bağla."
T_zh["step2"]="连接你的 Telegram 机器人令牌。"
T_de["step2"]="Verbinde deinen Telegram-Bot-Token."
T_sv["step2"]="Anslut din Telegram-bot-token."

T_fa["step3"]="نام کاربری و رمز رو عوض کن."
T_en["step3"]="Change your username & password."
T_ar["step3"]="غيّر اسم المستخدم وكلمة المرور."
T_tr["step3"]="Kullanıcı adı ve şifreni değiştir."
T_zh["step3"]="更改用户名和密码。"
T_de["step3"]="Ändere Benutzername & Passwort."
T_sv["step3"]="Ändra användarnamn & lösenord."

T_fa["ssl_choose"]="روش HTTPS را انتخاب کنید"
T_en["ssl_choose"]="Choose HTTPS method"
T_ar["ssl_choose"]="اختر طريقة HTTPS"
T_tr["ssl_choose"]="HTTPS yöntemini seçin"
T_zh["ssl_choose"]="选择 HTTPS 方式"
T_de["ssl_choose"]="HTTPS-Methode wählen"
T_sv["ssl_choose"]="Välj HTTPS-metod"

T_fa["ssl_domain"]="با دامنه‌ی خودم"
T_en["ssl_domain"]="With my own domain"
T_ar["ssl_domain"]="بنطاقي الخاص"
T_tr["ssl_domain"]="Kendi alan adımla"
T_zh["ssl_domain"]="使用我的域名"
T_de["ssl_domain"]="Mit eigener Domain"
T_sv["ssl_domain"]="Med min egen domän"

T_fa["ssl_auto"]="خودکار روی همین IP (بدون دامنه)"
T_en["ssl_auto"]="Auto on this IP (no domain)"
T_ar["ssl_auto"]="تلقائي على هذا IP"
T_tr["ssl_auto"]="Bu IP'de otomatik"
T_zh["ssl_auto"]="在此 IP 上自动"
T_de["ssl_auto"]="Automatisch auf dieser IP"
T_sv["ssl_auto"]="Auto på denna IP"

T_fa["ssl_enter_domain"]="دامنه را وارد کنید (مثلاً panel.example.com)"
T_en["ssl_enter_domain"]="Enter domain (e.g. panel.example.com)"
T_ar["ssl_enter_domain"]="أدخل النطاق"
T_tr["ssl_enter_domain"]="Alan adını girin"
T_zh["ssl_enter_domain"]="输入域名"
T_de["ssl_enter_domain"]="Domain eingeben"
T_sv["ssl_enter_domain"]="Ange domän"

T_fa["ssl_done"]="HTTPS فعال شد! پنل الان اینجاست:"
T_en["ssl_done"]="HTTPS enabled! Panel now at:"
T_ar["ssl_done"]="تم تفعيل HTTPS! اللوحة الآن:"
T_tr["ssl_done"]="HTTPS etkin! Panel şimdi:"
T_zh["ssl_done"]="HTTPS 已启用！面板现在位于："
T_de["ssl_done"]="HTTPS aktiviert! Panel jetzt unter:"
T_sv["ssl_done"]="HTTPS aktiverat! Panel nu på:"

T_fa["press_enter"]="برای بازگشت به منو Enter بزنید"
T_en["press_enter"]="Press Enter to return to menu"
T_ar["press_enter"]="اضغط Enter للعودة"
T_tr["press_enter"]="Menüye dönmek için Enter"
T_zh["press_enter"]="按 Enter 返回菜单"
T_de["press_enter"]="Enter drücken für Menü"
T_sv["press_enter"]="Tryck Enter för meny"

T_fa["invalid_choice"]="گزینه نامعتبر"
T_en["invalid_choice"]="Invalid choice"
T_ar["invalid_choice"]="خيار غير صالح"
T_tr["invalid_choice"]="Geçersiz seçim"
T_zh["invalid_choice"]="无效选择"
T_de["invalid_choice"]="Ungültige Wahl"
T_sv["invalid_choice"]="Ogiltigt val"

T_fa["goodbye"]="خداحافظ!"
T_en["goodbye"]="Goodbye!"
T_ar["goodbye"]="وداعاً!"
T_tr["goodbye"]="Hoşça kal!"
T_zh["goodbye"]="再见！"
T_de["goodbye"]="Auf Wiedersehen!"
T_sv["goodbye"]="Hej då!"

T_fa["not_installed"]="Nebula هنوز نصب نشده. اول گزینه نصب رو بزنید."
T_en["not_installed"]="Nebula is not installed yet. Choose Install first."
T_ar["not_installed"]="Nebula غير مثبت بعد."
T_tr["not_installed"]="Nebula henüz kurulmadı."
T_zh["not_installed"]="Nebula 尚未安装。"
T_de["not_installed"]="Nebula noch nicht installiert."
T_sv["not_installed"]="Nebula är inte installerat än."

T_fa["confirm_uninstall"]="حذف کامل Nebula و همه داده‌ها؟ برای تأیید yes بنویسید"
T_en["confirm_uninstall"]="Remove Nebula and ALL data? Type yes to confirm"
T_ar["confirm_uninstall"]="حذف Nebula وكل البيانات؟ اكتب yes"
T_tr["confirm_uninstall"]="Nebula ve TÜM veriler silinsin mi? yes yazın"
T_zh["confirm_uninstall"]="删除 Nebula 和所有数据？输入 yes"
T_de["confirm_uninstall"]="Nebula und ALLE Daten entfernen? yes eingeben"
T_sv["confirm_uninstall"]="Ta bort Nebula och ALL data? Skriv yes"

T_fa["removed"]="Nebula حذف شد."
T_en["removed"]="Nebula removed."
T_ar["removed"]="تم حذف Nebula."
T_tr["removed"]="Nebula kaldırıldı."
T_zh["removed"]="Nebula 已删除。"
T_de["removed"]="Nebula entfernt."
T_sv["removed"]="Nebula borttaget."

T_fa["cancelled"]="لغو شد."
T_en["cancelled"]="Cancelled."
T_ar["cancelled"]="أُلغيت."
T_tr["cancelled"]="İptal edildi."
T_zh["cancelled"]="已取消。"
T_de["cancelled"]="Abgebrochen."
T_sv["cancelled"]="Avbruten."

T_fa["updating"]="در حال به‌روزرسانی..."
T_en["updating"]="Updating..."
T_ar["updating"]="جارٍ التحديث..."
T_tr["updating"]="Güncelleniyor..."
T_zh["updating"]="正在更新..."
T_de["updating"]="Wird aktualisiert..."
T_sv["updating"]="Uppdaterar..."

T_fa["updated"]="به آخرین نسخه به‌روزرسانی شد. داده‌ها حفظ شدن."
T_en["updated"]="Updated to latest. Your data is kept."
T_ar["updated"]="تم التحديث. بياناتك محفوظة."
T_tr["updated"]="Güncellendi. Verilerin korundu."
T_zh["updated"]="已更新到最新。数据已保留。"
T_de["updated"]="Aktualisiert. Deine Daten bleiben."
T_sv["updated"]="Uppdaterad. Din data behålls."

T_fa["restarted"]="ری‌استارت شد."
T_en["restarted"]="Restarted."
T_ar["restarted"]="أُعيد التشغيل."
T_tr["restarted"]="Yeniden başlatıldı."
T_zh["restarted"]="已重启。"
T_de["restarted"]="Neu gestartet."
T_sv["restarted"]="Omstartad."

# Look up a translation key for the currently selected LANG (default en).
t() {
  local key="$1"
  local var="T_${LANG:-en}[$key]"
  local val="${!var:-}"
  if [ -z "$val" ]; then
    # fallback to English then the key itself
    var="T_en[$key]"
    val="${!var:-$key}"
  fi
  printf '%s' "$val"
}
# ---- banner ------------------------------------------------
banner() {
  clear 2>/dev/null || true
  printf "${PURP}${B}"
  cat <<'ART'
    _   _      _           _
  | \ | |    | |         | |
  |  \| | ___| |__  _   _| | __ _
  | . ` |/ _ \ '_ \| | | | |/ _` |
  | |\  |  __/ |_) | |_| | | (_| |
  |_| \_|\___|_.__/ \__,_|_|\__,_|
ART
  printf "${R}"
  printf "${GREY}        Nebula AI Platform${R}\n\n"
}

# ---- language picker ---------------------------------------
choose_language() {
  banner
  printf "  ${B}%s${R}\n\n" "Choose your language / زبان را انتخاب کنید"
  printf "   ${CYAN}1${R}) فارسی (Persian)\n"
  printf "   ${CYAN}2${R}) English\n"
  printf "   ${CYAN}3${R}) العربية (Arabic)\n"
  printf "   ${CYAN}4${R}) Türkçe (Turkish)\n"
  printf "   ${CYAN}5${R}) 中文 (Chinese)\n"
  printf "   ${CYAN}6${R}) Deutsch (German)\n"
  printf "   ${CYAN}7${R}) Svenska (Swedish)\n\n"
  printf "  ${GREY}%s [1-7]:${R} " "→"
  read -r choice </dev/tty
  case "$choice" in
    1) LANG="fa" ;;
    2) LANG="en" ;;
    3) LANG="ar" ;;
    4) LANG="tr" ;;
    5) LANG="zh" ;;
    6) LANG="de" ;;
    7) LANG="sv" ;;
    *) LANG="en" ;;
  esac
}

# ---- main menu ---------------------------------------------
show_menu() {
  banner
  printf "  ${BLUE}${B}%s${R}\n\n" "$(t menu_title)"
  printf "   ${CYAN}1${R})  🚀  %s\n" "$(t menu_install)"
  printf "   ${CYAN}2${R})  ⬆️   %s\n" "$(t menu_update)"
  printf "   ${CYAN}3${R})  🔒  %s\n" "$(t menu_ssl)"
  printf "   ${CYAN}4${R})  📊  %s\n" "$(t menu_status)"
  printf "   ${CYAN}5${R})  📜  %s\n" "$(t menu_logs)"
  printf "   ${CYAN}6${R})  🔑  %s\n" "$(t menu_password)"
  printf "   ${CYAN}7${R})  🔄  %s\n" "$(t menu_restart)"
  printf "   ${CYAN}8${R})  🗑   %s\n" "$(t menu_uninstall)"
  printf "   ${CYAN}0${R})  ❌  %s\n\n" "$(t menu_exit)"
  printf "  ${GREY}%s:${R} " "$(t prompt_choice)"
}

pause_menu() {
  printf "\n  ${GREY}%s${R} " "$(t press_enter)"
  read -r _ </dev/tty
}

# ---- helpers to generate secrets ---------------------------
rand_hex() {
  local n="${1:-32}"
  if command -v openssl >/dev/null 2>&1; then openssl rand -hex "$n"
  else od -An -tx1 -N "$n" /dev/urandom | tr -d ' \n'; fi
}
rand_pass() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -base64 24 | tr -dc 'A-HJ-NP-Za-km-z2-9' | cut -c1-16
  else od -An -tx1 -N 256 /dev/urandom | tr -dc 'A-HJ-NP-Za-km-z2-9' | cut -c1-16; fi
}
public_ip() {
  curl -fsS --max-time 5 https://api.ipify.org 2>/dev/null \
    || curl -fsS --max-time 5 https://ifconfig.me 2>/dev/null \
    || hostname -I | awk '{print $1}'
}

# ---- install docker ----------------------------------------
install_docker() {
  step "$(t installing_docker)"
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    ok "$(t docker_present)"; return
  fi
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  apt-get install -y -qq ca-certificates curl gnupg >/dev/null
  install -m 0755 -d /etc/apt/keyrings
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
  fi
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -qq
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io \
      docker-buildx-plugin docker-compose-plugin >/dev/null
  systemctl enable --now docker >/dev/null 2>&1 || true
  ok "$(t docker_installed)"
}

# ---- write .env --------------------------------------------
write_env() {
  step "$(t preparing_config)"
  mkdir -p "$APP_DIR"
  if [ -f "$ENV_FILE" ]; then
    ok "$(t config_kept)"
    ADMIN_USERNAME=$(grep -E '^ADMIN_USERNAME=' "$ENV_FILE" | cut -d= -f2- || echo "admin")
    ADMIN_PASSWORD=$(grep -E '^ADMIN_PASSWORD=' "$ENV_FILE" | cut -d= -f2- || echo "(set earlier)")
    return
  fi
  ADMIN_USERNAME="admin"
  ADMIN_PASSWORD="$(rand_pass)"
  local secret; secret="$(rand_hex 48)"
  cat > "$ENV_FILE" <<EOF
# Generated by the Nebula installer on $(date -u +%Y-%m-%dT%H:%M:%SZ)
BOT_TOKEN=
BOT_USERNAME=
REQUIRED_CHANNEL=
REQUIRED_CHANNEL_URL=
ADMIN_USERNAME=${ADMIN_USERNAME}
ADMIN_PASSWORD=${ADMIN_PASSWORD}
SESSION_SECRET=${secret}
NODE_ENV=production
PORT=3000
DB_PATH=/app/data/bot.db
SECURE_COOKIES=false
HOST_PORT=${DEFAULT_PORT}
EOF
  chmod 600 "$ENV_FILE"
  ok "$(t config_generated)"
}

write_compose() {
  cat > "$COMPOSE_FILE" <<'EOF'
services:
  nebula:
    image: weblinuxi/nebula-platform:latest
    container_name: nebula
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "${HOST_PORT:-3000}:3000"
    volumes:
      - nebula-data:/app/data
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://127.0.0.1:3000/"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 20s
volumes:
  nebula-data:
    name: nebula-data
EOF
  ok "$(t compose_written)"
}

start_app() {
  step "$(t pulling_image)"
  docker pull "$IMAGE" >/dev/null && ok "$(t image_pulled)"
  step "$(t starting)"
  docker compose --project-directory "$APP_DIR" -f "$COMPOSE_FILE" up -d >/dev/null
  ok "$(t container_up)"
}

# ---- install the nebula management CLI ---------------------
install_cli() {
  step "Installing 'nebula' command"
  cat > "$BIN_PATH" <<'EOF'
#!/usr/bin/env bash
# Nebula AI Platform — management CLI
set -euo pipefail
APP_DIR="/opt/nebula"
IMAGE="weblinuxi/nebula-platform:latest"
cd "$APP_DIR" 2>/dev/null || { echo "Nebula is not installed."; exit 1; }
case "${1:-}" in
  start)    docker compose up -d && echo "Nebula started." ;;
  stop)     docker compose down && echo "Nebula stopped." ;;
  restart)  docker compose restart && echo "Nebula restarted." ;;
  status)   docker compose ps ;;
  logs)     docker compose logs -f --tail=200 ;;
  update)
      echo "Pulling latest image..."
      docker pull "$IMAGE"
      docker compose up -d
      echo "Updated to latest. Your data & settings are kept." ;;
  version)
      docker inspect --format '{{ index .Config.Labels "org.opencontainers.image.version" }}' "$IMAGE" 2>/dev/null \
        || echo "unknown" ;;
  password)
      # Show the current stored panel password (from .env).
      grep -E '^ADMIN_PASSWORD=' "$APP_DIR/.env" | cut -d= -f2- ;;
  ssl)
      DOMAIN="${2:-}"
      if [ -z "$DOMAIN" ]; then
        echo "Usage:"
        echo "  nebula ssl <your-domain>   HTTPS for a domain you own"
        echo "  nebula ssl auto            HTTPS on this server's IP (no domain needed)"
        echo ""
        echo "Examples:"
        echo "  nebula ssl panel.example.com"
        echo "  nebula ssl auto"
        exit 1
      fi
      if [ "$(id -u)" -ne 0 ]; then echo "Please run as root: sudo nebula ssl $DOMAIN"; exit 1; fi

      MYIP=$(curl -fsS --max-time 5 https://api.ipify.org 2>/dev/null || true)

      # "auto" → build a free hostname from the IP via sslip.io. It resolves
      # to this exact IP automatically, so Let's Encrypt can issue on it with
      # no domain purchase. Address looks like 62-238-113-252.sslip.io.
      if [ "$DOMAIN" = "auto" ]; then
        if [ -z "$MYIP" ]; then echo "Could not detect this server's public IP."; exit 1; fi
        DOMAIN="$(echo "$MYIP" | tr '.' '-').sslip.io"
        echo "▶ No domain given — using a free auto-hostname: $DOMAIN"
      fi

      echo "▶ Setting up HTTPS for: $DOMAIN"

      # 1) Check the domain points at THIS server (skip for sslip.io — it
      #    always resolves to the embedded IP by design).
      case "$DOMAIN" in
        *.sslip.io) : ;;  # trusted to resolve to our IP
        *)
          DIP=$(getent hosts "$DOMAIN" | awk '{print $1}' | head -1 || true)
          if [ -n "$MYIP" ] && [ -n "$DIP" ] && [ "$MYIP" != "$DIP" ]; then
            echo ""
            echo "  ⚠️  DNS doesn't point here yet."
            echo "     $DOMAIN → ${DIP:-nothing}"
            echo "     This server → $MYIP"
            echo ""
            echo "  Create an A record first:"
            echo "     Type: A   Name: $DOMAIN   Value: $MYIP   (Proxy OFF / DNS only)"
            echo "  Then wait a few minutes and run this again."
            exit 1
          fi
          ;;
      esac

      # 2) Install nginx + certbot.
      echo "  Installing nginx + certbot..."
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -qq >/dev/null 2>&1
      apt-get install -y -qq nginx certbot python3-certbot-nginx >/dev/null 2>&1

      # 3) nginx reverse proxy: domain → the panel on 127.0.0.1:3000.
      cat > "/etc/nginx/sites-available/nebula" <<NGINX
server {
    listen 80;
    server_name $DOMAIN;
    client_max_body_size 200M;
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
NGINX
      ln -sf /etc/nginx/sites-available/nebula /etc/nginx/sites-enabled/nebula
      rm -f /etc/nginx/sites-enabled/default
      nginx -t >/dev/null 2>&1 && systemctl reload nginx

      # 4) Get the certificate (auto-redirects http→https).
      echo "  Requesting SSL certificate..."
      if certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos \
           --register-unsafely-without-email --redirect >/dev/null 2>&1; then
        echo "  ✓ Certificate installed"
      else
        echo "  ⚠️  Certbot failed. Check that port 80 is open and DNS is correct."
        echo "     You can retry: certbot --nginx -d $DOMAIN"
        exit 1
      fi

      # 5) Turn on secure cookies now that we're behind HTTPS, and restart.
      if grep -q '^SECURE_COOKIES=' "$APP_DIR/.env"; then
        sed -i 's/^SECURE_COOKIES=.*/SECURE_COOKIES=true/' "$APP_DIR/.env"
      else
        echo "SECURE_COOKIES=true" >> "$APP_DIR/.env"
      fi
      docker compose up -d >/dev/null 2>&1

      echo ""
      echo "  🎉 Done! Your panel is now at:  https://$DOMAIN"
      echo "     (http automatically redirects to https)"
      ;;
  uninstall)
      read -rp "Remove Nebula and ALL data? Type 'yes': " c
      [ "$c" = "yes" ] || { echo "Cancelled."; exit 0; }
      docker compose down -v
      echo "Nebula removed." ;;
  *)
      echo "Nebula AI Platform — commands:"
      echo "  nebula start        Start the platform"
      echo "  nebula stop         Stop it"
      echo "  nebula restart      Restart it"
      echo "  nebula status       Show container status"
      echo "  nebula logs         Follow live logs"
      echo "  nebula update       Update to the newest version"
      echo "  nebula version      Show installed version"
      echo "  nebula password     Show the panel password"
      echo "  nebula ssl <domain> Set up free HTTPS for a domain"
      echo "  nebula ssl auto     Set up free HTTPS on this IP (no domain)"
      echo "  nebula uninstall    Remove everything" ;;
esac
EOF
  chmod +x "$BIN_PATH"
  ok "'nebula' command ready"
}

# ---- summary screen ----------------------------------------
summary() {
  local ip; ip="$(public_ip)"
  local url="http://${ip}:${HOST_PORT:-$DEFAULT_PORT}"
  printf "\n"
  printf "${GREEN}${B}╔══════════════════════════════════════════════════╗${R}\n"
  printf "${GREEN}${B}║   %-46s ║${R}\n" "$(t is_live)  🎉"
  printf "${GREEN}${B}╚══════════════════════════════════════════════════╝${R}\n\n"
  printf "  ${B}%s${R}   ${CYAN}%s${R}\n" "$(t panel_url)" "$url"
  printf "  ${B}%s${R}    %s\n" "$(t username)" "${ADMIN_USERNAME}"
  printf "  ${B}%s${R}    %s\n" "$(t password)" "${ADMIN_PASSWORD}"
  printf "  ${GREY}%s${R}\n\n" "$(t change_later)"
  printf "  ${B}%s${R}\n" "$(t next_steps)"
  printf "    1. %s\n" "$(t step1)"
  printf "    2. %s\n" "$(t step2)"
  printf "    3. %s\n" "$(t step3)"
}

# ---- menu action: install ----------------------------------
do_install() {
  banner
  step "$(t checking_sys)"
  . /etc/os-release 2>/dev/null || true
  ok "OS: ${PRETTY_NAME:-Ubuntu}"
  ok "Arch: $(uname -m)"
  install_docker
  write_env
  write_compose
  start_app
  install_cli
  summary
  pause_menu
}

# ---- menu action: update -----------------------------------
do_update() {
  banner
  if [ ! -d "$APP_DIR" ]; then warn "$(t not_installed)"; pause_menu; return; fi
  step "$(t updating)"
  docker pull "$IMAGE" >/dev/null
  docker compose --project-directory "$APP_DIR" -f "$COMPOSE_FILE" up -d >/dev/null
  ok "$(t updated)"
  pause_menu
}

# ---- menu action: ssl --------------------------------------
do_ssl() {
  banner
  if [ ! -d "$APP_DIR" ]; then warn "$(t not_installed)"; pause_menu; return; fi
  printf "  ${B}%s${R}\n\n" "$(t ssl_choose)"
  printf "   ${CYAN}1${R})  🌐  %s\n" "$(t ssl_domain)"
  printf "   ${CYAN}2${R})  ⚡  %s\n\n" "$(t ssl_auto)"
  printf "  ${GREY}%s [1-2]:${R} " "→"
  read -r sslchoice </dev/tty
  local domain=""
  if [ "$sslchoice" = "1" ]; then
    printf "  ${GREY}%s:${R} " "$(t ssl_enter_domain)"
    read -r domain </dev/tty
    [ -z "$domain" ] && { warn "$(t invalid_choice)"; pause_menu; return; }
  else
    domain="auto"
  fi
  # فراخوانی همون منطق nebula ssl
  nebula ssl "$domain" || true
  pause_menu
}

# ---- menu action: status/logs/password/restart/uninstall ---
do_status()  { banner; nebula status 2>/dev/null || warn "$(t not_installed)"; pause_menu; }
do_logs()    { banner; if [ -d "$APP_DIR" ]; then docker compose --project-directory "$APP_DIR" logs --tail=100; else warn "$(t not_installed)"; fi; pause_menu; }
do_password(){ banner; if [ -f "$ENV_FILE" ]; then printf "  ${B}%s:${R} %s\n" "$(t password)" "$(grep -E '^ADMIN_PASSWORD=' "$ENV_FILE" | cut -d= -f2-)"; else warn "$(t not_installed)"; fi; pause_menu; }
do_restart() { banner; if [ -d "$APP_DIR" ]; then docker compose --project-directory "$APP_DIR" restart >/dev/null && ok "$(t restarted)"; else warn "$(t not_installed)"; fi; pause_menu; }
do_uninstall(){
  banner
  if [ ! -d "$APP_DIR" ]; then warn "$(t not_installed)"; pause_menu; return; fi
  printf "  ${RED}${B}%s${R} " "$(t confirm_uninstall)"
  read -r c </dev/tty
  if [ "$c" = "yes" ]; then
    docker compose --project-directory "$APP_DIR" down -v >/dev/null 2>&1 || true
    docker rmi -f "$IMAGE" >/dev/null 2>&1 || true
    rm -rf "$APP_DIR"; rm -f "$BIN_PATH"
    ok "$(t removed)"
  else
    printf "  %s\n" "$(t cancelled)"
  fi
  pause_menu
}

# ============================================================
# main loop
# ============================================================
main() {
  if [ "$(id -u)" -ne 0 ]; then
    die "Please run as root:  sudo bash <(curl -Ls https://nebulapanel.cloud/install)"
  fi
  choose_language
  while true; do
    show_menu
    read -r choice </dev/tty
    case "$choice" in
      1) do_install ;;
      2) do_update ;;
      3) do_ssl ;;
      4) do_status ;;
      5) do_logs ;;
      6) do_password ;;
      7) do_restart ;;
      8) do_uninstall ;;
      0) banner; printf "  ${GREEN}%s${R}\n\n" "$(t goodbye)"; exit 0 ;;
      *) printf "  ${RED}%s${R}\n" "$(t invalid_choice)"; sleep 1 ;;
    esac
  done
}

main "$@"
