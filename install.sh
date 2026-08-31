#!/usr/bin/env bash
# ============================================================
# Nebula AI Platform — Premium Installer (custom animated TUI)
# ============================================================
#   bash <(curl -Ls https://nebulapanel.cloud/install)
#
# A hand-built terminal UI: animated NEBULA logo with a purple→blue
# gradient, arrow-key navigation, and a polished menu. 5 languages.
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
LANG="en"

# ---- terminal control --------------------------------------
ESC=$'\033'
hide_cursor(){ printf '%s[?25l' "$ESC"; }
show_cursor(){ printf '%s[?25h' "$ESC"; }
clear_scr(){ printf '%s[2J%s[H' "$ESC" "$ESC"; }
move_to(){ printf '%s[%d;%dH' "$ESC" "$1" "$2"; }
reset_all(){ printf '%s[0m' "$ESC"; }
cleanup(){ show_cursor; reset_all; printf '\n'; }
trap cleanup EXIT INT TERM

# truecolor helpers (24-bit) — most modern terminals support these
fg(){ printf '%s[38;2;%d;%d;%dm' "$ESC" "$1" "$2" "$3"; }
bg(){ printf '%s[48;2;%d;%d;%dm' "$ESC" "$1" "$2" "$3"; }
bold(){ printf '%s[1m' "$ESC"; }
dim(){ printf '%s[2m' "$ESC"; }

# Nebula gradient stops (purple → violet → blue)
# We interpolate across these for the logo.
grad_color() {  # $1 = 0..100 position → sets fg
  local p=$1
  local r g b
  if [ "$p" -lt 50 ]; then
    # purple (139,92,246) → blue-violet (99,102,241)
    local t=$(( p * 2 ))
    r=$(( 139 + (99-139)*t/100 ))
    g=$(( 92  + (102-92)*t/100 ))
    b=$(( 246 + (241-246)*t/100 ))
  else
    # blue-violet (99,102,241) → cyan-blue (56,189,248)
    local t=$(( (p-50) * 2 ))
    r=$(( 99  + (56-99)*t/100 ))
    g=$(( 102 + (189-102)*t/100 ))
    b=$(( 241 + (248-241)*t/100 ))
  fi
  fg "$r" "$g" "$b"
}
# ---- translations (5 LTR languages, whiptail-safe) ---------
declare -A T_en T_tr T_zh T_de T_sv

T_en["choose_lang"]="Choose your language"
T_tr["choose_lang"]="Dilinizi seçin"
T_zh["choose_lang"]="选择语言"
T_de["choose_lang"]="Sprache wählen"
T_sv["choose_lang"]="Välj språk"

T_en["menu_title"]="Management Menu"
T_tr["menu_title"]="Yönetim Menüsü"
T_zh["menu_title"]="管理菜单"
T_de["menu_title"]="Verwaltungsmenü"
T_sv["menu_title"]="Hanteringsmeny"

T_en["menu_install"]="Install / Setup"
T_tr["menu_install"]="Kur / Kurulum"
T_zh["menu_install"]="安装 / 设置"
T_de["menu_install"]="Installieren / Einrichten"
T_sv["menu_install"]="Installera / Konfigurera"

T_en["menu_update"]="Update"
T_tr["menu_update"]="Güncelle"
T_zh["menu_update"]="更新"
T_de["menu_update"]="Aktualisieren"
T_sv["menu_update"]="Uppdatera"

T_en["menu_ssl"]="Enable HTTPS (SSL)"
T_tr["menu_ssl"]="HTTPS (SSL) etkinleştir"
T_zh["menu_ssl"]="启用 HTTPS (SSL)"
T_de["menu_ssl"]="HTTPS (SSL) aktivieren"
T_sv["menu_ssl"]="Aktivera HTTPS (SSL)"

T_en["menu_status"]="Status"
T_tr["menu_status"]="Durum"
T_zh["menu_status"]="状态"
T_de["menu_status"]="Status"
T_sv["menu_status"]="Status"

T_en["menu_logs"]="View logs"
T_tr["menu_logs"]="Günlükleri göster"
T_zh["menu_logs"]="查看日志"
T_de["menu_logs"]="Logs anzeigen"
T_sv["menu_logs"]="Visa loggar"

T_en["menu_password"]="Show panel password"
T_tr["menu_password"]="Panel şifresini göster"
T_zh["menu_password"]="显示面板密码"
T_de["menu_password"]="Panel-Passwort anzeigen"
T_sv["menu_password"]="Visa panellösenord"

T_en["menu_restart"]="Restart"
T_tr["menu_restart"]="Yeniden başlat"
T_zh["menu_restart"]="重启"
T_de["menu_restart"]="Neustart"
T_sv["menu_restart"]="Starta om"

T_en["menu_uninstall"]="Uninstall"
T_tr["menu_uninstall"]="Kaldır"
T_zh["menu_uninstall"]="卸载"
T_de["menu_uninstall"]="Deinstallieren"
T_sv["menu_uninstall"]="Avinstallera"

T_en["menu_exit"]="Exit"
T_tr["menu_exit"]="Çıkış"
T_zh["menu_exit"]="退出"
T_de["menu_exit"]="Beenden"
T_sv["menu_exit"]="Avsluta"

T_en["prompt_choice"]="Enter option number"
T_tr["prompt_choice"]="Seçenek numarasını girin"
T_zh["prompt_choice"]="输入选项编号"
T_de["prompt_choice"]="Optionsnummer eingeben"
T_sv["prompt_choice"]="Ange alternativnummer"

T_en["checking_sys"]="Checking system"
T_tr["checking_sys"]="Sistem kontrol ediliyor"
T_zh["checking_sys"]="检查系统"
T_de["checking_sys"]="System wird geprüft"
T_sv["checking_sys"]="Kontrollerar system"

T_en["installing_docker"]="Installing Docker"
T_tr["installing_docker"]="Docker kuruluyor"
T_zh["installing_docker"]="安装 Docker"
T_de["installing_docker"]="Docker wird installiert"
T_sv["installing_docker"]="Installerar Docker"

T_en["docker_present"]="Docker already present"
T_tr["docker_present"]="Docker zaten mevcut"
T_zh["docker_present"]="Docker 已存在"
T_de["docker_present"]="Docker bereits vorhanden"
T_sv["docker_present"]="Docker finns redan"

T_en["docker_installed"]="Docker installed"
T_tr["docker_installed"]="Docker kuruldu"
T_zh["docker_installed"]="Docker 已安装"
T_de["docker_installed"]="Docker installiert"
T_sv["docker_installed"]="Docker installerad"

T_en["preparing_config"]="Preparing configuration"
T_tr["preparing_config"]="Yapılandırma hazırlanıyor"
T_zh["preparing_config"]="准备配置"
T_de["preparing_config"]="Konfiguration wird vorbereitet"
T_sv["preparing_config"]="Förbereder konfiguration"

T_en["config_kept"]="Existing settings kept"
T_tr["config_kept"]="Mevcut ayarlar korundu"
T_zh["config_kept"]="保留现有设置"
T_de["config_kept"]="Vorhandene Einstellungen beibehalten"
T_sv["config_kept"]="Befintliga inställningar behållna"

T_en["config_generated"]="Config generated (secure random)"
T_tr["config_generated"]="Yapılandırma oluşturuldu"
T_zh["config_generated"]="已生成配置"
T_de["config_generated"]="Konfiguration erstellt"
T_sv["config_generated"]="Konfiguration skapad"

T_en["compose_written"]="Compose file written"
T_tr["compose_written"]="Compose dosyası yazıldı"
T_zh["compose_written"]="已写入 compose 文件"
T_de["compose_written"]="Compose-Datei geschrieben"
T_sv["compose_written"]="Compose-fil skriven"

T_en["pulling_image"]="Pulling application image"
T_tr["pulling_image"]="Uygulama imajı çekiliyor"
T_zh["pulling_image"]="拉取应用镜像"
T_de["pulling_image"]="Anwendungs-Image wird geladen"
T_sv["pulling_image"]="Hämtar applikationsavbild"

T_en["image_pulled"]="Image pulled"
T_tr["image_pulled"]="İmaj çekildi"
T_zh["image_pulled"]="镜像已拉取"
T_de["image_pulled"]="Image geladen"
T_sv["image_pulled"]="Avbild hämtad"

T_en["starting"]="Starting Nebula"
T_tr["starting"]="Nebula başlatılıyor"
T_zh["starting"]="启动 Nebula"
T_de["starting"]="Nebula wird gestartet"
T_sv["starting"]="Startar Nebula"

T_en["container_up"]="Container is up"
T_tr["container_up"]="Konteyner çalışıyor"
T_zh["container_up"]="容器已启动"
T_de["container_up"]="Container läuft"
T_sv["container_up"]="Container igång"

T_en["cli_ready"]="nebula command ready"
T_tr["cli_ready"]="nebula komutu hazır"
T_zh["cli_ready"]="nebula 命令就绪"
T_de["cli_ready"]="nebula-Befehl bereit"
T_sv["cli_ready"]="nebula-kommando redo"

T_en["is_live"]="Nebula AI Platform is LIVE"
T_tr["is_live"]="Nebula AI Platform ÇALIŞIYOR"
T_zh["is_live"]="Nebula AI Platform 已上线"
T_de["is_live"]="Nebula AI Platform ist LIVE"
T_sv["is_live"]="Nebula AI Platform är LIVE"

T_en["panel_url"]="Panel URL"
T_tr["panel_url"]="Panel URL"
T_zh["panel_url"]="面板地址"
T_de["panel_url"]="Panel-URL"
T_sv["panel_url"]="Panel-URL"

T_en["username"]="Username"
T_tr["username"]="Kullanıcı adı"
T_zh["username"]="用户名"
T_de["username"]="Benutzername"
T_sv["username"]="Användarnamn"

T_en["password"]="Password"
T_tr["password"]="Şifre"
T_zh["password"]="密码"
T_de["password"]="Passwort"
T_sv["password"]="Lösenord"

T_en["change_later"]="(change both later inside the panel)"
T_tr["change_later"]="(ikisini de panelde değiştirebilirsin)"
T_zh["change_later"]="(稍后可在面板中更改)"
T_de["change_later"]="(beides später im Panel änderbar)"
T_sv["change_later"]="(ändra båda senare i panelen)"

T_en["next_steps"]="Next steps"
T_tr["next_steps"]="Sonraki adımlar"
T_zh["next_steps"]="后续步骤"
T_de["next_steps"]="Nächste Schritte"
T_sv["next_steps"]="Nästa steg"

T_en["step1"]="Open the panel and log in."
T_tr["step1"]="Paneli aç ve giriş yap."
T_zh["step1"]="打开面板并登录。"
T_de["step1"]="Panel öffnen und anmelden."
T_sv["step1"]="Öppna panelen och logga in."

T_en["step2"]="Connect your Telegram bot token."
T_tr["step2"]="Telegram bot tokenini bağla."
T_zh["step2"]="连接你的 Telegram 机器人令牌。"
T_de["step2"]="Verbinde deinen Telegram-Bot-Token."
T_sv["step2"]="Anslut din Telegram-bot-token."

T_en["step3"]="Change your username & password."
T_tr["step3"]="Kullanıcı adı ve şifreni değiştir."
T_zh["step3"]="更改用户名和密码。"
T_de["step3"]="Ändere Benutzername & Passwort."
T_sv["step3"]="Ändra användarnamn & lösenord."

T_en["ssl_choose"]="Choose HTTPS method"
T_tr["ssl_choose"]="HTTPS yöntemini seçin"
T_zh["ssl_choose"]="选择 HTTPS 方式"
T_de["ssl_choose"]="HTTPS-Methode wählen"
T_sv["ssl_choose"]="Välj HTTPS-metod"

T_en["ssl_domain"]="With my own domain"
T_tr["ssl_domain"]="Kendi alan adımla"
T_zh["ssl_domain"]="使用我的域名"
T_de["ssl_domain"]="Mit eigener Domain"
T_sv["ssl_domain"]="Med min egen domän"

T_en["ssl_auto"]="Auto on this IP (no domain)"
T_tr["ssl_auto"]="Bu IP'de otomatik"
T_zh["ssl_auto"]="在此 IP 上自动"
T_de["ssl_auto"]="Automatisch auf dieser IP"
T_sv["ssl_auto"]="Auto på denna IP"

T_en["ssl_enter_domain"]="Enter domain (e.g. panel.example.com)"
T_tr["ssl_enter_domain"]="Alan adını girin"
T_zh["ssl_enter_domain"]="输入域名"
T_de["ssl_enter_domain"]="Domain eingeben"
T_sv["ssl_enter_domain"]="Ange domän"

T_en["ssl_done"]="HTTPS enabled! Panel now at:"
T_tr["ssl_done"]="HTTPS etkin! Panel şimdi:"
T_zh["ssl_done"]="HTTPS 已启用！面板现在位于："
T_de["ssl_done"]="HTTPS aktiviert! Panel jetzt unter:"
T_sv["ssl_done"]="HTTPS aktiverat! Panel nu på:"

T_en["press_enter"]="Press Enter to return to menu"
T_tr["press_enter"]="Menüye dönmek için Enter"
T_zh["press_enter"]="按 Enter 返回菜单"
T_de["press_enter"]="Enter drücken für Menü"
T_sv["press_enter"]="Tryck Enter för meny"

T_en["invalid_choice"]="Invalid choice"
T_tr["invalid_choice"]="Geçersiz seçim"
T_zh["invalid_choice"]="无效选择"
T_de["invalid_choice"]="Ungültige Wahl"
T_sv["invalid_choice"]="Ogiltigt val"

T_en["goodbye"]="Goodbye!"
T_tr["goodbye"]="Hoşça kal!"
T_zh["goodbye"]="再见！"
T_de["goodbye"]="Auf Wiedersehen!"
T_sv["goodbye"]="Hej då!"

T_en["not_installed"]="Nebula is not installed yet. Choose Install first."
T_tr["not_installed"]="Nebula henüz kurulmadı."
T_zh["not_installed"]="Nebula 尚未安装。"
T_de["not_installed"]="Nebula noch nicht installiert."
T_sv["not_installed"]="Nebula är inte installerat än."

T_en["confirm_uninstall"]="Remove Nebula and ALL data? Type yes to confirm"
T_tr["confirm_uninstall"]="Nebula ve TÜM veriler silinsin mi? yes yazın"
T_zh["confirm_uninstall"]="删除 Nebula 和所有数据？输入 yes"
T_de["confirm_uninstall"]="Nebula und ALLE Daten entfernen? yes eingeben"
T_sv["confirm_uninstall"]="Ta bort Nebula och ALL data? Skriv yes"

T_en["removed"]="Nebula removed."
T_tr["removed"]="Nebula kaldırıldı."
T_zh["removed"]="Nebula 已删除。"
T_de["removed"]="Nebula entfernt."
T_sv["removed"]="Nebula borttaget."

T_en["cancelled"]="Cancelled."
T_tr["cancelled"]="İptal edildi."
T_zh["cancelled"]="已取消。"
T_de["cancelled"]="Abgebrochen."
T_sv["cancelled"]="Avbruten."

T_en["updating"]="Updating..."
T_tr["updating"]="Güncelleniyor..."
T_zh["updating"]="正在更新..."
T_de["updating"]="Wird aktualisiert..."
T_sv["updating"]="Uppdaterar..."

T_en["updated"]="Updated to latest. Your data is kept."
T_tr["updated"]="Güncellendi. Verilerin korundu."
T_zh["updated"]="已更新到最新。数据已保留。"
T_de["updated"]="Aktualisiert. Deine Daten bleiben."
T_sv["updated"]="Uppdaterad. Din data behålls."

T_en["restarted"]="Restarted."
T_tr["restarted"]="Yeniden başlatıldı."
T_zh["restarted"]="已重启。"
T_de["restarted"]="Neu gestartet."
T_sv["restarted"]="Omstartad."

t() {
  local key="$1"
  local var="T_${LANG:-en}[$key]"
  local val="${!var:-}"
  [ -z "$val" ] && { var="T_en[$key]"; val="${!var:-$key}"; }
  printf '%s' "$val"
}
# ---- the NEBULA wordmark (big ASCII) -----------------------
# Rendered line-by-line so we can paint a horizontal gradient across it.
logo_lines() {
  cat <<'ART'
███╗   ██╗███████╗██████╗ ██╗   ██╗██╗      █████╗
████╗  ██║██╔════╝██╔══██╗██║   ██║██║     ██╔══██╗
██╔██╗ ██║█████╗  ██████╔╝██║   ██║██║     ███████║
██║╚██╗██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║
██║ ╚████║███████╗██████╔╝╚██████╔╝███████╗██║  ██║
╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
ART
}

# paint one logo line with a left→right gradient
paint_line() {  # $1 = line text, $2 = top col
  local line="$1" col="$2" i ch len
  len=${#line}
  move_to "$3" "$col"
  for (( i=0; i<len; i++ )); do
    ch="${line:$i:1}"
    local pos=$(( i * 100 / (len>0?len:1) ))
    grad_color "$pos"
    printf '%s' "$ch"
  done
  reset_all
}

# ---- animated intro ----------------------------------------
# Reveal the logo line by line with a subtle delay, then the tagline
# fades in. Kept fast so it feels slick, not slow.
term_width(){ tput cols 2>/dev/null || echo 80; }

draw_header() {  # $1 = animate? (1/0)
  local animate="${1:-0}"
  clear_scr
  local W; W=$(term_width)
  local logo_w=50
  local col=$(( (W - logo_w) / 2 )); [ "$col" -lt 1 ] && col=1

  # background top accent bar
  local row=2
  # logo lines
  local -a L
  mapfile -t L < <(logo_lines)
  local n=${#L[@]}
  for (( r=0; r<n; r++ )); do
    if [ "$animate" = "1" ]; then sleep 0.04; fi
    paint_line "${L[$r]}" "$col" "$(( row + r ))"
  done

  # tagline: NEBULA AI PLATFORM
  local tag="N E B U L A   A I   P L A T F O R M"
  local tcol=$(( (W - ${#tag}) / 2 )); [ "$tcol" -lt 1 ] && tcol=1
  local trow=$(( row + n + 1 ))
  if [ "$animate" = "1" ]; then sleep 0.12; fi
  move_to "$trow" "$tcol"
  bold; fg 148 163 184; printf '%s' "$tag"; reset_all

  # thin gradient divider
  local drow=$(( trow + 2 ))
  local dw=$(( logo_w )); local dcol="$col"
  move_to "$drow" "$dcol"
  local i
  for (( i=0; i<dw; i++ )); do
    grad_color $(( i * 100 / dw )); printf '─'
  done
  reset_all
  MENU_TOP=$(( drow + 2 ))   # where the menu starts, below the header
}

# ---- arrow-key menu ----------------------------------------
# Draws a vertical list under the header; ↑/↓ move, Enter selects.
# Returns the chosen index (0-based) in $MENU_RESULT.
MENU_RESULT=-1

read_key() {
  # read a single keypress; translate arrows/enter to tokens
  local k rest
  IFS= read -rsn1 k </dev/tty || true
  if [ "$k" = "$ESC" ]; then
    read -rsn2 -t 0.001 rest </dev/tty || true
    case "$rest" in
      '[A') echo up ;; '[B') echo down ;;
      '[C') echo right ;; '[D') echo left ;;
      *) echo esc ;;
    esac
  elif [ -z "$k" ]; then echo enter
  else
    case "$k" in
      q|Q) echo quit ;;
      *) echo other ;;
    esac
  fi
}

# draw the menu items; highlight the selected one as a "button"
draw_menu() {  # uses global MENU_ITEMS[], MENU_SEL, MENU_TOP, MENU_TITLE
  local W; W=$(term_width)
  local n=${#MENU_ITEMS[@]}
  local boxw=46
  local col=$(( (W - boxw) / 2 )); [ "$col" -lt 1 ] && col=1

  # title line above menu
  move_to "$MENU_TOP" "$col"
  bold; fg 203 213 225; printf '%s' "$MENU_TITLE"; reset_all

  local start=$(( MENU_TOP + 2 ))
  local i
  for (( i=0; i<n; i++ )); do
    local row=$(( start + i ))
    move_to "$row" "$col"
    if [ "$i" -eq "$MENU_SEL" ]; then
      # selected → filled gradient-ish button
      bg 99 102 241; fg 255 255 255; bold
      printf '  %-42s' "${MENU_ITEMS[$i]}"
      reset_all
    else
      fg 148 163 184
      printf '  %-42s' "${MENU_ITEMS[$i]}"
      reset_all
    fi
  done

  # hint line
  local hrow=$(( start + n + 1 ))
  move_to "$hrow" "$col"
  dim; fg 100 116 139
  printf '%s' "↑/↓  •  Enter  •  q"
  reset_all
}

# run a menu: args are the item labels. sets MENU_RESULT.
run_menu() {  # $MENU_TITLE must be set; "$@" = items
  MENU_ITEMS=("$@")
  MENU_SEL=0
  local n=${#MENU_ITEMS[@]}
  hide_cursor
  draw_header 0
  draw_menu
  while true; do
    case "$(read_key)" in
      up)    MENU_SEL=$(( (MENU_SEL - 1 + n) % n )); draw_menu ;;
      down)  MENU_SEL=$(( (MENU_SEL + 1) % n )); draw_menu ;;
      enter) MENU_RESULT=$MENU_SEL; return 0 ;;
      quit|esc) MENU_RESULT=-1; return 1 ;;
    esac
  done
}

# ---- secrets & helpers -------------------------------------
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

# ---- gauge helper: run a command, show a progress line ------
# We drive a whiptail gauge from a sequence of steps.

install_docker_q() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    return 0
  fi
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq >/dev/null 2>&1
  apt-get install -y -qq ca-certificates curl gnupg >/dev/null 2>&1
  install -m 0755 -d /etc/apt/keyrings
  if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2>/dev/null
    chmod a+r /etc/apt/keyrings/docker.gpg
  fi
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -qq >/dev/null 2>&1
  apt-get install -y -qq docker-ce docker-ce-cli containerd.io \
      docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1
  systemctl enable --now docker >/dev/null 2>&1 || true
}

write_env() {
  mkdir -p "$APP_DIR"
  if [ -f "$ENV_FILE" ]; then
    ADMIN_USERNAME=$(grep -E '^ADMIN_USERNAME=' "$ENV_FILE" | cut -d= -f2- || echo "admin")
    ADMIN_PASSWORD=$(grep -E '^ADMIN_PASSWORD=' "$ENV_FILE" | cut -d= -f2- || echo "(set earlier)")
    return
  fi
  ADMIN_USERNAME="admin"
  ADMIN_PASSWORD="$(rand_pass)"
  local secret; secret="$(rand_hex 48)"
  cat > "$ENV_FILE" <<EOF
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

# ---- a simple centered "screen" for messages ---------------
info_screen() {  # $1 = title line, $2.. = body lines
  draw_header 0
  local W; W=$(term_width)
  local row=$MENU_TOP
  local title="$1"; shift
  local col=$(( (W - 46) / 2 )); [ "$col" -lt 1 ] && col=1
  move_to "$row" "$col"; bold; fg 203 213 225; printf '%s' "$title"; reset_all
  local i=2
  for line in "$@"; do
    move_to "$(( row + i ))" "$col"; fg 148 163 184; printf '%s' "$line"; reset_all
    i=$(( i + 1 ))
  done
  move_to "$(( row + i + 1 ))" "$col"; dim; fg 100 116 139
  printf '%s' "$(t press_enter)"; reset_all
  read -rsn1 _ </dev/tty || true
}

# ---- install (with animated status lines) ------------------
do_install() {
  draw_header 0
  local W; W=$(term_width)
  local col=$(( (W - 46) / 2 )); [ "$col" -lt 1 ] && col=1
  local row=$MENU_TOP
  _line(){ move_to "$(( row + $1 ))" "$col"; fg "$2" "$3" "$4"; printf '%s' "$5"; reset_all; }

  _line 0 99 102 241 "⏳ $(t installing_docker)"
  install_docker_q
  _line 0 56 189 140 "✓  $(t docker_present)     "
  _line 1 99 102 241 "⏳ $(t preparing_config)"
  write_env; write_compose
  _line 1 56 189 140 "✓  $(t config_generated)     "
  _line 2 99 102 241 "⏳ $(t pulling_image)"
  docker pull "$IMAGE" >/dev/null 2>&1
  _line 2 56 189 140 "✓  $(t image_pulled)     "
  _line 3 99 102 241 "⏳ $(t starting)"
  docker compose --project-directory "$APP_DIR" -f "$COMPOSE_FILE" up -d >/dev/null 2>&1
  install_cli
  _line 3 56 189 140 "✓  $(t container_up)     "
  sleep 1

  local ip; ip="$(public_ip)"
  local url="http://${ip}:${HOST_PORT:-$DEFAULT_PORT}"
  info_screen "🎉  $(t is_live)" \
    "" \
    "$(t panel_url):  $url" \
    "$(t username):  ${ADMIN_USERNAME}" \
    "$(t password):  ${ADMIN_PASSWORD}" \
    "" \
    "$(t change_later)" \
    "" \
    "1. $(t step1)" \
    "2. $(t step2)" \
    "3. $(t step3)"
}

do_update() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_update)" "$(t not_installed)"; return; fi
  draw_header 0
  local W; W=$(term_width); local col=$(( (W-46)/2 )); [ "$col" -lt 1 ] && col=1
  move_to "$MENU_TOP" "$col"; fg 99 102 241; printf '⏳ %s' "$(t updating)"; reset_all
  docker pull "$IMAGE" >/dev/null 2>&1
  docker compose --project-directory "$APP_DIR" -f "$COMPOSE_FILE" up -d >/dev/null 2>&1
  info_screen "$(t menu_update)" "✓  $(t updated)"
}

do_ssl() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_ssl)" "$(t not_installed)"; return; fi
  MENU_TITLE="$(t ssl_choose)"
  run_menu "🌐  $(t ssl_domain)" "⚡  $(t ssl_auto)" || return
  local domain="auto"
  if [ "$MENU_RESULT" = "0" ]; then
    show_cursor
    draw_header 0
    local W; W=$(term_width); local col=$(( (W-46)/2 )); [ "$col" -lt 1 ] && col=1
    move_to "$MENU_TOP" "$col"; fg 203 213 225; printf '%s: ' "$(t ssl_enter_domain)"; reset_all
    read -r domain </dev/tty
    hide_cursor
    [ -z "$domain" ] && return
  fi
  clear_scr; show_cursor
  nebula ssl "$domain" || true
  echo ""; read -r -p "  $(t press_enter) " _ </dev/tty
  hide_cursor
}

do_status() {
  local out="-"
  [ -d "$APP_DIR" ] && out=$(docker compose --project-directory "$APP_DIR" ps 2>/dev/null | tail -n +1 | head -4 || echo "-")
  clear_scr; show_cursor; draw_header 0
  echo ""; echo "$out"; echo ""
  read -r -p "  $(t press_enter) " _ </dev/tty; hide_cursor
}

do_logs() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_logs)" "$(t not_installed)"; return; fi
  clear_scr; show_cursor
  docker compose --project-directory "$APP_DIR" logs --tail=100 2>/dev/null || true
  echo ""; read -r -p "  $(t press_enter) " _ </dev/tty; hide_cursor
}

do_password() {
  local p="—"
  [ -f "$ENV_FILE" ] && p=$(grep -E '^ADMIN_PASSWORD=' "$ENV_FILE" | cut -d= -f2-)
  info_screen "🔑  $(t menu_password)" "" "$(t password):  $p"
}

do_restart() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_restart)" "$(t not_installed)"; return; fi
  docker compose --project-directory "$APP_DIR" restart >/dev/null 2>&1
  info_screen "$(t menu_restart)" "✓  $(t restarted)"
}

do_uninstall() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_uninstall)" "$(t not_installed)"; return; fi
  MENU_TITLE="$(t confirm_uninstall)"
  run_menu "$(t menu_exit)" "$(t menu_uninstall)" || return
  if [ "$MENU_RESULT" = "1" ]; then
    docker compose --project-directory "$APP_DIR" down -v >/dev/null 2>&1 || true
    docker rmi -f "$IMAGE" >/dev/null 2>&1 || true
    rm -rf "$APP_DIR"; rm -f "$BIN_PATH"
    info_screen "$(t menu_uninstall)" "✓  $(t removed)"
  fi
}

# ---- language picker (arrow-key) ---------------------------
pick_language() {
  MENU_TITLE="Choose your language"
  run_menu "English" "Türkçe" "中文 (Chinese)" "Deutsch" "Svenska" || { clear_scr; exit 0; }
  case "$MENU_RESULT" in
    0) LANG="en" ;; 1) LANG="tr" ;; 2) LANG="zh" ;;
    3) LANG="de" ;; 4) LANG="sv" ;; *) LANG="en" ;;
  esac
}

# ---- main menu loop ----------------------------------------
main_menu() {
  while true; do
    MENU_TITLE="$(t menu_title)"
    run_menu \
      "🚀  $(t menu_install)" \
      "⬆️   $(t menu_update)" \
      "🔒  $(t menu_ssl)" \
      "📊  $(t menu_status)" \
      "📜  $(t menu_logs)" \
      "🔑  $(t menu_password)" \
      "🔄  $(t menu_restart)" \
      "🗑   $(t menu_uninstall)" \
      "❌  $(t menu_exit)" \
      || { clear_scr; exit 0; }
    case "$MENU_RESULT" in
      0) do_install ;;  1) do_update ;;  2) do_ssl ;;
      3) do_status ;;   4) do_logs ;;    5) do_password ;;
      6) do_restart ;;  7) do_uninstall ;;
      8) clear_scr; exit 0 ;;
    esac
  done
}

# ============================================================
main() {
  hide_cursor
  draw_header 1     # animated intro on first draw
  pick_language
  main_menu
}
main "$@"
