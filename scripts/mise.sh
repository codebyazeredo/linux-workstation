#!/usr/bin/env bash

install_mise() {
    log "Instalando mise..."

    if ! has_cmd mise; then
        add_apt_repo mise-archive-keyring \
            https://mise.jdx.dev/gpg-key.pub \
            "https://mise.jdx.dev/deb stable main"
        apt_install mise
    fi

    if ! grep -q 'mise activate' "$HOME/.bashrc"; then
        echo 'eval "$(mise activate bash)"' >> "$HOME/.bashrc"
    fi
}
