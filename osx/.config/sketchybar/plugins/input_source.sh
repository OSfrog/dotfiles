#!/usr/bin/env zsh

LAYOUT=$(defaults read "$HOME/Library/Preferences/com.apple.HIToolbox.plist" AppleSelectedInputSources \
    | awk -F' = ' '/"KeyboardLayout Name"/ { gsub(/;$/, "", $2); gsub(/"/, "", $2); print $2; exit }')

case "$LAYOUT" in
    ABC | "U.S.") SHORT_LAYOUT="US" ;;
    Dvorak) SHORT_LAYOUT="DV" ;;
    Swedish) SHORT_LAYOUT="SE" ;;
    *) SHORT_LAYOUT="${LAYOUT:-?}" ;;
esac

sketchybar --set "$NAME" label="$SHORT_LAYOUT"
