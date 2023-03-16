#!/usr/bin/sh

curr_layout=$(hyprctl getoption general:layout | awk '{ if($1 == "str:") { print $2 } }')

if [[ "$curr_layout" == "\"master\"" ]]; then
    # echo "Switching to dwindle layout"
    hyprctl keyword general:layout dwindle
elif [[ "$curr_layout" == "\"dwindle\"" ]]; then
    # echo "Switching to master layout"
    hyprctl keyword general:layout master
fi
