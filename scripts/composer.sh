#!/usr/bin/env bash

# Segue o procedimento oficial: valida o hash SHA-384 do instalador antes de executá-lo.
install_composer() {
    log "Instalando Composer..."

    has_cmd php || install_php

    if has_cmd composer; then
        return
    fi

    local work_dir expected_hash actual_hash
    work_dir="$(mktemp -d)"

    expected_hash="$(curl -fsSL https://composer.github.io/installer.sig)"
    curl -fsSL https://getcomposer.org/installer -o "$work_dir/composer-setup.php"
    actual_hash="$(php -r "echo hash_file('sha384', '$work_dir/composer-setup.php');")"

    if [[ "$expected_hash" != "$actual_hash" ]]; then
        rm -rf "$work_dir"
        die "Instalador do Composer corrompido: hash não confere."
    fi

    sudo php "$work_dir/composer-setup.php" --quiet --install-dir=/usr/local/bin --filename=composer
    rm -rf "$work_dir"
}
