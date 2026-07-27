# ━━ Ruhland — Update ━━

UPDATE_DRY_RUN="${UPDATE_DRY_RUN:-false}"

update_run() {
    log_header "Ruhland Update"

    # ── Git pull ────────────────────────────────────────────────
    if ask "Pull latest changes from git?"; then
        if git -C "$REPO_ROOT" pull --ff-only 2>/dev/null; then
            log_success "Repository updated"
        else
            log_warning "Git pull failed. Check your remote or local changes."
            ask "Continue anyway?" || exit 0
        end
    fi

    # ── Re-deploy configs ───────────────────────────────────────
    if ask "Re-deploy configs?"; then
        if $UPDATE_DRY_RUN; then
            log_info "Dry run — would re-link:"
            for dir in "$REPO_ROOT/dots/.config"/*/; do
                echo "  $(basename "$dir")"
            done
        else
            backup_clashing_targets
            bash "$REPO_ROOT/deploy.sh"
        fi
    fi

    # ── Check for package updates ───────────────────────────────
    if ask "Check for package updates?"; then
        if command_exists yay; then
            v "Update system" "yay -Syu --noconfirm"
        else
            v "Update system" "sudo pacman -Syu --noconfirm"
        fi
    fi

    echo ""
    log_success "Update complete"
}
