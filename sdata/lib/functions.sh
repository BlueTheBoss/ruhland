# ━━ Ruhland — Core Functions ━━

source "$REPO_ROOT/sdata/lib/environment.sh"

# ── Logging ─────────────────────────────────────────────────────
log_info()    { echo -e "${STY_CYAN}${STY_BOLD}[INFO]${STY_RST}  $*"; }
log_success() { echo -e "${STY_GREEN}${STY_BOLD}[OK]${STY_RST}    $*"; }
log_warning() { echo -e "${STY_YELLOW}${STY_BOLD}[WARN]${STY_RST} $*"; }
log_error()   { echo -e "${STY_RED}${STY_BOLD}[ERROR]${STY_RST} $*"; }
log_header()  { echo -e "\n${STY_PURPLE}${STY_BOLD}━━━ $* ━━━${STY_RST}"; }
log_die()     { log_error "$*"; exit 1; }

# ── Ask / confirm ───────────────────────────────────────────────
ask() {
    local prompt="${1:-Continue?}" default="${2:-y}"
    local yn
    case "$ASK_MODE" in
        no|n|N)  return 0 ;;
        yes|y|Y) return 0 ;;
        ask|a|A)
            read -p "$(echo -e "${STY_FAINT}${prompt} [Y/n] ${STY_RST}")" yn
            [[ "${yn:-y}" =~ ^[Yy]$ ]] && return 0 || return 1
            ;;
        *) return 0 ;;
    esac
}

pause() {
    echo -e "${STY_FAINT}${STY_SLANT}(Press Enter to continue, Ctrl-C to abort)${STY_RST}"
    read -r
}

# ── Command execution ───────────────────────────────────────────
v() {
    local desc="$1" cmd="$2"
    echo -e "${STY_FAINT}→ ${desc}${STY_RST}"
    case "$ASK_MODE" in
        ask|a|A)
            echo -e "${STY_YELLOW}Command:${STY_RST} $cmd"
            local reply
            read -p "$(echo -e "${STY_FAINT}Execute? [Y/n/e] ${STY_RST}")" reply
            case "${reply:-y}" in
                y|Y) x "$desc" "$cmd" ;;
                n|N) log_warning "Skipped: $desc" ;;
                e|E) exit 1 ;;
            esac
            ;;
        *)
            x "$desc" "$cmd"
            ;;
    esac
}

x() {
    local desc="$1" cmd="$2" retry_count=0
    while true; do
        if eval "$cmd" 2>&1 | while IFS= read -r line; do echo -e "${STY_FAINT}  | $line${STY_RST}"; done; then
            [[ $retry_count -eq 0 ]] && log_success "$desc"
            return 0
        else
            local status=$?
            log_error "$desc (exit=$status)"
            if [[ $retry_count -lt 2 ]]; then
                retry_count=$((retry_count + 1))
                echo -e "${STY_YELLOW}Retrying... ($retry_count/2)${STY_RST}"
            else
                local reply
                read -p "$(echo -e "${STY_RED}Failed: $desc. (r)etry / (i)gnore / (e)xit? ${STY_RST}")" reply
                case "${reply:-r}" in
                    r|R) retry_count=0 ;;
                    i|I) log_warning "Ignored: $desc"; return 2 ;;
                    e|E) exit 1 ;;
                esac
            fi
        fi
    done
}

try() {
    "$@" 2>/dev/null || true
}

# ── Sudo keepalive ──────────────────────────────────────────────
sudo_init_keepalive() {
    if [[ -n "$SUDO_KEEPALIVE_PID" ]]; then
        return
    fi
    log_info "Initializing sudo session..."
    sudo -v
    while true; do
        sudo -n true 2>/dev/null
        sleep 60
    done &
    SUDO_KEEPALIVE_PID=$!
    trap 'sudo_stop_keepalive' EXIT INT TERM
    log_success "Sudo keepalive started (PID $SUDO_KEEPALIVE_PID)"
}

sudo_stop_keepalive() {
    if [[ -n "$SUDO_KEEPALIVE_PID" ]]; then
        kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
        wait "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
        SUDO_KEEPALIVE_PID=""
    fi
}

prevent_sudo_or_root() {
    if [[ $EUID -eq 0 ]]; then
        log_die "This script must NOT be run as root."
    fi
}

# ── Backup ──────────────────────────────────────────────────────
backup_config() {
    local target="$1"
    local backup_path="$BACKUP_DIR/$(date +%Y%m%d-%H%M%S)/$target"
    if [[ -e "$HOME/.config/$target" ]]; then
        mkdir -p "$(dirname "$backup_path")"
        cp -r "$HOME/.config/$target" "$backup_path"
        log_info "Backed up $target -> $backup_path"
    fi
}

backup_clashing_targets() {
    local src="$REPO_ROOT/dots/.config"
    if [[ ! -d "$BACKUP_DIR" ]]; then
        ask "Backup existing configs to $BACKUP_DIR?" || return 0
    fi

    for dir in "$src"/*/; do
        local name="$(basename "$dir")"
        local target="$HOME/.config/$name"
        if [[ -e "$target" && ! -L "$target" ]]; then
            backup_config "$name"
        fi
    done
}

# ── File management ─────────────────────────────────────────────
files_differ() {
    local a="$1" b="$2"
    if [[ ! -f "$a" || ! -f "$b" ]]; then return 0; fi
    local size_a size_b
    size_a=$(stat -c%s "$a" 2>/dev/null || stat -f%z "$a" 2>/dev/null)
    size_b=$(stat -c%s "$b" 2>/dev/null || stat -f%z "$b" 2>/dev/null)
    [[ "$size_a" != "$size_b" ]] && return 0
    ! cmp -s "$a" "$b"
}

command_exists() {
    command -v "$1" &>/dev/null
}

require_command() {
    command_exists "$1" || log_die "Required command not found: $1. Install it first."
}

# ── Listfile tracking ───────────────────────────────────────────
listfile_add() {
    local path="$1"
    mkdir -p "$(dirname "$INSTALLED_LISTFILE")"
    echo "$path" >> "$INSTALLED_LISTFILE"
}

listfile_dedup() {
    if [[ -f "$INSTALLED_LISTFILE" ]]; then
        sort -u "$INSTALLED_LISTFILE" -o "$INSTALLED_LISTFILE"
    fi
}

# ── Git ─────────────────────────────────────────────────────────
git_auto_update() {
    if ask "Pull latest changes from git?"; then
        if git -C "$REPO_ROOT" pull --ff-only 2>/dev/null; then
            log_success "Repository updated"
        else
            log_warning "Git pull failed (maybe no remote or local changes)"
        fi
    fi
}

# ── First run ───────────────────────────────────────────────────
is_first_run() {
    [[ ! -f "$FIRSTRUN_FILE" ]]
}

mark_installed() {
    mkdir -p "$(dirname "$FIRSTRUN_FILE")"
    date > "$FIRSTRUN_FILE"
    log_success "Marked as installed"
}
