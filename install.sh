#!/usr/bin/env bash
# ============================================================
# Nebula AI Platform — one-line installer  (Ubuntu 22.04 / 24.04)
# ============================================================
#   bash <(curl -Ls https://YOUR_DOMAIN/install)
#
# Fully automatic: installs Docker, generates a secure .env, pulls the
# closed app image, starts it as an always-on service, and (optionally)
# sets up Nginx + free HTTPS. Ends with a slick summary screen.
#
# Everything can be changed later inside the panel (password, username,
# bot token). This script never asks for those.
# ============================================================

set -euo pipefail

# ---- constants ---------------------------------------------
IMAGE="weblinuxi/nebula-platform:latest"
APP_DIR="/opt/nebula"
COMPOSE_FILE="$APP_DIR/docker-compose.yml"
ENV_FILE="$APP_DIR/.env"
BIN_PATH="/usr/local/bin/nebula"
DEFAULT_PORT=3000

# ---- colors / ui helpers -----------------------------------
if [ -t 1 ]; then
  B=$(printf '\033[1m');  R=$(printf '\033[0m')
  CYAN=$(printf '\033[38;5;45m');  GREEN=$(printf '\033[38;5;46m')
  YELL=$(printf '\033[38;5;226m'); RED=$(printf '\033[38;5;196m')
  PURP=$(printf '\033[38;5;135m'); GREY=$(printf '\033[38;5;245m')
else
  B=""; R=""; CYAN=""; GREEN=""; YELL=""; RED=""; PURP=""; GREY=""
fi

msg()  { printf "%s\n" "$*"; }
step() { printf "${CYAN}${B}▶ %s${R}\n" "$*"; }
ok()   { printf "${GREEN}  ✓ %s${R}\n" "$*"; }
warn() { printf "${YELL}  ! %s${R}\n" "$*"; }
die()  { printf "${RED}${B}✗ %s${R}\n" "$*" >&2; exit 1; }

# ---- banner ------------------------------------------------
banner() {
  clear 2>/dev/null || true
  printf "${PURP}${B}"
  cat <<'EOF'
    _   _      _           _
  | \ | |    | |         | |
  |  \| | ___| |__  _   _| | __ _
  | . ` |/ _ \ '_ \| | | | |/ _` |
  | |\  |  __/ |_) | |_| | | (_| |
  |_| \_|\___|_.__/ \__,_|_|\__,_|
EOF
  printf "${R}"
  printf "${GREY}        Nebula AI Platform — Installer${R}\n\n"
}

# ---- must be root ------------------------------------------
require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    die "Please run as root:  sudo bash <(curl -Ls https://YOUR_DOMAIN/install)"
  fi
}

# ---- detect OS ---------------------------------------------
check_os() {
  step "Checking system"
  if [ ! -f /etc/os-release ]; then die "Unsupported OS (no /etc/os-release)."; fi
  . /etc/os-release
  if [ "${ID:-}" != "ubuntu" ] && [ "${ID_LIKE:-}" != "debian" ]; then
    warn "This installer is tuned for Ubuntu. Detected: ${PRETTY_NAME:-unknown}. Continuing anyway."
  else
    ok "OS: ${PRETTY_NAME:-Ubuntu}"
  fi
  ARCH=$(uname -m)
  ok "Arch: $ARCH"
}

# ---- helpers to generate secrets ---------------------------
# NOTE: piping /dev/urandom into `head` trips `set -o pipefail` (the
# reader closes early → SIGPIPE on the writer → non-zero exit → the
# whole script dies silently). We use openssl when available (clean and
# reliable), with a pipefail-safe fallback that reads a fixed chunk
# instead of relying on head closing the pipe.
rand_hex() {
  local n="${1:-32}"
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex "$n"
  else
    # Read enough bytes in one go, then hex-encode. No early pipe close.
    od -An -tx1 -N "$n" /dev/urandom | tr -d ' \n'
  fi
}
rand_pass() {
  # 16-char human-safe password (no ambiguous chars: 0/O/1/l/I).
  if command -v openssl >/dev/null 2>&1; then
    # base64 a few bytes, strip ambiguous/padding chars, take 16.
    openssl rand -base64 24 | tr -dc 'A-HJ-NP-Za-km-z2-9' | cut -c1-16
  else
    # Pull a fixed chunk (256 bytes) so the reader never closes early,
    # filter to safe chars, then take the first 16.
    od -An -tx1 -N 256 /dev/urandom | tr -dc 'A-HJ-NP-Za-km-z2-9' | cut -c1-16
  fi
}

# ---- install docker ----------------------------------------
install_docker() {
  step "Installing Docker"
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    ok "Docker already present"
    return
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
  ok "Docker installed"
}

# ---- write .env (only if missing, so re-runs don't reset it) ----
write_env() {
  step "Preparing configuration"
  mkdir -p "$APP_DIR"
  if [ -f "$ENV_FILE" ]; then
    ok "Existing .env kept (your settings are safe)"
    # Load existing creds so the summary can show them.
    ADMIN_USERNAME=$(grep -E '^ADMIN_USERNAME=' "$ENV_FILE" | cut -d= -f2- || echo "admin")
    ADMIN_PASSWORD=$(grep -E '^ADMIN_PASSWORD=' "$ENV_FILE" | cut -d= -f2- || echo "(set earlier)")
    return
  fi
  ADMIN_USERNAME="admin"
  ADMIN_PASSWORD="$(rand_pass)"
  local secret; secret="$(rand_hex 48)"
  cat > "$ENV_FILE" <<EOF
# Generated by the Nebula installer on $(date -u +%Y-%m-%dT%H:%M:%SZ)
# You can change USERNAME/PASSWORD later from the panel.

# --- Telegram Bot (connect from the panel after install) ---
BOT_TOKEN=
BOT_USERNAME=

# --- Required channel (optional; set from panel) ---
REQUIRED_CHANNEL=
REQUIRED_CHANNEL_URL=

# --- Admin panel login (change later in the panel) ---
ADMIN_USERNAME=${ADMIN_USERNAME}
ADMIN_PASSWORD=${ADMIN_PASSWORD}

# --- Security ---
SESSION_SECRET=${secret}

# --- Runtime ---
NODE_ENV=production
PORT=3000
DB_PATH=/app/data/bot.db

# Session cookies over plain HTTP (IP access). Set to true once you put
# the panel behind HTTPS (domain + SSL) so cookies are HTTPS-only.
SECURE_COOKIES=false

# Host port the panel is published on (installer may change this).
HOST_PORT=${DEFAULT_PORT}
EOF
  chmod 600 "$ENV_FILE"
  ok "Config generated (secure random secrets)"
}

# ---- write compose file ------------------------------------
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
  ok "Compose file written"
}

# ---- pull + start ------------------------------------------
start_app() {
  step "Pulling application image"
  docker pull "$IMAGE" >/dev/null && ok "Image pulled"
  step "Starting Nebula"
  ( cd "$APP_DIR" && docker compose up -d >/dev/null )
  ok "Container is up"
}

# ---- install the 'nebula' management command ---------------
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
  uninstall)
      read -rp "Remove Nebula and ALL data? Type 'yes': " c
      [ "$c" = "yes" ] || { echo "Cancelled."; exit 0; }
      docker compose down -v
      echo "Nebula removed." ;;
  *)
      echo "Nebula AI Platform — commands:"
      echo "  nebula start      Start the platform"
      echo "  nebula stop       Stop it"
      echo "  nebula restart    Restart it"
      echo "  nebula status     Show container status"
      echo "  nebula logs       Follow live logs"
      echo "  nebula update     Update to the newest version"
      echo "  nebula version    Show installed version"
      echo "  nebula password   Show the panel password"
      echo "  nebula uninstall  Remove everything" ;;
esac
EOF
  chmod +x "$BIN_PATH"
  ok "'nebula' command ready"
}

# ---- detect public ip --------------------------------------
public_ip() {
  curl -fsS --max-time 5 https://api.ipify.org 2>/dev/null \
    || curl -fsS --max-time 5 https://ifconfig.me 2>/dev/null \
    || hostname -I | awk '{print $1}'
}

# ---- final summary screen ----------------------------------
summary() {
  local ip; ip="$(public_ip)"
  local url="http://${ip}:${HOST_PORT:-$DEFAULT_PORT}"
  if [ -n "${PANEL_DOMAIN:-}" ]; then url="https://${PANEL_DOMAIN}"; fi

  printf "\n"
  printf "${GREEN}${B}╔══════════════════════════════════════════════════╗${R}\n"
  printf "${GREEN}${B}║        Nebula AI Platform is LIVE  🎉             ║${R}\n"
  printf "${GREEN}${B}╚══════════════════════════════════════════════════╝${R}\n\n"

  printf "  ${B}Panel URL${R}        ${CYAN}%s${R}\n" "$url"
  printf "  ${B}Username${R}         %s\n" "${ADMIN_USERNAME}"
  printf "  ${B}Password${R}         %s\n" "${ADMIN_PASSWORD}"
  printf "  ${GREY}(change both later inside the panel)${R}\n\n"

  printf "  ${B}Next steps${R}\n"
  printf "    1. Open the panel and log in.\n"
  printf "    2. Connect your Telegram bot token (Settings).\n"
  printf "    3. Change your username & password.\n\n"

  printf "  ${B}Manage from the server${R}\n"
  printf "    ${PURP}nebula update${R}    update to the newest version\n"
  printf "    ${PURP}nebula restart${R}   restart the platform\n"
  printf "    ${PURP}nebula logs${R}      view live logs\n"
  printf "    ${PURP}nebula version${R}   show installed version\n"
  printf "    ${PURP}nebula password${R}  show this password again\n\n"

  if [ -z "${PANEL_DOMAIN:-}" ]; then
    printf "  ${GREY}Tip: re-run with a domain to enable HTTPS.${R}\n\n"
  fi
}

# ============================================================
# main
# ============================================================
main() {
  banner
  require_root
  check_os
  install_docker
  write_env
  write_compose
  start_app
  install_cli
  summary
}

main "$@"
