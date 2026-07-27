#!/usr/bin/env bash
set -euo pipefail

OUTDIR="$HOME/Videos"
mkdir -p "$OUTDIR"
FILE="$OUTDIR/Recording_$(date '+%Y-%m-%d_%H.%M.%S').mp4"

case "${1:-}" in
    region)
        wf-recorder -g "$(slurp)" -f "$FILE" &
        notify-send "Recording" "Region recording started" -a "wf-recorder"
        ;;
    fullscreen)
        wf-recorder -f "$FILE" &
        notify-send "Recording" "Fullscreen recording started" -a "wf-recorder"
        ;;
    fullscreen-audio)
        wf-recorder -a -f "$FILE" &
        notify-send "Recording" "Fullscreen recording (with audio) started" -a "wf-recorder"
        ;;
    stop)
        pkill -SIGINT wf-recorder
        notify-send "Recording" "Recording saved" -a "wf-recorder"
        ;;
    *)
        echo "Usage: $0 {region|fullscreen|fullscreen-audio|stop}"
        ;;
esac
