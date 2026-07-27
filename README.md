<div align="center">
  <img src="https://img.shields.io/badge/Hyprland-📦-1e1e2e?style=flat-square&labelColor=cba6f7" />
  <img src="https://img.shields.io/badge/Shell-Lua%20%7C%20Fish-89b4fa?style=flat-square&labelColor=1e1e2e" />
  <img src="https://img.shields.io/badge/Theme-Catppuccin%20Mocha%20↔%20Material%20You-f5c2e7?style=flat-square&labelColor=1e1e2e" />
</div>

# 🏔️ Ruhland

> A Hyprland rice — modular Lua config, Material You dynamic theming, Waybar bar, Wofi launcher, swaync notifications. Inspired by [end-4/illogical-impulse](https://github.com/end-4/dots-hyprland).

![Screenshot](https://user-images.githubusercontent.com/placeholder/screenshot.png)

## ✨ Features

| | |
|---|---|
| **Dynamic theming** | Material You colors auto-generated from wallpaper via `matugen` — Hyprland, Waybar, Wofi, Swaync, Kitty, Wlogout, GTK all update instantly |
| **Modular Lua config** | Hyprland config split into `env`, `execs`, `general`, `rules`, `colors`, `variables`, `keybinds` — easy to maintain and customize |
| **Dotfiles-safe** | `custom/` overlay directory — your overrides never get overwritten on updates |
| **Material Design 3** | Squircle rounding (power 2.5), 12 custom bezier curves, 13 animation configs, 8 Material animation easing curves |
| **Full font stack** | Google Sans Flex (UI), JetBrainsMono Nerd Font (mono), Material Symbols (icons), Readex Pro (reading), Space Grotesk (display) |
| **On-screen display** | `swayosd` volume/brightness popups |
| **Settings UI** | `Ctrl+Super+S` opens a yad-based settings panel — adjust gaps, rounding, opacity, wallpaper, view keybinds |
| **Screen recording** | Region, fullscreen, with/without audio via `wf-recorder` |
| **Clipboard history** | `Super+V` — `cliphist` + `wofi` |
| **Emoji picker** | `Super+.` — `wofi` emoji picker |
| **Starship prompt** | Transient prompts, Catppuccin Mocha styling, git status, directory icons |

## 🎨 Color Pipeline

```
Wallpaper → matugen → Material You colors
                        ├── Hyprland    (borders, background)
                        ├── Waybar      (full CSS theme)
                        ├── Wofi        (launcher style)
                        ├── Swaync      (notification theme)
                        ├── Kitty       (terminal palette)
                        ├── Wlogout     (button colors)
                        ├── GTK3/GTK4   (desktop theme)
                        └── Hyprlock    (lock screen colors)
```

## 📦 Stack

| Component | Choice |
|---|---|
| **Window Manager** | Hyprland (Lua config) |
| **Status Bar** | Waybar (Catppuccin Mocha) |
| **Launcher** | Wofi (Catppuccin Mocha) |
| **Notifications** | Swaync (notification center) |
| **Wallpaper** | swww (animated transitions) |
| **Lock Screen** | Hyprlock (clock + date + blur) |
| **Power Menu** | Wlogout (6 actions, themed) |
| **Terminal** | Kitty (Catppuccin palette) |
| **Shell** | Fish + Starship (transient) |
| **Audio** | PipeWire + WirePlumber |
| **OSD** | Swayosd (volume/brightness) |
| **Clipboard** | Cliphist + Wofi |
| **Color Gen** | Matugen (Material You) |

## 🚀 Installation

```bash
# 1. Clone
git clone https://github.com/BlueTheBoss/ruhland.git ~/ruhland
cd ~/ruhland

# 2. Full install (ask mode)
./setup install

# 3. Or step by step:
./setup packages          # Install all dependencies
./setup deploy            # Symlink configs to ~/.config
./setup install --skip-deps --skip-setups   # Configs only

# 4. Set a wallpaper (triggers matugen color gen)
~/.config/hypr/hyprland/scripts/wallpaper.sh -r

# 5. Restart Hyprland or:
hyprctl reload
```

### Manual package install

```bash
yay -S waybar swaync swww swayosd yad
```

### Post-install

- **Fonts**: Google Sans Flex must be installed manually — `./setup install` handles it, or grab it from [end-4/google-sans-flex](https://github.com/end-4/google-sans-flex)
- **Cursor**: Bibata-Modern-Classic — `yay -S bibata-cursor-theme`
- **Shell**: `chsh -s /usr/bin/fish` to set Fish as default

## ⌨️ Keybinds

| Key | Action |
|---|---|
| `Super + Return` | Terminal |
| `Super + Space` | Launcher (wofi) |
| `Super + Q` | Close window |
| `Super + F` / `Super + D` | Fullscreen / Maximize |
| `Super + arrows` | Focus direction |
| `Super + Shift + arrows` | Move window |
| `Super + 1-0` | Switch workspace |
| `Super + Shift + 1-0` | Move to workspace |
| `Super + S` | Toggle scratchpad |
| `Print` | Screenshot to clipboard |
| `Ctrl + Print` | Screenshot to file |
| `Super + Shift + S` | Region screenshot |
| `Super + V` | Clipboard history |
| `Super + .` | Emoji picker |
| `Super + L` | Lock screen |
| `Super + Escape` / `Ctrl+Alt+Del` | Power menu |
| `Ctrl + Super + S` | Settings UI |
| `Ctrl + Super + T` | Change wallpaper |

## 📁 Structure

```
ruhland/
├── setup                        # Install/update/uninstall manager
├── deploy.sh                    # Symlink deployer
├── diagnose                     # Health check
├── settings/
│   └── ruhland-settings         # Yad-based settings UI
├── dots/.config/
│   ├── hypr/                    # Hyprland (Lua config)
│   │   ├── hyprland.lua         # Entry point
│   │   └── hyprland/            # Modular config files
│   ├── waybar/                  # Status bar
│   ├── wofi/                    # Launcher
│   ├── swaync/                  # Notifications
│   ├── wlogout/                 # Power menu
│   ├── kitty/                   # Terminal
│   ├── matugen/                 # Dynamic theming templates
│   ├── fish/                    # Shell config
│   ├── starship.toml            # Prompt
│   └── fontconfig/              # Font rendering
└── sdata/                       # Setup library
    ├── lib/                     # Core functions
    └── subcmd-*/                # Subcommand implementations
```

## 🧰 Management

```bash
./setup install                  # Full install (ask mode)
./setup install --force          # Non-interactive
./setup install --skip-deps      # Configs only
./setup update                   # Git pull + redeploy
./setup update --dry-run         # Preview changes
./setup uninstall                # Remove configs
./setup packages                 # Install packages only
./setup deploy                   # Symlink configs
```

## 🤝 Credits

- **[end-4](https://github.com/end-4)** — illogical-impulse / dots-hyprland, the inspiration for this rice's structure, Lua config patterns, and matugen integration
- **[Catppuccin](https://github.com/catppuccin)** — the default color palette
- **[Material You / Material 3](https://m3.material.io/)** — the design system

## 📄 License

MIT
