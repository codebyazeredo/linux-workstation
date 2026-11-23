#!/usr/bin/env bash

install_vscode() {
    log "Instalando VS Code..."

    if has_cmd code; then
        return
    fi

    # Evita que o pacote crie um segundo arquivo de repositório (aviso de duplicidade no apt).
    echo "code code/add-microsoft-repo boolean false" | sudo debconf-set-selections

    add_apt_repo vscode \
        https://packages.microsoft.com/keys/microsoft.asc \
        "https://packages.microsoft.com/repos/code stable main"
    apt_install code
}
