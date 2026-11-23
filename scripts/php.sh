#!/usr/bin/env bash

install_php() {
    local v="$PHP_VERSION"
    log "Instalando PHP $v..."

    # Mint 22 / Ubuntu 24.04 já trazem PHP 8.3; versões antigas precisam do PPA.
    if ! apt-cache show "php$v-cli" >/dev/null 2>&1; then
        warn "PHP $v indisponível no APT; adicionando PPA ondrej/php."
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt-get update
    fi

    apt_install \
        "php$v-cli" \
        "php$v-bcmath" \
        "php$v-curl" \
        "php$v-gd" \
        "php$v-intl" \
        "php$v-mbstring" \
        "php$v-mysql" \
        "php$v-sqlite3" \
        "php$v-xml" \
        "php$v-zip"
}
