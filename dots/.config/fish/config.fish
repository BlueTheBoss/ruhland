if status is-interactive
    starship init fish | source
    enable_transience

    function dynamic_terminal_colors
        if test -f "$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt"
            cat "$HOME/.local/state/quickshell/user/generated/terminal/sequences.txt" | source
        end
    end
    dynamic_terminal_colors

    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --group-directories-first"
    alias tree="eza --tree --icons"
    alias cat="bat --theme=Catppuccin-mocha"
    alias grep="rg"
    alias vim="nvim"
    alias q="exit"
end
