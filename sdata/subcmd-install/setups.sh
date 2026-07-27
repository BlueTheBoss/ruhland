# ━━ Ruhland — Phase 2: System Setup ━━

install_setups() {
    log_header "Phase 2: System Setup"

    # ── User groups ─────────────────────────────────────────────
    if ask "Add user to 'video' group (for brightness)?"; then
        v "Add to video group" "sudo usermod -aG video '$USER'"
    fi
    if ask "Add user to 'input' group (for touchpad gestures)?"; then
        v "Add to input group" "sudo usermod -aG input '$USER'"
    fi

    # ── Fonts ───────────────────────────────────────────────────
    if [[ "$INSTALL_SKIP_FONTS" != "true" ]]; then
        install_google_sans_flex
    fi

    # ── Cursor ──────────────────────────────────────────────────
    log_info "Setting Bibata cursor..."
    mkdir -p "$XDG_CONFIG_HOME/environment.d"
    cat > "$XDG_CONFIG_HOME/environment.d/cursor.conf" << 'EOF'
XCURSOR_THEME=Bibata-Modern-Classic
XCURSOR_SIZE=24
EOF

    # ── GSettings ───────────────────────────────────────────────
    if command_exists gsettings; then
        try gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        try gsettings set org.gnome.desktop.interface font-name 'Google Sans Flex 10'
        try gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10'
    fi

    # ── Wallpaper dir ───────────────────────────────────────────
    mkdir -p "$HOME/Wallpaper" "$HOME/.cache/swww"
    ln -sf "$HOME/.cache/swww/current.txt" "$HOME/Wallpaper/current" 2>/dev/null || true

    log_success "Phase 2 complete"
}
