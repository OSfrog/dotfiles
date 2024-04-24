#!/usr/bin/env zsh

case ${INFO} in
0)
    ICON=""
    ICON_PADDING_RIGHT=21
    ;;
[0-9])
    ICON=""
    ICON_PADDING_RIGHT=12
    ;;
*)
    ICON=""
    ICON_PADDING_RIGHT=6
    ;;
esac

sketchybar --set $NAME icon=$ICON icon.padding_right=$ICON_PADDING_RIGHT label="$INFO%"
# #!/bin/bash
#
# WIDTH=100
#
# volume_change() {
#   source "$HOME/.config/sketchybar/icons.sh"
#   case $INFO in
#     [6-9][0-9]|100) ICON=$VOLUME_100
#     ;;
#     [3-5][0-9]) ICON=$VOLUME_66
#     ;;
#     [1-2][0-9]) ICON=$VOLUME_33
#     ;;
#     [1-9]) ICON=$VOLUME_10
#     ;;
#     0) ICON=$VOLUME_0
#     ;;
#     *) ICON=$VOLUME_100
#   esac
#
#   sketchybar --set volume_icon label=$ICON
#
#   sketchybar --set $NAME slider.percentage=$INFO \
#              --animate tanh 30 --set $NAME slider.width=$WIDTH 
#
#   sleep 2
#
#   # Check wether the volume was changed another time while sleeping
#   FINAL_PERCENTAGE=$(sketchybar --query $NAME | jq -r ".slider.percentage")
#   if [ "$FINAL_PERCENTAGE" -eq "$INFO" ]; then
#     sketchybar --animate tanh 30 --set $NAME slider.width=0
#   fi
# }
#
# mouse_clicked() {
#   osascript -e "set volume output volume $PERCENTAGE"
# }
#
# mouse_entered() {
#   sketchybar --set $NAME slider.knob.drawing=on
# }
#
# mouse_exited() {
#   sketchybar --set $NAME slider.knob.drawing=off
# }
#
# case "$SENDER" in
#   "volume_change") volume_change
#   ;;
#   "mouse.clicked") mouse_clicked
#   ;;
#   "mouse.entered") mouse_entered
#   ;;
#   "mouse.exited") mouse_exited
#   ;;
# esac
