#!/bin/bash

PLUGIN_SHARED_DIR="$HOME/.config/sketchybar/plugins"
FONT_FACE="JetBrainsMono Nerd Font"


keyboard=(
    icon.drawing=off
    label.font="$FONT_FACE:Semibold:14.0"
    script="$PLUGIN_SHARED_DIR/keyboard.sh"
)

sketchybar --add item keyboard right        \
           --set keyboard "${keyboard[@]}"  \
           --add event keyboard_change "AppleSelectedInputSourcesChangedNotification" \
           --subscribe keyboard keyboard_change
