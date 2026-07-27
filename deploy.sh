#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.config/ruhland-backups/$(date +%Y%m%d-%H%M%S)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

deploy_configs() {
    local src="$REPO_ROOT/dots/.config"
    for dir in "$src"/*/; do
        local name="$(basename "$dir")"
        local target="$HOME/.config/$name"

        if $DRY_RUN; then
            echo -e "${YELLOW}Would deploy${NC} $name"
            continue
        fi

        if [[ -e "$target" && ! -L "$target" ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -r "$target" "$BACKUP_DIR/"
            echo -e "${YELLOW}Backed up${NC} $name -> $BACKUP_DIR/"
            rm -rf "$target"
        elif [[ -L "$target" ]]; then
            rm -f "$target"
        fi

        ln -sf "$dir" "$target"
        echo -e "${GREEN}Deployed${NC} $name"
    done
}

deploy_settings() {
    local src="$REPO_ROOT/settings"
    local target="$HOME/settings"

    $DRY_RUN && echo -e "${YELLOW}Would deploy${NC} settings -> $target" && return

    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
        rm -rf "$target"
    elif [[ -L "$target" ]]; then
        rm -f "$target"
    fi

    ln -sf "$src" "$target"
    echo -e "${GREEN}Deployed${NC} settings"
}

deploy_quickshell() {
    local src="$REPO_ROOT/quickshell"
    local target="$HOME/.config/quickshell"

    $DRY_RUN && echo -e "${YELLOW}Would deploy${NC} quickshell -> $target" && return

    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$target" "$BACKUP_DIR/"
        echo -e "${YELLOW}Backed up${NC} quickshell -> $BACKUP_DIR/"
        rm -rf "$target"
    elif [[ -L "$target" ]]; then
        rm -f "$target"
    fi

    ln -sf "$src" "$target"
    echo -e "${GREEN}Deployed${NC} quickshell"
}

deploy_fonts_gs() {
    local gs_dir="$HOME/.local/share/fonts/ruhland-google-sans-flex"
    if [[ ! -d "$gs_dir" ]]; then
        mkdir -p "$gs_dir"
        echo -e "${YELLOW}Note:${NC} Google Sans Flex not found. Download manually:"
        echo "  https://github.com/end-4/dots-hyprland/tree/main/sdata/fonts"
    fi
}

echo -e "${CYAN}━━━ Ruhland Deploy ━━━${NC}"
deploy_configs
deploy_quickshell
deploy_settings
deploy_fonts_gs
echo -e "${GREEN}Done.${NC}"
