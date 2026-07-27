# ━━ Ruhland — Update Options ━━

parse_update_options() {
    local args
    args=$(getopt -o h --long help,force,dry-run -n "setup update" -- "$@" 2>/dev/null) || {
        echo "Usage: setup update [--force] [--dry-run]"
        return 1
    }

    eval set -- "$args"
    while true; do
        case "$1" in
            -h|--help)
                echo "Usage: setup update [--force] [--dry-run]"
                echo "  --force     Non-interactive"
                echo "  --dry-run   Show what would change"
                exit 0
                ;;
            --force) ASK_MODE=no ;;
            --dry-run) UPDATE_DRY_RUN=true ;;
            --) shift; break ;;
        esac
        shift
    done
}
