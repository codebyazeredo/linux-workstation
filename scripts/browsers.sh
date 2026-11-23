#!/usr/bin/env bash

install_browsers() {
    log "Instalando Google Chrome e Brave..."

    if ! has_cmd google-chrome; then
        add_apt_repo google-chrome \
            https://dl.google.com/linux/linux_signing_key.pub \
            "https://dl.google.com/linux/chrome/deb/ stable main"
        apt_install google-chrome-stable
    fi

    if ! has_cmd brave-browser; then
        add_apt_repo brave-browser \
            https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
            "https://brave-browser-apt-release.s3.brave.com/ stable main"
        apt_install brave-browser
    fi
}
