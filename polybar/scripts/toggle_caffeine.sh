#!/bin/bash

ICON_ON=""  # Caffeine ON icon
ICON_OFF="" # Caffeine OFF icon
STATE_FILE="/tmp/caffeine_state"

# Check if the state file exists, create with OFF icon if not
if [ ! -f "$STATE_FILE" ]; then
    echo "$ICON_OFF" > "$STATE_FILE"
fi

# Read the current state
current_state=$(cat "$STATE_FILE")

# Toggle caffeine state
if [ "$current_state" == "$ICON_ON" ]; then
    # If caffeine is running, stop it and set the state to OFF
    if pgrep -x "caffeine" > /dev/null; then
        pkill -x caffeine
        echo "$ICON_OFF" > "$STATE_FILE"
    else
        # If the process is not running but the state is ON, reset to OFF
        echo "$ICON_OFF" > "$STATE_FILE"
    fi
else
    # If caffeine is not running, start it and set the state to ON
    if ! pgrep -x "caffeine" > /dev/null; then
        caffeine &
    fi
    echo "$ICON_ON" > "$STATE_FILE"
fi