# ━━ Ruhland — Greeting ━━

install_greeting() {
    clear
    echo -e "${STY_CYAN}${STY_BOLD}"
    echo "  ██████  ██    ██ ██   ██ ██      █████  ███    ██ ██████"
    echo "  ██   ██ ██    ██ ██   ██ ██     ██   ██ ████   ██ ██   ██"
    echo "  ██████  ██    ██ ███████ ██     ███████ ██ ██  ██ ██   ██"
    echo "  ██   ██ ██    ██ ██   ██ ██     ██   ██ ██  ██ ██ ██   ██"
    echo "  ██   ██  ██████  ██   ██ ██████ ██   ██ ██   ████ ██████"
    echo -e "${STY_RST}"
    echo -e "${STY_BOLD}Ruhland — Hyprland Rice Installer${STY_RST}"
    echo -e "${STY_FAINT}Inspired by end-4 / illogical-impulse${STY_RST}"
    echo ""

    if ! is_first_run && [[ "$INSTALL_FIRSTRUN" != "true" ]]; then
        echo -e "${STY_YELLOW}Ruhland is already installed.${STY_RST}"
        echo "Running again will re-apply configs (backups will be made)."
        echo ""
        ask "Continue?" || exit 0
    fi

    echo -e "Installation has ${STY_BOLD}3 phases${STY_RST}:"
    echo "  1. Package installation (dependencies)"
    echo "  2. System setup (services, groups, fonts)"
    echo "  3. Config deployment (symlinks, backups)"
    echo ""

    case "$ASK_MODE" in
        ask|a|A)
            echo -e "${STY_FAINT}You'll be asked before each step.${STY_RST}"
            ;;
        no|n|N)
            echo -e "${STY_YELLOW}Non-interactive mode. Auto-installing.${STY_RST}"
            ;;
    esac

    pause
}
