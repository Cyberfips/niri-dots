#!/bin/bash

# Theme settings
dir="$HOME/.config/rofi/"
theme='power'

# Information
uptime="$(uptime -p | sed -e 's/up //g')"
host="$(hostname)"

# Power Menu Options
shutdown=' Shutdown'
reboot=' Reboot'
lock=' Lock'
suspend=' Suspend'
logout=' Logout'

# Rofi dmenu invocation
rofi_cmd() {
    rofi -dmenu \
        -p "$host" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi \
        -hover-select \
        -me-select-entry "" \
        -kb-cancel Escape \
        -layer overlay \
        -me-accept-entry MousePrimary
}

# Show options to user
chosen="$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd)"

case ${chosen} in
    "$shutdown")
        systemctl poweroff
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$suspend")
        mpc -q pause
        amixer set Master mute
        systemctl suspend
        ;;
    "$logout")
        case "$DESKTOP_SESSION" in
            openbox) openbox --exit ;;
            bspwm) bspc quit ;;
            i3) i3-msg exit ;;
            niri) niri-msg exit ;;
            plasma) qdbus org.kde.ksmserver /KSMServer logout 0 0 0 ;;
        esac
        ;;
    "$lock")
        if [[ -x '/usr/bin/betterlockscreen' ]]; then
            betterlockscreen -l
        elif [[ -x '/usr/bin/i3lock' ]]; then
            i3lock
        elif [[ -x '/usr/bin/hyprlock' ]]; then
            hyprlock &
        fi
        ;;
esac

