# ━━ Ruhland — Environment & Style ━━

export REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# ── Style ───────────────────────────────────────────────────────
STY_RED='\e[31m'
STY_GREEN='\e[32m'
STY_YELLOW='\e[33m'
STY_BLUE='\e[34m'
STY_PURPLE='\e[35m'
STY_CYAN='\e[36m'
STY_BOLD='\e[1m'
STY_FAINT='\e[2m'
STY_SLANT='\e[3m'
STY_UNDERLINE='\e[4m'
STY_RST='\e[00m'

# ── Paths ───────────────────────────────────────────────────────
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export CONFDIR="$XDG_CONFIG_HOME/ruhland"
export INSTALLED_LISTFILE="$CONFDIR/installed_listfile"
export FIRSTRUN_FILE="$CONFDIR/installed_true"
export BACKUP_DIR="${BACKUP_DIR:-$HOME/ruhland-backup}"

# ── Internal state ──────────────────────────────────────────────
ASK_MODE="${ASK_MODE:-ask}"
SUDO_KEEPALIVE_PID=""
TEMP_FILES_TO_CLEANUP=()
