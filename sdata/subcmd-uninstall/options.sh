# ━━ Ruhland — Uninstall Options ━━

parse_uninstall_options() {
    local args
    args=$(getopt -o h --long help,force -n "setup uninstall" -- "$@" 2>/dev/null) || {
        echo "Usage: setup uninstall [--force]"
        return 1
    }

    eval set -- "$args"
    while true; do
        case "$1" in
            -h|--help)
                echo "Usage: setup uninstall [--force]"
                echo "  --force    Non-interactive"
                exit 0
                ;;
            --force) ASK_MODE=no ;;
            --) shift; break ;;
        esac
        shift
    done
}
