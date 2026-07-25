#!/usr/bin/env zsh

STATE_DIR="${TMPDIR:-/tmp}/sketchybar-spotify"
LABEL_FILE="$STATE_DIR/label"
PID_FILE="$STATE_DIR/ticker.pid"

while true; do
    [[ -r $LABEL_FILE ]] || break

    LABEL=$(<"$LABEL_FILE")
    [[ -n $LABEL ]] || break

    sketchybar --set spotify label="$LABEL"
    LABEL="${LABEL[2,-1]}${LABEL[1]}"
    print -r -- "$LABEL" > "$LABEL_FILE"
    sleep 0.2
done

rm -f "$PID_FILE"
