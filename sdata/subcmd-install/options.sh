# ━━ Ruhland — Install Options ━━

INSTALL_SKIP_DEPS=false
INSTALL_SKIP_SETUPS=false
INSTALL_SKIP_FILES=false
INSTALL_SKIP_FONTS=false
INSTALL_FORCE=false
INSTALL_FIRSTRUN=false

parse_install_options() {
    local args
    args=$(getopt -o hf --long help,force,firstrun,skip-deps,skip-setups,skip-files,skip-fonts,ask,yes -n "setup install" -- "$@" 2>/dev/null) || {
        echo "Usage: setup install [OPTIONS]"
        echo "  --force        Non-interactive mode"
        echo "  --firstrun     Force first-run behavior"
        echo "  --skip-deps    Skip package installation"
        echo "  --skip-setups  Skip system setup"
        echo "  --skip-files   Skip config deployment"
        echo "  --skip-fonts   Skip font installation"
        echo "  --ask          Ask before every command"
        echo "  --yes          Auto-yes (non-interactive)"
        return 1
    }

    eval set -- "$args"
    while true; do
        case "$1" in
            -h|--help)
                echo "Usage: setup install [OPTIONS]"
                echo "  --force        Non-interactive mode"
                echo "  --firstrun     Force first-run behavior"
                echo "  --skip-deps    Skip package installation"
                echo "  --skip-setups  Skip system setup"
                echo "  --skip-files   Skip config deployment"
                echo "  --skip-fonts   Skip font installation"
                echo "  --ask          Ask before every command"
                echo "  --yes          Auto-yes"
                exit 0
                ;;
            --force) INSTALL_FORCE=true; ASK_MODE=no ;;
            --firstrun) INSTALL_FIRSTRUN=true ;;
            --skip-deps) INSTALL_SKIP_DEPS=true ;;
            --skip-setups) INSTALL_SKIP_SETUPS=true ;;
            --skip-files) INSTALL_SKIP_FILES=true ;;
            --skip-fonts) INSTALL_SKIP_FONTS=true ;;
            --ask) ASK_MODE=ask ;;
            --yes) ASK_MODE=no ;;
            --) shift; break ;;
        esac
        shift
    done
}
