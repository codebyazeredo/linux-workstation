#!/usr/bin/env bash

install_base() {
    log "Instalando ferramentas básicas..."

    sudo apt-get update
    apt_install \
        curl \
        wget \
        unzip \
        zip \
        build-essential \
        ca-certificates \
        gnupg \
        software-properties-common \
        htop \
        tree \
        jq \
        ripgrep
}
