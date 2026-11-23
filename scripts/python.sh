#!/usr/bin/env bash

install_python() {
    log "Instalando Python (APT + venv + pipx)..."

    apt_install python3 python3-pip python3-venv pipx
    pipx ensurepath
}
