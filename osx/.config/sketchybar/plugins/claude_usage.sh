#!/usr/bin/env zsh

# Shows Claude Code usage limits (5-hour session + weekly) from the OAuth usage API.
# Token comes from the Claude Code keychain item (fallback: ~/.claude/.credentials.json).

CRED=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
if [ -z "$CRED" ] && [ -f "$HOME/.claude/.credentials.json" ]; then
    CRED=$(cat "$HOME/.claude/.credentials.json")
fi

TOKEN=$(echo "$CRED" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)

if [ -z "$TOKEN" ]; then
    sketchybar --set "$NAME" label="–" label.color=0xff939ab7
    return
fi

USAGE_JSON=$(curl -s -m 10 "https://api.anthropic.com/api/oauth/usage" \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "Content-Type: application/json")

FIVE_HOUR=$(echo "$USAGE_JSON" | jq -r '.five_hour.utilization // empty' 2>/dev/null)
SEVEN_DAY=$(echo "$USAGE_JSON" | jq -r '.seven_day.utilization // empty' 2>/dev/null)

if [ -z "$FIVE_HOUR" ] && [ -z "$SEVEN_DAY" ]; then
    sketchybar --set "$NAME" label="–" label.color=0xff939ab7
    return
fi

LABEL=""
MAX=0
if [ -n "$FIVE_HOUR" ]; then
    PCT=$(printf '%.0f' "$FIVE_HOUR")
    LABEL="5h ${PCT}%"
    [ "$PCT" -gt "$MAX" ] && MAX=$PCT
fi
if [ -n "$SEVEN_DAY" ]; then
    PCT=$(printf '%.0f' "$SEVEN_DAY")
    [ -n "$LABEL" ] && LABEL="$LABEL  "
    LABEL="${LABEL}7d ${PCT}%"
    [ "$PCT" -gt "$MAX" ] && MAX=$PCT
fi

COLOR=0xffa6da95
[ "$MAX" -ge 70 ] && COLOR=0xffeed49f
[ "$MAX" -ge 90 ] && COLOR=0xffed8796

sketchybar --set "$NAME" label="$LABEL" label.color=$COLOR
