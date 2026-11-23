#!/usr/bin/env bash

install_docker() {
    log "Instalando Docker Engine, CLI e Compose..."

    if ! has_cmd docker; then
        add_apt_repo docker \
            https://download.docker.com/linux/ubuntu/gpg \
            "https://download.docker.com/linux/ubuntu $(ubuntu_codename) stable"
        apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    fi

    sudo usermod -aG docker "$USER"
    warn "Faça logout/login para usar o docker sem sudo."
}
