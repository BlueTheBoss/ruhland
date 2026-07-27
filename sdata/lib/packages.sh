# ━━ Ruhland — Package Installation ━━

source "$REPO_ROOT/sdata/lib/functions.sh"

# ── Package groups ──────────────────────────────────────────────
# Each group: name="description|pkg1 pkg2 ..."
RICE_PKG_GROUPS=(
    "base|Core rice tools|waybar swaync swww wofi"
    "media|Audio, video, brightness|pipewire wireplumber pipewire-pulse wireplumber playerctl brightnessctl pavucontrol"
    "screenshot|Screenshot & recording|grim slurp hyprshot swappy wf-recorder"
    "clipboard|Clipboard management|cliphist wl-clipboard"
    "fonts|Font stack|ttf-jetbrains-mono-nerd ttf-material-symbols-variable ttf-readex-pro otf-space-grotesk noto-fonts-emoji"
    "shell|Shell experience|fish starship eza bat ripgrep fd"
    "misc|Utility tools|jq polkit-kde-agent gnome-keyring bluez-utils network-manager-applet"
    "theming|Dynamic colors & UI|matugen-bin swayosd yad bibata-cursor-theme"
)

RICE_PKG_META=(
    "quickshell-git|Quickshell shell (if you want it)|quickshell-git"
)

install_package_group() {
    local group_name="$1"
    local skip_missing="${2:-false}"
    local group_info=""

    for entry in "${RICE_PKG_GROUPS[@]}"; do
        local name="${entry%%|*}"
        [[ "$name" != "$group_name" ]] && continue
        group_info="${entry#*|}"
        break
    done

    [[ -z "$group_info" ]] && log_warning "Unknown package group: $group_name" && return 1

    local description="${group_info%%|*}"
    local pkgs="${group_info#*|}"

    log_header "Installing: $description"
    if ! ask "Install $description packages?"; then
        log_info "Skipping $description"
        return 0
    fi

    # Try pacman first
    local pacman_pkgs=()
    local missing_pkgs=()
    for pkg in $pkgs; do
        if pacman -Si "$pkg" &>/dev/null 2>&1; then
            pacman_pkgs+=("$pkg")
        else
            missing_pkgs+=("$pkg")
        fi
    done

    if [[ ${#pacman_pkgs[@]} -gt 0 ]]; then
        v "Install ${pacman_pkgs[*]}" "sudo pacman -S --noconfirm --needed ${pacman_pkgs[*]}"
    fi

    # Install AUR packages via yay
    if [[ ${#missing_pkgs[@]} -gt 0 ]]; then
        if command_exists yay; then
            v "Install from AUR: ${missing_pkgs[*]}" "yay -S --noconfirm --needed ${missing_pkgs[*]}"
        elif command_exists paru; then
            v "Install from AUR: ${missing_pkgs[*]}" "paru -S --noconfirm --needed ${missing_pkgs[*]}"
        else
            log_warning "AUR helper not found. Install manually: ${missing_pkgs[*]}"
            log_info "  yay -S ${missing_pkgs[*]}"
        fi
    fi

    log_success "$description installed"
}

install_all_packages() {
    log_header "Package Installation"

    # Ensure yay exists
    if ! command_exists yay && ! command_exists paru; then
        log_info "Installing yay (AUR helper)..."
        local tmpdir
        tmpdir=$(mktemp -d)
        v "Clone yay" "git clone https://aur.archlinux.org/yay.git '$tmpdir/yay'"
        v "Build yay" "cd '$tmpdir/yay' && makepkg -si --noconfirm"
        rm -rf "$tmpdir"
    fi

    for entry in "${RICE_PKG_GROUPS[@]}"; do
        local name="${entry%%|*}"
        install_package_group "$name"
    done
}

install_google_sans_flex() {
    if fc-list | grep -qi "Google Sans Flex" 2>/dev/null; then
        log_success "Google Sans Flex already installed"
        return 0
    fi

    log_header "Google Sans Flex"
    if ! ask "Install Google Sans Flex font?"; then
        return 0
    fi

    local font_dir="$XDG_DATA_HOME/fonts/ruhland-google-sans-flex"
    local cache_dir="$REPO_ROOT/.cache/google-sans-flex"

    if git clone --depth 1 "https://github.com/end-4/google-sans-flex.git" "$cache_dir" 2>/dev/null; then
        mkdir -p "$font_dir"
        find "$cache_dir" -name '*.ttf' -o -name '*.otf' | while read -r f; do
            cp "$f" "$font_dir/"
        done
        fc-cache -fv "$font_dir" 2>/dev/null || true
        rm -rf "$cache_dir"
        log_success "Google Sans Flex installed to $font_dir"
    else
        log_warning "Failed to clone Google Sans Flex. Install manually:"
        echo "  https://github.com/end-4/google-sans-flex"
    fi
}

install_bibata_cursor() {
    if [[ -d "/usr/share/icons/Bibata-Modern-Classic" ]] || [[ -d "$HOME/.local/share/icons/Bibata-Modern-Classic" ]] || [[ -d "/usr/local/share/icons/Bibata-Modern-Classic" ]]; then
        log_success "Bibata cursor already installed"
        return 0
    fi

    if command_exists yay; then
        install_package_group "theming"
        return
    fi

    log_header "Bibata Cursor"
    if ! ask "Install Bibata Modern Classic cursor?"; then
        return 0
    fi

    local tmpdir
    tmpdir=$(mktemp -d)
    v "Download Bibata" "wget -q 'https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Classic.tar.xz' -O '$tmpdir/bibata.tar.xz'"
    v "Extract" "mkdir -p '$tmpdir/bibata' && tar -xf '$tmpdir/bibata.tar.xz' -C '$tmpdir/bibata'"
    v "Install" "sudo cp -r '$tmpdir/bibata'/* /usr/local/share/icons/"
    rm -rf "$tmpdir"
    log_success "Bibata cursor installed"
}
