#!/usr/bin/env bash

STATE_FILE="/tmp/hyprland_layout_state"

get_val() {
    hyprctl getoption "$1" -j | jq -r '.custom // .int // .float // .bool'
}

if [[ -f "$STATE_FILE" ]]; then
    read -r GAPS_IN < <(jq -r '.gaps_in' "$STATE_FILE")
    read -r GAPS_OUT < <(jq -r '.gaps_out' "$STATE_FILE")
    read -r BORDER < <(jq -r '.border_size' "$STATE_FILE")
    read -r ROUNDING < <(jq -r '.rounding' "$STATE_FILE")
    read -r SHADOW < <(jq -r '.drop_shadow' "$STATE_FILE")
    read -r ACTIVE_OPACITY < <(jq -r '.active_opacity' "$STATE_FILE")
    read -r INACTIVE_OPACITY < <(jq -r '.inactive_opacity' "$STATE_FILE")
    read -r FULLSCREEN_OPACITY < <(jq -r '.fullscreen_opacity' "$STATE_FILE")

    hyprctl keyword general:gaps_in "$GAPS_IN"
    hyprctl keyword general:gaps_out "$GAPS_OUT"
    hyprctl keyword general:border_size "$BORDER"
    hyprctl keyword decoration:rounding "$ROUNDING"
    hyprctl keyword decoration:drop_shadow "$SHADOW"
    hyprctl keyword general:active_opacity "$ACTIVE_OPACITY"
    hyprctl keyword general:inactive_opacity "$INACTIVE_OPACITY"
    hyprctl keyword general:fullscreen_opacity "$FULLSCREEN_OPACITY"

    rm "$STATE_FILE"
else
    # Save current state
    GAPS_IN=$(get_val "general:gaps_in")
    GAPS_OUT=$(get_val "general:gaps_out")
    BORDER=$(get_val "general:border_size")
    ROUNDING=$(get_val "decoration:rounding")
    SHADOW=$(get_val "decoration:drop_shadow")
    ACTIVE_OPACITY=$(get_val "general:active_opacity")
    INACTIVE_OPACITY=$(get_val "general:inactive_opacity")
    FULLSCREEN_OPACITY=$(get_val "general:fullscreen_opacity")

    jq -n \
       --arg gaps_in "$GAPS_IN" \
       --arg gaps_out "$GAPS_OUT" \
       --arg border_size "$BORDER" \
       --arg rounding "$ROUNDING" \
       --arg drop_shadow "$SHADOW" \
       --arg active_opacity "$ACTIVE_OPACITY" \
       --arg inactive_opacity "$INACTIVE_OPACITY" \
       --arg fullscreen_opacity "$FULLSCREEN_OPACITY" \
       '{gaps_in: $gaps_in, gaps_out: $gaps_out, border_size: $border_size, rounding: $rounding, drop_shadow: $drop_shadow, active_opacity: $active_opacity, inactive_opacity: $inactive_opacity, fullscreen_opacity: $fullscreen_opacity}' > "$STATE_FILE"

    # Apply "clean layout"
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:border_size 0
    hyprctl keyword decoration:rounding 0
    hyprctl keyword decoration:drop_shadow false
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
    hyprctl keyword decoration:fullscreen_opacity 1.0
fi
