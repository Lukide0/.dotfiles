#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar main &

# Secondary monitor
if [[ "$( xrandr -q | grep -w connected | wc -l )" -ne "1" ]]; then
    # Get monitor name
    monitor="$( xrandr -q | grep -w connected | tail -n 1 | awk '{print $1}' )"
    
    SECONDARY_MONITOR="$monitor" polybar secondary_bar &
fi
