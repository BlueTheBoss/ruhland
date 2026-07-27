#!/usr/bin/env bash
set -euo pipefail

wofi --show emoji -p 'Pick an emoji' | head -1 | tr -d '\n' | wl-copy
