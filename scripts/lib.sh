#!/usr/bin/env bash

KEYRINGS_DIR="/etc/apt/keyrings"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

apt_install() { sudo apt-get install -y "$@"; }

# Base Ubuntu do Mint (ex.: noble), usada pelos repositórios oficiais.
ubuntu_codename() {
    ( . /etc/os-release; echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}" )
}

check_system() {
    local distro_id
    distro_id="$(. /etc/os-release; echo "$ID")"

    case "$distro_id" in
        linuxmint|ubuntu) ;;
        *) die "Sistema não suportado: $distro_id (use Linux Mint ou Ubuntu)." ;;
    esac

    [[ $EUID -ne 0 ]] || die "Não execute como root; o script usa sudo quando necessário."
}

# Uso: add_apt_repo <nome> <url-da-chave> "<uri> <suite> <componentes>"
# Reexecutar sobrescreve os mesmos arquivos, então é idempotente.
add_apt_repo() {
    local name="$1" key_url="$2" source_line="$3"

    sudo install -d -m 0755 "$KEYRINGS_DIR"
    curl -fsSL "$key_url" | sudo gpg --dearmor --yes -o "$KEYRINGS_DIR/$name.gpg"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRINGS_DIR/$name.gpg] $source_line" \
        | sudo tee "/etc/apt/sources.list.d/$name.list" >/dev/null
    sudo apt-get update
}

check_tools() {
    local tool

    log "Ferramentas:"
    for tool in git docker code google-chrome brave-browser php composer python3 pipx mise go claude; do
        if has_cmd "$tool"; then
            printf '  ok  %s\n' "$tool"
        else
            printf '  --  %s (ausente)\n' "$tool"
        fi
    done
}
