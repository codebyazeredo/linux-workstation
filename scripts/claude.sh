#!/usr/bin/env bash

# Instalador nativo oficial da Anthropic (executa script remoto: revise a URL se preferir).
install_claude() {
    log "Instalando Claude Code..."

    if has_cmd claude; then
        return
    fi

    curl -fsSL https://claude.ai/install.sh | bash
}
