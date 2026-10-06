if status is-interactive
    # Enable Vi key bindings
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    # No greeting
    set fish_greeting

    # Run uwufetch on startup (not as root, and only in top-level shells)
    if test (id -u) -ne 0; and test "$SHLVL" -lt 3
        if command -v uwufetch &>/dev/null
            uwufetch
        end
    end

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # Apply terminal color sequences (Material You from wallpaper)
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear scrollback properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    if command -v eza &>/dev/null
        alias ls 'eza --icons=auto -lh'
    end
end
