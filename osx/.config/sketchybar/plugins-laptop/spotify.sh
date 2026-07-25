#!/usr/bin/env zsh

# Spotify JSON / $INFO comes in malformed, line below sanitizes it
SPOTIFY_JSON="$INFO"
STATE_DIR="${TMPDIR:-/tmp}/sketchybar-spotify"
LABEL_FILE="$STATE_DIR/label"
PID_FILE="$STATE_DIR/ticker.pid"
LABEL_VIEWPORT_WIDTH=209

start_ticker() {
    mkdir -p "$STATE_DIR"

    if [[ -r $PID_FILE ]] && kill -0 "$(<"$PID_FILE")" 2>/dev/null; then
        return
    fi

    rm -f "$PID_FILE"
    "$HOME/.config/sketchybar/plugins-laptop/spotify_ticker.sh" &
    print -r -- $! > "$PID_FILE"
}

stop_ticker() {
    local ticker_pid

    mkdir -p "$STATE_DIR"

    if [[ -r $PID_FILE ]]; then
        ticker_pid=$(<"$PID_FILE")
        if [[ $ticker_pid == <-> ]] && kill -0 "$ticker_pid" 2>/dev/null; then
            kill "$ticker_pid"
        fi
    fi

    rm -f "$PID_FILE"
    : > "$LABEL_FILE"
}

label_fits() {
    local result

    result=$(TEXT="$1" MAX_WIDTH="$LABEL_VIEWPORT_WIDTH" osascript -l JavaScript <<'JXA'
ObjC.import('AppKit');
const environment = $.NSProcessInfo.processInfo.environment;
const text = environment.objectForKey('TEXT');
const maxWidth = Number(ObjC.unwrap(environment.objectForKey('MAX_WIDTH')));
const font = $.NSFont.fontWithNameSize('JetBrainsMono Nerd Font', 12.0);
if (!font || font.isNil()) throw new Error('JetBrainsMono Nerd Font is unavailable');
const attributes = $.NSDictionary.dictionaryWithObjectForKey(font, $.NSFontAttributeName);
const result = $(text).sizeWithAttributes(attributes).width <= maxWidth ? 'true\n' : 'false\n';
$.NSFileHandle.fileHandleWithStandardOutput.writeData(
    $(result).dataUsingEncoding($.NSUTF8StringEncoding)
);
JXA
)

    [[ $result == true ]]
}

set_track_label() {
    local metadata="$1"
    local icon_color="$2"

    stop_ticker

    if label_fits "$metadata"; then
        sketchybar --set "$NAME" \
            label="$metadata" \
            label.width=dynamic \
            label.drawing=yes \
            icon.color="$icon_color"
    else
        print -r -- "${metadata}     " > "$LABEL_FILE"
        start_ticker
        sketchybar --set "$NAME" \
            label.width=220 \
            label.drawing=yes \
            icon.color="$icon_color"
    fi
}

update_track() {
    mkdir -p "$STATE_DIR"

    if [[ -z $SPOTIFY_JSON ]]; then
        stop_ticker
        sketchybar --set "$NAME" icon.color=0xffeed49f label.drawing=no
        return
    fi

    PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')
    TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
    ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

    if [ $PLAYER_STATE = "Playing" ]; then
        set_track_label "${TRACK} - ${ARTIST}" 0xffa6da95

    elif [ $PLAYER_STATE = "Paused" ]; then
        set_track_label "${TRACK} - ${ARTIST}" 0xffeed49f
    elif [ $PLAYER_STATE = "Stopped" ]; then
        stop_ticker
        sketchybar --set "$NAME" icon.color=0xffeed49f label.drawing=no
    else
        stop_ticker
        sketchybar --set "$NAME" icon.color=0xffeed49f label.drawing=no
    fi
}

case "$SENDER" in
"mouse.clicked")
    osascript -e 'tell application "Spotify" to playpause'
    ;;
*)
    update_track
    ;;
esac
