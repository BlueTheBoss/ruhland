# ━━ Ruhland — Phase 3: Config Deployment ━━

install_files() {
    log_header "Phase 3: Config Deployment"

    # ── Backup existing configs ─────────────────────────────────
    backup_clashing_targets

    # ── Deploy settings ─────────────────────────────────────────
    if ask "Deploy settings UI to ~/settings?"; then
        local settings_src="$REPO_ROOT/settings"
        local settings_target="$HOME/settings"
        if [[ -e "$settings_target" && ! -L "$settings_target" ]]; then
            cp -r "$settings_target" "$BACKUP_DIR/$(date +%Y%m%d-%H%M%S)/settings"
            rm -rf "$settings_target"
        elif [[ -L "$settings_target" ]]; then
            rm -f "$settings_target"
        fi
        ln -sf "$settings_src" "$settings_target"
        listfile_add "$settings_target"
        log_success "Settings deployed"
    fi

    # ── Deploy configs ──────────────────────────────────────────
    if ask "Deploy dotfiles (symlink ~/.config/* to ruhland)?"; then
        local src="$REPO_ROOT/dots/.config"
        for dir in "$src"/*/; do
            local name="$(basename "$dir")"
            local target="$HOME/.config/$name"

            if [[ -e "$target" && ! -L "$target" ]]; then
                rm -rf "$target"
            elif [[ -L "$target" ]]; then
                rm -f "$target"
            fi

            ln -sf "$dir" "$target"
            listfile_add "$target"
            log_success "  Linked $name"
        done
    fi

    # ── Deploy quickshell ───────────────────────────────────────
    if ask "Deploy Quickshell config?"; then
        local qs_src="$REPO_ROOT/quickshell"
        local qs_target="$HOME/.config/quickshell"
        if [[ -e "$qs_target" && ! -L "$qs_target" ]]; then
            cp -r "$qs_target" "$BACKUP_DIR/$(date +%Y%m%d-%H%M%S)/quickshell"
            rm -rf "$qs_target"
        elif [[ -L "$qs_target" ]]; then
            rm -f "$qs_target"
        fi
        ln -sf "$qs_src" "$qs_target"
        listfile_add "$qs_target"
        log_success "  Linked quickshell"
    fi

    # ── Matugen first run ───────────────────────────────────────
    if [[ -f "$HOME/Wallpaper/current" ]] || [[ -d "$HOME/Wallpaper" && "$(ls -A "$HOME/Wallpaper" 2>/dev/null)" ]]; then
        local first_wall
        first_wall=$(find "$HOME/Wallpaper" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) 2>/dev/null | head -1)
        if [[ -n "$first_wall" ]] && command_exists matugen && ask "Generate Material You colors from wallpaper?"; then
            v "Generate colors" "matugen image '$first_wall'"
        fi
    fi

    # ── Mark installed ──────────────────────────────────────────
    mark_installed
    listfile_dedup

    # ── Done ────────────────────────────────────────────────────
    log_success "Phase 3 complete"
    echo ""
    echo -e "${STY_GREEN}${STY_BOLD}Ruhland installed!${STY_RST}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart Hyprland or run: hyprctl reload"
    echo "  2. Set a wallpaper: $HOME/.config/hypr/hyprland/scripts/wallpaper.sh -r"
    echo "  3. Open settings: Ctrl+Super+S  or  ~/settings/ruhland-settings"
    echo "  4. Lock screen: Super+L"
    echo ""
}
