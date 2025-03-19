#!/bin/bash

ICON_ON=""
  # Caffeine ON icon
ICON_OFF="" # Caffeine OFF icon
STATE_FILE="/tmp/caffeine_state"

# Check if state file exists, create with OFF icon if not
if [ ! -f "$STATE_FILE" ]; then
    echo "$ICON_OFF" > "$STATE_FILE"
fi

# Output the current state
cat "$STATE_FILE"

