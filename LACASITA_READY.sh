#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# LACASITA VPS - instalador independiente / SIN KEY
# Repositorio: https://github.com/mplaymod/lacasita-vps
# ============================================================

GITHUB_RAW_BASE="https://raw.githubusercontent.com/mplaymod/lacasita-vps/main"
INSTALL_DIR="/etc/VPS-MX"
PROTO_DIR="$INSTALL_DIR/protocolos"
TOOLS_DIR="$INSTALL_DIR/herramientas"
CTRL_DIR="$INSTALL_DIR/controlador"
TMP_DIR="$INSTALL_DIR/tmp"
WEB_DIR="/var/www/html"

trap 'echo; echo "[!] Instalación interrumpida."; exit 1' INT TERM

log()  { echo -e "\033[1;36m[+]\033[0m $*"; }
warn() { echo -e "\033[1;33m[!]\033[0m $*"; }
die()  { echo -e "\033[1;31m[ERROR]\033[0m $*" >&2; exit 1; }

require_root() {
    [[ "$(id -u)" -eq 0 ]] || die "Debes ejecutar este instalador como root."
}

detect_os() {
    [[ -r /etc/os-release ]] || die "No se pudo detectar el sistema operativo."
    . /etc/os-release
    case "${ID:-}" in
        ubuntu|debian) ;;
        *) warn "Sistema detectado: ${PRETTY_NAME:-desconocido}. Se recomienda Ubuntu/Debian." ;;
    esac
    log "Sistema: ${PRETTY_NAME:-desconocido}"
    log "Arquitectura: $(uname -m)"
}

backup_ssh() {
    if [[ -f /etc/ssh/sshd_config ]]; then
        local backup="/root/sshd_config.backup.$(date +%Y%m%d-%H%M%S)"
        cp -a /etc/ssh/sshd_config "$backup"
        log "Backup SSH: $backup"
    fi
}

install_packages() {
    export DEBIAN_FRONTEND=noninteractive

    log "Actualizando índices APT..."
    apt-get update

    local packages=(
        sudo curl wget ca-certificates
        unzip zip openssl
        python3 python3-pip
        screen cron
        iptables nftables
        lsof nano
        gawk grep bc jq
        socat netcat-openbsd
        net-tools
        figlet
        toilet
        pv
        perl
        apache2
        ufw
    )

    log "Instalando paquetes necesarios..."
    apt-get install -y "${packages[@]}"
}

setup_directories() {
    mkdir -p "$INSTALL_DIR" "$PROTO_DIR" "$TOOLS_DIR" "$CTRL_DIR" "$TMP_DIR"
    mkdir -p "$INSTALL_DIR/passw" "$WEB_DIR"
    echo "LACASITA VPS" > "$INSTALL_DIR/message.txt"
    echo "1.0" > "$INSTALL_DIR/version"
}

download_repo_file() {
    local remote="$1"
    local destination="$2"

    mkdir -p "$(dirname "$destination")"

    if curl -fsSL --retry 3 --connect-timeout 10 \
        "$GITHUB_RAW_BASE/$remote" -o "$destination"; then
        return 0
    fi

    rm -f "$destination"
    return 1
}

install_repo_components() {
    log "Buscando componentes en tu repositorio..."

    # Menú principal
    if download_repo_file "files/menu" "$INSTALL_DIR/menu"; then
        chmod +x "$INSTALL_DIR/menu"
        ln -sfn "$INSTALL_DIR/menu" /usr/bin/menu
        ln -sfn "$INSTALL_DIR/menu" /usr/bin/VPSMX
        log "Menú instalado: comando 'menu'"
    else
        warn "No existe files/menu; se creará un menú básico."
    fi

    # Archivos de protocolos
    local protocols=(
        wireguard.sh
        dropbear.sh
        proxy.sh
        openssh.sh
        openvpn.sh
        ssl.sh
        shadowsocks.sh
        Shadowsocks-libev.sh
        Shadowsocks-R.sh
        v2ray.sh
        slowdns.sh
        C-SSR.sh
        UDPcustom.sh
    )

    for file in "${protocols[@]}"; do
        if download_repo_file "files/$file" "$PROTO_DIR/$file"; then
            chmod +x "$PROTO_DIR/$file"
            log "Protocolo: $file"
        fi
    done

    # Herramientas
    local tools=(
        ADMbot.sh
        PDirect.py
        PGet.py
        POpen.py
        PPriv.py
        PPub.py
        fai2ban.sh
        ports.sh
        speed.py
        squid.sh
        squidpass.sh
        python.py
    )

    for file in "${tools[@]}"; do
        if download_repo_file "files/$file" "$TOOLS_DIR/$file"; then
            chmod +x "$TOOLS_DIR/$file" 2>/dev/null || true
            log "Herramienta: $file"
        fi
    done

    # Utilidades opcionales
    if download_repo_file "util/monitor.sh" "/bin/monitor.sh"; then
        chmod +x /bin/monitor.sh
    fi

    if download_repo_file "util/rebootnb" "/bin/rebootnb"; then
        chmod +x /bin/rebootnb
    fi

    if download_repo_file "util/resetsshdrop" "/bin/resetsshdrop"; then
        chmod +x /bin/resetsshdrop
    fi

    if download_repo_file "util/trans" "/usr/bin/trans"; then
        chmod +x /usr/bin/trans
    fi

    if download_repo_file "web/estilos.css" "$WEB_DIR/estilos.css"; then
        log "CSS web instalado."
    fi
}

configure_apache() {
    if ! command -v apache2 >/dev/null 2>&1; then
        return
    fi

    # No cambia el puerto SSH ni reemplaza sshd_config.
    # Apache queda en su configuración normal del sistema.
    systemctl enable apache2 >/dev/null 2>&1 || true
    systemctl restart apache2 || warn "Apache no pudo reiniciarse."
}

configure_firewall() {
    command -v ufw >/dev/null 2>&1 || return 0

    # Solo abre servicios web comunes; NO activa UFW automáticamente.
    ufw allow 22/tcp >/dev/null 2>&1 || true
    ufw allow 80/tcp >/dev/null 2>&1 || true
    ufw allow 443/tcp >/dev/null 2>&1 || true
}

create_basic_menu() {
    [[ -x "$INSTALL_DIR/menu" ]] && return

    cat > "$INSTALL_DIR/menu" <<'MENU'
#!/usr/bin/env bash
clear
echo "======================================"
echo "        LACASITA VPS - MENU"
echo "======================================"
echo
echo "Instalación base completada."
echo
echo "Protocolos disponibles:"
find /etc/VPS-MX/protocolos -maxdepth 1 -type f -printf '  %f\n' 2>/dev/null | sort
echo
echo "Herramientas disponibles:"
find /etc/VPS-MX/herramientas -maxdepth 1 -type f -printf '  %f\n' 2>/dev/null | sort
echo
MENU
    chmod +x "$INSTALL_DIR/menu"
    ln -sfn "$INSTALL_DIR/menu" /usr/bin/menu
    ln -sfn "$INSTALL_DIR/menu" /usr/bin/VPSMX
}

write_install_info() {
    cat > "$INSTALL_DIR/INSTALL_INFO" <<EOF
LACASITA VPS - instalación independiente
Repositorio: https://github.com/mplaymod/lacasita-vps
Fecha: $(date -Is)
Sistema: ${PRETTY_NAME:-desconocido}
Arquitectura: $(uname -m)
EOF
}

main() {
    require_root
    detect_os

    echo
    echo "=============================================="
    echo " LACASITA VPS - INSTALADOR SIN KEY"
    echo "=============================================="
    echo " Repositorio:"
    echo " $GITHUB_RAW_BASE"
    echo
    echo " Este instalador:"
    echo "  - No solicita KEY"
    echo "  - No valida la IP con terceros"
    echo "  - No envia IP/KEY a Telegram"
    echo "  - No usa Dropbox"
    echo "  - NO reemplaza /etc/ssh/sshd_config"
    echo "  - NO reinicia la VPS automáticamente"
    echo "=============================================="
    echo

    read -r -p "¿Continuar con la instalación? [s/N]: " answer
    [[ "$answer" =~ ^[sS]$ ]] || { echo "Cancelado."; exit 0; }

    backup_ssh
    install_packages
    setup_directories
    install_repo_components
    create_basic_menu
    configure_apache
    configure_firewall
    write_install_info

    echo
    echo "=============================================="
    echo " INSTALACIÓN TERMINADA"
    echo "=============================================="
    echo "Menú: menu"
    echo "Directorio: $INSTALL_DIR"
    echo
    echo "No se reinició la VPS."
    echo "Antes de reiniciar, comprueba SSH con:"
    echo "  sshd -t"
    echo "=============================================="
}

main "$@"
