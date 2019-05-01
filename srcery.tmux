#!/bin/sh
########################################################################
# File name: srcery.tmux
# Project: srcery color scheme for tmux
# Version: 0.0.1
# Copyright:
#
# This is the main file for the tmux color scheme.  This file loads the
# theme files, and run throug the options by the user.
#
########################################################################


SRCERY_TMUX_COLOR_THEME_FILE=themes/srcery.conf
SRCERY_TMUX_STATUS_PATCHED_FILE=themes/srcery_patched.conf
SRCERY_TMUX_STATUS_NO_PATCHED_FILE=themes/srcery_no_patched.conf
SRCERY_TMUX_PATCHED_FONT_OPTION="@srcery_tmux_patched_font"
SRCERY_TMUX_RIGHT_STATUS="@srcery_tmux_right_status"
CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd)"

source "$CURRENT_DIR/scripts/helpers.sh"

__cleanup() {
    unset -v SRCERY_TMUX_COLOR_THEME_FILE SRCERY_TMUX_VERSION
    unset -v SRCERY_TMUX_STATUS_PATCHED_FILE
    unset -v SRCERY_TMUX_STATUS_NO_PATCHED_FILE
    unset -v SRCERY_TMUX_PATCHED_FONT_OPTION
    unset -v CURRENT_DIR
    unset -v patched_font
    unset -f __load __cleanup
    unset -v interpolate
    unset -v current_right_status
    unset -v right_status_option
}

__load() {
    tmux source-file "$CURRENT_DIR/$SRCERY_TMUX_COLOR_THEME_FILE"

    patched_font=$(get_tmux_option "$SRCERY_TMUX_PATCHED_FONT_OPTION")

    if [ "$patched_font" != "1" ]; then
        tmux source-file "$CURRENT_DIR/$SRCERY_TMUX_STATUS_NO_PATCHED_FILE"
    else
        tmux source-file "$CURRENT_DIR/$SRCERY_TMUX_STATUS_PATCHED_FILE"
    fi

    interpolate="#{srecy_righ_status}"
    current_right_status=$(get_tmux_option "status-right")
    right_status_option=$(get_tmux_option "$SRCERY_TMUX_RIGHT_STATUS")

    set_tmux_option "status-right" "${current_right_status//$interpolate/$right_status_option}"
}

__load
__cleanup

# vim: filetype=sh
