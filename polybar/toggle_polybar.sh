#!/bin/bash

if pgrep -x "polybar" > /dev/null; then
    killall polybar
else
    ~/.config/polybar/launch_polybar.sh
fi
