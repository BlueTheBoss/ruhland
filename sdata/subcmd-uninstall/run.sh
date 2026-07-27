# ━━ Ruhland — Uninstall ━━

uninstall_run() {
    log_header "Ruhland Uninstall"

    ask "This will remove Ruhland configs and settings. Continue?" || exit 0

    # ── Remove symlinks ─────────────────────────────────────────
    if [[ -f "$INSTALLED_LISTFILE" ]]; then
        log_info "Removing installed files (from listfile)..."
        while IFS= read -r path; do
            if [[ -L "$path" ]]; then
                v "Remove symlink: $path" "rm -f '$path'"
            elif [[ -e "$path" ]]; then
                log_warning "Not a symlink, skipping: $path"
            fi
        done < "$INSTALLED_LISTFILE"
    else
        log_warning "No listfile found. Scanning for ruhland symlinks..."
        for dir in hypr waybar wofi swaync wlogout kitty fastfetch cava matugen fontconfig fish starship; do
            local target="$HOME/.config/$dir"
            if [[ -L "$target" ]]; then
                v "Remove: $target" "rm -f '$target'"
            fi
        done
        if [[ -L "$HOME/settings" ]]; then
            v "Remove: $HOME/settings" "rm -f '$HOME/settings'"
        fi
    fi

    # ── Remove installed marker ─────────────────────────────────
    rm -f "$FIRSTRUN_FILE" "$INSTALLED_LISTFILE"
    rmdir "$CONFDIR" 2>/dev/null || true

    echo ""
    log_success "Ruhland configs removed."
    echo "Your original config backups (if any) are at: $BACKUP_DIR"
    echo "To remove packages, run: sudo pacman -Rns waybar swaync swww swayosd"
}
