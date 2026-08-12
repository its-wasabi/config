if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    unset SHLVL
    exec niri-session
fi
