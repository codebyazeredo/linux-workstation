#!/usr/bin/env bash

install_golang() {
    log "Instalando Go $GO_VERSION via mise..."

    has_cmd mise || install_mise
    mise use --global "go@$GO_VERSION"
}
