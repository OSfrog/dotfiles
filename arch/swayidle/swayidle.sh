#!/bin/sh
swayidle -w \
	timeout 60 'swaylock -f -c 000000' \
	timeout 180 'hyprctl dispatcher dpms off && swaylock' \
	timeout 600 'systemctl suspend' \
	resume 'hyprctl dispatcher dpms on' \
	before-sleep 'swaylock -f -c 000000'
