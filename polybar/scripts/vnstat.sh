#!/bin/bash

INTERFACE="wlan0"

# Run vnstat for 2 seconds to get live traffic
OUTPUT=$(vnstat -tr 2 -i $INTERFACE | grep -E "rx|tx")

RX=$(echo "$OUTPUT" | awk '/rx/ {print $2, $3}')


# Display formatted output in Polybar
echo "⬇ $RX"

