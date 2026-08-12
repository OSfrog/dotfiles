#!/usr/bin/env zsh

# Shows Codex CLI usage limits from the rate_limits snapshots the CLI
# writes into its session logs (~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl).

SESSIONS_DIR="$HOME/.codex/sessions"

window_label() {
    local m=$1
    if ((m % 10080 == 0)); then
        echo "$((m / 1440))d"
    elif ((m % 60 == 0)); then
        echo "$((m / 60))h"
    else
        echo "${m}m"
    fi
}

RL=""
for f in $(ls -t "$SESSIONS_DIR"/*/*/*/rollout-*.jsonl 2>/dev/null | head -10); do
    LINE=$(grep '"rate_limits"' "$f" 2>/dev/null | tail -n 1)
    [ -z "$LINE" ] && continue
    RL=$(echo "$LINE" | jq -c '[.. | objects | select(has("primary"))] | first // empty' 2>/dev/null)
    [ -n "$RL" ] && break
done

if [ -z "$RL" ]; then
    sketchybar --set "$NAME" label="–" label.color=0xff939ab7
    return
fi

LABEL=""
MAX=0
for key in primary secondary; do
    PCT=$(echo "$RL" | jq -r ".${key}.used_percent // empty")
    [ -z "$PCT" ] && continue
    MINS=$(echo "$RL" | jq -r ".${key}.window_minutes // 0")
    PCT=$(printf '%.0f' "$PCT")
    [ -n "$LABEL" ] && LABEL="$LABEL  "
    LABEL="${LABEL}$(window_label $MINS) ${PCT}%"
    [ "$PCT" -gt "$MAX" ] && MAX=$PCT
done

COLOR=0xffa6da95
[ "$MAX" -ge 70 ] && COLOR=0xffeed49f
[ "$MAX" -ge 90 ] && COLOR=0xffed8796

sketchybar --set "$NAME" label="$LABEL" label.color=$COLOR
