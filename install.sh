#!/usr/bin/env bash
# ============================================================
# Nebula AI Platform — Premium Installer (animated cosmic TUI)
# ============================================================
#   bash <(curl -Ls https://nebulapanel.cloud/install)
#
# Hand-built terminal UI with a cosmic theme: starfield splash, animated
# gradient NEBULA logo, floating framed panel, spinner, progress bar, and
# live server stats. Arrow-key navigation. 5 languages.
# ============================================================

set -euo pipefail
cd / 2>/dev/null || true

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
alt_screen(){ printf '%s[?1049h' "$ESC"; }   # enter alternate buffer
main_screen(){ printf '%s[?1049l' "$ESC"; }  # restore user's screen
move_to(){ printf '%s[%d;%dH' "$ESC" "$1" "$2"; }
reset_all(){ printf '%s[0m' "$ESC"; }
cleanup(){ show_cursor; reset_all; main_screen 2>/dev/null || true; printf '\n'; }
trap cleanup EXIT INT TERM

fg(){ printf '%s[38;2;%d;%d;%dm' "$ESC" "$1" "$2" "$3"; }
bg(){ printf '%s[48;2;%d;%d;%dm' "$ESC" "$1" "$2" "$3"; }
bold(){ printf '%s[1m' "$ESC"; }
dim(){ printf '%s[2m' "$ESC"; }

term_w(){ tput cols 2>/dev/null || echo 80; }
term_h(){ tput lines 2>/dev/null || echo 24; }

# ---- gradient (purple → violet → cyan-blue) ----------------
grad_color() {
  local p=$1 r g b t
  if [ "$p" -lt 50 ]; then
    t=$(( p * 2 ))
    r=$(( 139 + (99-139)*t/100 )); g=$(( 92 + (102-92)*t/100 )); b=$(( 246 + (241-246)*t/100 ))
  else
    t=$(( (p-50) * 2 ))
    r=$(( 99 + (56-99)*t/100 )); g=$(( 102 + (189-102)*t/100 )); b=$(( 241 + (248-241)*t/100 ))
  fi
  fg "$r" "$g" "$b"
}
# shifted gradient for animation (offset 0..100 rotates the palette)
grad_color_shift() { local p=$(( ($1 + ${2:-0}) % 100 )); grad_color "$p"; }
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
# ---- starfield --------------------------------------------
# Scatter faint stars across the screen for a nebula backdrop. Drawn once
# (static) so it never lags on slow SSH; twinkle only during the splash.
declare -a STAR_R STAR_C STAR_CH
STAR_CHARS=('·' '.' '✦' '✧' '*' '⋆')
build_starfield() {
  STAR_R=(); STAR_C=(); STAR_CH=()
  local W H n i
  W=$(term_w); H=$(term_h)
  n=$(( W * H / 45 ))   # density
  for (( i=0; i<n; i++ )); do
    STAR_R+=( $(( RANDOM % H + 1 )) )
    STAR_C+=( $(( RANDOM % W + 1 )) )
    STAR_CH+=( "${STAR_CHARS[$(( RANDOM % ${#STAR_CHARS[@]} ))]}" )
  done
}
draw_starfield() {
  local i n=${#STAR_R[@]}
  for (( i=0; i<n; i++ )); do
    move_to "${STAR_R[$i]}" "${STAR_C[$i]}"
    # dim, cool colors for depth
    local shade=$(( RANDOM % 3 ))
    case $shade in
      0) fg 60 60 90 ;; 1) fg 90 90 130 ;; 2) fg 120 120 170 ;;
    esac
    printf '%s' "${STAR_CH[$i]}"
  done
  reset_all
}

# ---- NEBULA wordmark --------------------------------------
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
LOGO_W=50; LOGO_H=6

paint_logo() {  # $1 top row, $2 left col, $3 gradient shift
  local top=$1 col=$2 shift=${3:-0}
  local -a L; mapfile -t L < <(logo_lines)
  local r i ch len
  for (( r=0; r<${#L[@]}; r++ )); do
    move_to "$(( top + r ))" "$col"
    len=${#L[$r]}
    for (( i=0; i<len; i++ )); do
      ch="${L[$r]:$i:1}"
      if [ "$ch" = " " ]; then printf ' '; continue; fi
      grad_color_shift $(( i * 100 / len )) "$shift"
      printf '%s' "$ch"
    done
  done
  reset_all
}

# ---- rounded frame ----------------------------------------
# Draws a floating panel with a subtle gradient border.
FRAME_TOP=0; FRAME_LEFT=0; FRAME_W=0; FRAME_H=0
draw_frame() {  # $1 top $2 left $3 width $4 height
  local top=$1 left=$2 w=$3 h=$4
  FRAME_TOP=$top; FRAME_LEFT=$left; FRAME_W=$w; FRAME_H=$h
  local i
  # top border
  move_to "$top" "$left"; grad_color 20; printf '╭'
  for (( i=0; i<w-2; i++ )); do grad_color $(( 20 + i*60/(w-2) )); printf '─'; done
  grad_color 80; printf '╮'
  # sides
  for (( i=1; i<h-1; i++ )); do
    move_to "$(( top+i ))" "$left"; grad_color 20; printf '│'
    move_to "$(( top+i ))" "$(( left+w-1 ))"; grad_color 80; printf '│'
  done
  # bottom border
  move_to "$(( top+h-1 ))" "$left"; grad_color 30; printf '╰'
  for (( i=0; i<w-2; i++ )); do grad_color $(( 30 + i*50/(w-2) )); printf '─'; done
  grad_color 90; printf '╯'
  reset_all
}

# ---- animated splash --------------------------------------
splash() {
  clear_scr
  build_starfield
  draw_starfield
  local W H; W=$(term_w); H=$(term_h)
  local col=$(( (W - LOGO_W) / 2 )); [ "$col" -lt 1 ] && col=1
  local top=$(( (H - LOGO_H) / 2 - 2 )); [ "$top" -lt 1 ] && top=1
  # gradient sweep animation on the logo
  local s
  for s in 0 15 30 45 60 45 30 15 0; do
    paint_logo "$top" "$col" "$s"
    sleep 0.05
  done
  # tagline fade
  local tag="N E B U L A   A I   P L A T F O R M"
  local tcol=$(( (W - ${#tag}) / 2 )); [ "$tcol" -lt 1 ] && tcol=1
  move_to "$(( top + LOGO_H + 1 ))" "$tcol"
  bold; fg 148 163 184; printf '%s' "$tag"; reset_all
  sleep 0.5
}

# ---- static header (drawn once per screen, no lag) ---------
MENU_TOP=0
draw_header() {
  clear_scr
  draw_starfield
  local W; W=$(term_w)
  local col=$(( (W - LOGO_W) / 2 )); [ "$col" -lt 1 ] && col=1
  paint_logo 2 "$col" 0
  # tagline
  local tag="N E B U L A   A I   P L A T F O R M"
  local tcol=$(( (W - ${#tag}) / 2 )); [ "$tcol" -lt 1 ] && tcol=1
  move_to "$(( 2 + LOGO_H ))" "$tcol"; bold; fg 148 163 184; printf '%s' "$tag"; reset_all
  # live server stats line
  draw_stats "$(( 2 + LOGO_H + 1 ))"
  # divider
  local drow=$(( 2 + LOGO_H + 3 ))
  move_to "$drow" "$col"
  local i
  for (( i=0; i<LOGO_W; i++ )); do grad_color $(( i*100/LOGO_W )); printf '─'; done
  reset_all
  MENU_TOP=$(( drow + 2 ))
}

# ---- live server stats -------------------------------------
draw_stats() {  # $1 row
  local row=$1 W; W=$(term_w)
  local mem cpu disk
  mem=$(free -m 2>/dev/null | awk '/Mem:/{printf "%d/%dMB", $3, $2}' || echo "?")
  disk=$(df -h / 2>/dev/null | awk 'NR==2{print $4" free"}' || echo "?")
  local cores; cores=$(nproc 2>/dev/null || echo "?")
  local info="◈ RAM ${mem}    ◈ ${cores} CPU    ◈ ${disk}"
  local col=$(( (W - ${#info}) / 2 )); [ "$col" -lt 1 ] && col=1
  move_to "$row" "$col"; dim; fg 100 116 139; printf '%s' "$info"; reset_all
}

# ---- spinner (for indeterminate waits) ---------------------
SPIN_CHARS=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
# run a command in background, show spinner+label until it finishes
spin_run() {  # $1 row, $2 col, $3 label, $4.. command
  local row=$1 col=$2 label=$3; shift 3
  ("$@") >/dev/null 2>&1 &
  local pid=$! i=0
  while kill -0 "$pid" 2>/dev/null; do
    move_to "$row" "$col"
    grad_color 40; printf '%s' "${SPIN_CHARS[$(( i % 10 ))]}"
    fg 148 163 184; printf '  %s' "$label"; reset_all
    i=$(( i + 1 )); sleep 0.08
  done
  wait "$pid" 2>/dev/null || true
  move_to "$row" "$col"; fg 56 189 140; printf '✓'; fg 148 163 184; printf '  %s        ' "$label"; reset_all
}

# ---- progress bar ------------------------------------------
draw_progress() {  # $1 row, $2 col, $3 percent, $4 label
  local row=$1 col=$2 pct=$3 label="${4:-}"
  local width=40
  local filled=$(( pct * width / 100 ))
  move_to "$row" "$col"
  printf '['
  local i
  for (( i=0; i<width; i++ )); do
    if [ "$i" -lt "$filled" ]; then grad_color $(( i*100/width )); printf '█'
    else fg 40 40 60; printf '░'; fi
  done
  reset_all; printf '] '
  bold; fg 203 213 225; printf '%3d%%' "$pct"; reset_all
  [ -n "$label" ] && { printf '  '; fg 148 163 184; printf '%s' "$label"; reset_all; }
}

# ============================================================
# Advanced visual effects
# ============================================================

# ---- typewriter -------------------------------------------
# Print text char-by-char. Fast enough to feel slick, not slow.
typewriter() {  # $1 row, $2 col, $3 text, $4 r, $5 g, $6 b, $7 delay
  local row=$1 col=$2 text=$3 r=$4 g=$5 b=$6 delay="${7:-0.012}"
  local i ch
  move_to "$row" "$col"; fg "$r" "$g" "$b"
  for (( i=0; i<${#text}; i++ )); do
    printf '%s' "${text:$i:1}"
    sleep "$delay"
  done
  reset_all
}

# ---- animated nebula cloud (splash background) -------------
# A soft, drifting cloud of colored glyphs — evokes a real nebula.
NEB_GLYPHS=('░' '▒' '·' '∴' '✦' '⋆' '˖' '⊹')
draw_nebula_frame() {  # $1 = phase (0..N) for drift
  local phase=$1 W H
  W=$(term_w); H=$(term_h)
  local cx=$(( W/2 )) cy=$(( H/2 ))
  local y x
  for (( y=1; y<=H; y++ )); do
    for (( x=1; x<=W; x+=2 )); do
      # distance-based density with a drifting sine wobble
      local dx=$(( x - cx )) dy=$(( (y - cy) * 2 ))
      local d2=$(( dx*dx + dy*dy ))
      # pseudo-noise via cheap hash of x,y,phase
      local h=$(( (x*7 + y*13 + phase*5) % 23 ))
      if [ "$d2" -lt $(( (W*W/6) + h*40 )) ] && [ "$h" -gt 15 ]; then
        move_to "$y" "$x"
        # color depends on distance → purple core, blue edges
        local pos=$(( d2 * 100 / (W*W/4 + 1) )); [ "$pos" -gt 100 ] && pos=100
        grad_color "$pos"
        printf '%s' "${NEB_GLYPHS[$(( (h) % ${#NEB_GLYPHS[@]} ))]}"
      fi
    done
  done
  reset_all
}

# ---- shooting star -----------------------------------------
# A streak that flies diagonally across the screen once.
shooting_star() {
  local W H; W=$(term_w); H=$(term_h)
  local sr=$(( RANDOM % (H/2) + 1 ))
  local sc=$(( RANDOM % (W/2) + 1 ))
  local len=6 i j
  local tail=('.' '·' '•' '✦' '★' '☄')
  for (( i=0; i<W-sc && i<H-sr; i+=2 )); do
    local r=$(( sr + i/2 )) c=$(( sc + i ))
    # draw head + fading tail
    for (( j=0; j<len; j++ )); do
      local tr=$(( r - j/2 )) tc=$(( c - j ))
      [ "$tr" -lt 1 ] && continue; [ "$tc" -lt 1 ] && continue
      move_to "$tr" "$tc"
      local bright=$(( 255 - j*35 ))
      fg "$bright" "$bright" 255
      printf '%s' "${tail[$(( len-1-j < ${#tail[@]} ? len-1-j : 0 ))]}"
    done
    reset_all
    sleep 0.02
    # erase the tail-end
    local er=$(( r - (len-1)/2 )) ec=$(( c - (len-1) ))
    [ "$er" -ge 1 ] && [ "$ec" -ge 1 ] && { move_to "$er" "$ec"; printf ' '; }
  done
}

# ---- planet spinner ----------------------------------------
# A little orbiting spinner for indeterminate waits.
PLANET=('🌑' '🌒' '🌓' '🌔' '🌕' '🌖' '🌗' '🌘')
spin_planet() {  # $1 row $2 col $3 label ; runs cmd in $4..
  local row=$1 col=$2 label=$3; shift 3
  ("$@") >/dev/null 2>&1 &
  local pid=$! i=0
  while kill -0 "$pid" 2>/dev/null; do
    move_to "$row" "$col"
    printf '%s' "${PLANET[$(( i % 8 ))]}"
    fg 148 163 184; printf '  %s' "$label"; reset_all
    i=$(( i+1 )); sleep 0.12
  done
  wait "$pid" 2>/dev/null || true
  move_to "$row" "$col"; fg 56 189 140; printf '✓ '; fg 148 163 184; printf ' %s      ' "$label"; reset_all
}

# ---- epic animated splash ----------------------------------
epic_splash() {
  clear_scr
  local W H; W=$(term_w); H=$(term_h)
  local col=$(( (W - LOGO_W) / 2 )); [ "$col" -lt 1 ] && col=1
  local top=$(( (H - LOGO_H) / 2 - 2 )); [ "$top" -lt 1 ] && top=1

  # 1) nebula cloud drifts in (a few frames)
  local ph
  for ph in 0 1 2; do
    clear_scr
    draw_nebula_frame "$ph"
    sleep 0.06
  done

  # 2) a shooting star streaks by
  shooting_star &
  local ss=$!

  # 3) logo gradient sweep reveal
  local s
  for s in 0 12 24 36 48 60 48 36 24 12 0; do
    paint_logo "$top" "$col" "$s"
    sleep 0.04
  done
  wait "$ss" 2>/dev/null || true

  # 4) tagline typewriter
  local tag="N E B U L A   A I   P L A T F O R M"
  local tcol=$(( (W - ${#tag}) / 2 )); [ "$tcol" -lt 1 ] && tcol=1
  typewriter "$(( top + LOGO_H + 1 ))" "$tcol" "$tag" 148 163 184 0.015

  # 5) subtitle
  local sub="✦  Powerful Telegram Bot & Panel Platform  ✦"
  local scol=$(( (W - ${#sub}) / 2 )); [ "$scol" -lt 1 ] && scol=1
  move_to "$(( top + LOGO_H + 3 ))" "$scol"; dim; fg 120 130 160; printf '%s' "$sub"; reset_all
  sleep 0.7
}

# ---- glow/breathing highlight for the selected button ------
# We render the selected item with a brightness that "breathes" using a
# short, non-blocking pulse each time selection changes. Kept light so it
# never lags: a 3-step pulse, not a continuous loop.
pulse_selected() {  # $1 row $2 col $3 text
  local row=$1 col=$2 text=$3
  local shades=("60 55 120" "80 72 150" "99 90 180" "80 72 150")
  local s
  for s in "${shades[@]}"; do
    set -- $s
    move_to "$row" "$col"
    grad_color 30; printf '▸ '
    bg "$1" "$2" "$3"; fg 255 255 255; bold
    printf ' %-44s ' "$text"
    reset_all
    sleep 0.03
  done
}

# ---- bottom status bar -------------------------------------
draw_statusbar() {  # $1 = hint text
  local W H; W=$(term_w); H=$(term_h)
  local hint="${1:-  ↑ ↓  navigate    ⏎  select    q  quit}"
  move_to "$H" 1
  bg 30 30 50; fg 148 163 184
  printf '%-*s' "$W" "  ◈ Nebula AI Platform${hint}"
  reset_all
}

# ---- arrow-key menu (with glow + status bar) ---------------
MENU_RESULT=-1
read_key() {
  local k rest
  IFS= read -rsn1 k </dev/tty || true
  if [ "$k" = "$ESC" ]; then
    read -rsn2 -t 0.001 rest </dev/tty || true
    case "$rest" in '[A') echo up ;; '[B') echo down ;; '[C') echo right ;; '[D') echo left ;; *) echo esc ;; esac
  elif [ -z "$k" ]; then echo enter
  else case "$k" in q|Q) echo quit ;; *) echo other ;; esac
  fi
}

MENU_PREV=-1
draw_menu() {
  local W; W=$(term_w)
  local n=${#MENU_ITEMS[@]}
  local boxw=50
  local col=$(( (W - boxw) / 2 )); [ "$col" -lt 1 ] && col=1
  move_to "$MENU_TOP" "$col"; bold; fg 203 213 225; printf '  %s' "$MENU_TITLE"; reset_all
  local start=$(( MENU_TOP + 2 ))
  local i
  for (( i=0; i<n; i++ )); do
    local row=$(( start + i ))
    if [ "$i" -eq "$MENU_SEL" ]; then
      # glow pulse only on the newly-selected row (cheap, no loop lag)
      pulse_selected "$row" "$col" "${MENU_ITEMS[$i]}"
    else
      move_to "$row" "$col"; printf '  '; fg 160 170 190
      printf ' %-44s ' "${MENU_ITEMS[$i]}"; reset_all
    fi
  done
  draw_statusbar
}

run_menu() {
  MENU_ITEMS=("$@"); MENU_SEL=0; MENU_PREV=-1
  local n=${#MENU_ITEMS[@]}
  hide_cursor; draw_header; draw_menu
  while true; do
    case "$(read_key)" in
      up)    MENU_SEL=$(( (MENU_SEL-1+n)%n )); draw_menu ;;
      down)  MENU_SEL=$(( (MENU_SEL+1)%n )); draw_menu ;;
      enter) MENU_RESULT=$MENU_SEL; return 0 ;;
      quit|esc) MENU_RESULT=-1; return 1 ;;
    esac
  done
}

# ---- 3D-ish info card --------------------------------------
# Draws a bordered card with a drop shadow for the success screen.
draw_card() {  # $1 top $2 left $3 width $4 height $5 title
  local top=$1 left=$2 w=$3 h=$4 title=$5 i
  # shadow (offset by 1,2)
  for (( i=1; i<h; i++ )); do
    move_to "$(( top+i+1 ))" "$(( left+2 ))"; bg 15 15 25; printf '%*s' "$w" ''; reset_all
  done
  # card body
  move_to "$top" "$left"; grad_color 20; printf '╭'
  for (( i=0; i<w-2; i++ )); do grad_color $(( 20+i*60/(w-2) )); printf '─'; done
  grad_color 80; printf '╮'; reset_all
  for (( i=1; i<h-1; i++ )); do
    move_to "$(( top+i ))" "$left"; grad_color 20; printf '│'; reset_all
    move_to "$(( top+i ))" "$(( left+w-1 ))"; grad_color 80; printf '│'; reset_all
  done
  move_to "$(( top+h-1 ))" "$left"; grad_color 30; printf '╰'
  for (( i=0; i<w-2; i++ )); do grad_color $(( 30+i*50/(w-2) )); printf '─'; done
  grad_color 90; printf '╯'; reset_all
  # title
  move_to "$top" "$(( left+2 ))"; bold; fg 203 213 225; printf ' %s ' "$title"; reset_all
}

# ---- success screen with card ------------------------------
success_card() {  # passes lines as args
  draw_header
  local W; W=$(term_w)
  local cw=54 ch=$(( $# + 4 ))
  local left=$(( (W - cw)/2 )); [ "$left" -lt 1 ] && left=1
  local top=$MENU_TOP
  draw_card "$top" "$left" "$cw" "$ch" "🎉  $(t is_live)"
  local i=2
  for line in "$@"; do
    move_to "$(( top+i ))" "$(( left+3 ))"; fg 200 210 230; printf '%s' "$line"; reset_all
    i=$(( i+1 ))
  done
  draw_statusbar "    $(t press_enter)"
  read -rsn1 _ </dev/tty || true
}

# ---- plain info screen -------------------------------------
info_screen() {
  draw_header
  local W; W=$(term_w); local col=$(( (W-50)/2 )); [ "$col" -lt 1 ] && col=1
  local row=$MENU_TOP; local title="$1"; shift
  move_to "$row" "$col"; bold; fg 203 213 225; printf '  %s' "$title"; reset_all
  local i=2
  for line in "$@"; do
    move_to "$(( row+i ))" "$col"; fg 148 163 184; printf '  %s' "$line"; reset_all; i=$(( i+1 ))
  done
  draw_statusbar "    $(t press_enter)"
  read -rsn1 _ </dev/tty || true
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

# ---- install with progress + planet spinner + card --------
do_install() {
  draw_header
  local W; W=$(term_w); local col=$(( (W-50)/2 )); [ "$col" -lt 1 ] && col=1
  local prow=$MENU_TOP

  draw_progress "$prow" "$col" 8 "$(t installing_docker)"
  install_docker_q
  draw_progress "$prow" "$col" 40 "$(t docker_present)        "
  draw_progress "$prow" "$col" 52 "$(t preparing_config)      "
  write_env; write_compose
  draw_progress "$prow" "$col" 62 "$(t config_generated)      "
  draw_progress "$prow" "$col" 72 "$(t pulling_image)         "
  docker pull "$IMAGE" >/dev/null 2>&1
  draw_progress "$prow" "$col" 90 "$(t image_pulled)          "
  draw_progress "$prow" "$col" 96 "$(t starting)              "
  docker compose --project-directory "$APP_DIR" -f "$COMPOSE_FILE" up -d >/dev/null 2>&1
  install_cli
  draw_progress "$prow" "$col" 100 "$(t container_up)          "
  sleep 0.7

  local ip; ip="$(public_ip)"
  local url="http://${ip}:${HOST_PORT:-$DEFAULT_PORT}"
  success_card \
    "$(t panel_url):  $url" \
    "$(t username):   ${ADMIN_USERNAME}" \
    "$(t password):   ${ADMIN_PASSWORD}" \
    "" \
    "$(t change_later)" \
    "" \
    "1.  $(t step1)" \
    "2.  $(t step2)" \
    "3.  $(t step3)"
}

do_update() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_update)" "$(t not_installed)"; return; fi
  draw_header
  local W; W=$(term_w); local col=$(( (W-50)/2 )); [ "$col" -lt 1 ] && col=1
  draw_progress "$MENU_TOP" "$col" 30 "$(t updating)"
  docker pull "$IMAGE" >/dev/null 2>&1
  draw_progress "$MENU_TOP" "$col" 80 "$(t updating)  "
  docker compose --project-directory "$APP_DIR" -f "$COMPOSE_FILE" up -d >/dev/null 2>&1
  draw_progress "$MENU_TOP" "$col" 100 "$(t updated)   "
  sleep 0.6; info_screen "$(t menu_update)" "✓  $(t updated)"
}

do_ssl() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_ssl)" "$(t not_installed)"; return; fi
  MENU_TITLE="$(t ssl_choose)"
  run_menu "🌐  $(t ssl_domain)" "⚡  $(t ssl_auto)" || return
  local domain="auto"
  if [ "$MENU_RESULT" = "0" ]; then
    draw_header; show_cursor
    local W; W=$(term_w); local col=$(( (W-50)/2 )); [ "$col" -lt 1 ] && col=1
    move_to "$MENU_TOP" "$col"; fg 203 213 225; printf '  %s: ' "$(t ssl_enter_domain)"; reset_all
    read -r domain </dev/tty; hide_cursor
    [ -z "$domain" ] && return
  fi
  clear_scr; show_cursor
  nebula ssl "$domain" || true
  echo ""; read -r -p "  $(t press_enter) " _ </dev/tty; hide_cursor
}

do_status() {
  local out="-"; [ -d "$APP_DIR" ] && out=$(docker compose --project-directory "$APP_DIR" ps 2>/dev/null | head -4 || echo "-")
  clear_scr; show_cursor; draw_header; echo ""; echo "$out"; echo ""
  read -r -p "  $(t press_enter) " _ </dev/tty; hide_cursor
}
do_logs() {
  if [ ! -d "$APP_DIR" ]; then info_screen "$(t menu_logs)" "$(t not_installed)"; return; fi
  clear_scr; show_cursor
  docker compose --project-directory "$APP_DIR" logs --tail=100 2>/dev/null || true
  echo ""; read -r -p "  $(t press_enter) " _ </dev/tty; hide_cursor
}
do_password() {
  local p="—"; [ -f "$ENV_FILE" ] && p=$(grep -E '^ADMIN_PASSWORD=' "$ENV_FILE" | cut -d= -f2-)
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
pick_language() {
  MENU_TITLE="Choose your language"
  run_menu "English" "Türkçe" "中文 (Chinese)" "Deutsch" "Svenska" || { clear_scr; exit 0; }
  case "$MENU_RESULT" in 0) LANG="en";;1) LANG="tr";;2) LANG="zh";;3) LANG="de";;4) LANG="sv";;*) LANG="en";; esac
}
main_menu() {
  while true; do
    MENU_TITLE="$(t menu_title)"
    run_menu \
      "🚀   $(t menu_install)" "⬆️    $(t menu_update)" "🔒   $(t menu_ssl)" \
      "📊   $(t menu_status)" "📜   $(t menu_logs)" "🔑   $(t menu_password)" \
      "🔄   $(t menu_restart)" "🗑    $(t menu_uninstall)" "❌   $(t menu_exit)" \
      || { clear_scr; exit 0; }
    case "$MENU_RESULT" in
      0) do_install;;1) do_update;;2) do_ssl;;3) do_status;;4) do_logs;;
      5) do_password;;6) do_restart;;7) do_uninstall;;8) clear_scr; exit 0;;
    esac
  done
}
main() {
  alt_screen; hide_cursor
  epic_splash
  pick_language
  main_menu
}
main "$@"
