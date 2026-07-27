#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Wallpaper"
CACHE_DIR="$HOME/.cache/swww"
TRANSITION_TYPE="wipe"
TRANSITION_DURATION=2
TRANSITION_FPS=60

mkdir -p "$CACHE_DIR"

usage() {
    echo "Usage: $(basename "$0") [OPTIONS] [IMAGE]"
    echo "  -r, --random    Random wallpaper"
    echo "  -s, --skip-mc   Set wallpaper, skip matugen color gen"
    echo "  -t, --type TYPE Transition type"
    echo "  -d, --duration N Duration in seconds"
    echo "  -h, --help      This help"
    exit 0
}

set_wallpaper() {
    local img="$1"
    local run_matugen="${2:-true}"
    if [[ -z "$img" || ! -f "$img" ]]; then
        echo "Error: Image not found: $img"
        exit 1
    fi

    local monitors
    monitors=$(hyprctl monitors all -j | jq -r '.[].name' 2>/dev/null || echo "")
    if [[ -z "$monitors" ]]; then
        swww img "$img" --transition-type "$TRANSITION_TYPE" --transition-duration "$TRANSITION_DURATION" --transition-fps "$TRANSITION_FPS"
    else
        for monitor in $monitors; do
            swww img "$img" --outputs "$monitor" --transition-type "$TRANSITION_TYPE" --transition-duration "$TRANSITION_DURATION" --transition-fps "$TRANSITION_FPS"
        done
    fi

    echo "$img" > "$CACHE_DIR/current.txt"
    ln -sf "$img" "$HOME/Wallpaper/current"

    if [[ "$run_matugen" == "true" ]] && command -v matugen &>/dev/null; then
        echo "→ Generating Material You colors..."
        matugen image "$img" >/dev/null 2>&1 || true
        killall -SIGUSR2 kitty 2>/dev/null || true
        # Copy colors to Quickshell theme path
        local qs_colors_dir="$HOME/.local/state/quickshell/user/generated"
        mkdir -p "$qs_colors_dir"
        if [[ -f "$HOME/.config/matugen/colors.json" ]]; then
            cp "$HOME/.config/matugen/colors.json" "$qs_colors_dir/colors.json"
            echo "✓ Quickshell colors updated"
        fi
        echo "✓ Colors applied"
    fi
}

case "${1:-}" in
    -r|--random)
        img=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n1)
        set_wallpaper "$img" true
        ;;
    -s|--skip-mc)
        shift
        set_wallpaper "${1:-}" false
        ;;
    -t|--type) TRANSITION_TYPE="${2:-wipe}"; shift 2; exec "$0" "$@" ;;
    -d|--duration) TRANSITION_DURATION="${2:-2}"; shift 2; exec "$0" "$@" ;;
    -h|--help) usage ;;
    *)
        if [[ -n "${1:-}" && -f "${1:-}" ]]; then
            set_wallpaper "$1" true
        else
            img=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n1)
            set_wallpaper "$img" true
        fi
        ;;
esac
