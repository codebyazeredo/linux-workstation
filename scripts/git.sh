#!/usr/bin/env bash

# Identidade opcional: GIT_NAME="Seu Nome" GIT_EMAIL="voce@email.com" ./install.sh --git
install_git() {
    log "Instalando Git..."

    apt_install git
    git config --global init.defaultBranch main

    if [[ -n "${GIT_NAME:-}" && -n "${GIT_EMAIL:-}" ]]; then
        git config --global user.name "$GIT_NAME"
        git config --global user.email "$GIT_EMAIL"
    else
        warn "Defina a identidade: git config --global user.name/user.email"
    fi
}
