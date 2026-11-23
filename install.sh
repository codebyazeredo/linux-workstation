#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.local/state/linux-workstation/install.log"

# A ordem importa: base primeiro; php antes de composer; mise antes de golang.
MODULES=(base git docker vscode browsers php composer python mise golang claude)

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

source "$PROJECT_DIR/config/versions.conf"
source "$PROJECT_DIR/scripts/lib.sh"
for module in "${MODULES[@]}"; do
    source "$PROJECT_DIR/scripts/$module.sh"
done

usage() {
    cat <<EOF
Uso: ./install.sh [--all | --<modulo> ...] [--yes] [--check] [--list]

Módulos: ${MODULES[*]}

  --all     instala tudo (padrão quando nenhum módulo é informado)
  --yes     não pede confirmação
  --check   mostra o que já está instalado
  --list    lista os módulos
EOF
}

declare -A selected=()
assume_yes=false

for option in "$@"; do
    case "$option" in
        --all)
            for module in "${MODULES[@]}"; do selected[$module]=1; done
            ;;
        --yes|-y) assume_yes=true ;;
        --check)  check_tools; exit 0 ;;
        --list)   printf '%s\n' "${MODULES[@]}"; exit 0 ;;
        --help|-h) usage; exit 0 ;;
        --*)
            module_name="${option#--}"
            [[ " ${MODULES[*]} " == *" $module_name "* ]] || { usage; die "Opção desconhecida: $option"; }
            selected[$module_name]=1
            ;;
        *) usage; die "Opção desconhecida: $option" ;;
    esac
done

if [[ ${#selected[@]} -eq 0 ]]; then
    for module in "${MODULES[@]}"; do selected[$module]=1; done
fi

check_system

planned_modules=()
for module in "${MODULES[@]}"; do
    [[ -n "${selected[$module]:-}" ]] && planned_modules+=("$module")
done

log "Serão instalados: ${planned_modules[*]}"
if [[ "$assume_yes" == false ]]; then
    read -r -p "Continuar? [s/N] " answer
    [[ "$answer" =~ ^[sSyY]$ ]] || die "Cancelado."
fi

sudo -v
mkdir -p "$(dirname "$LOG_FILE")"

for module in "${planned_modules[@]}"; do
    log "Módulo: $module"
    "install_$module"
done 2>&1 | tee -a "$LOG_FILE"

log "Concluído. Log em $LOG_FILE"
check_tools
