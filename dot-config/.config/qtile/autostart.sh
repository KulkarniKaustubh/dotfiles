#!/usr/bin/env bash

# Ported over from .xinitrc

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# wallpaper
nitrogen --restore &

# compositor
/usr/bin/picom -b --config $HOME/.config/picom/picom.conf

# disable mouse acceleration
xinput --set-prop "pointer:Logitech G305" 'libinput Accel Profile Enabled' 0, 1

# reduce mouse sensitivity
xinput --set-prop "pointer:Logitech G305" 'libinput Accel Speed' -0.2

# faster key repeat: start repeating after 250ms, then 40 repeats/sec
# (X default is 660ms / 25)
xset r rate 250 40

# nvidia settings
nvidia-settings --load-config-only

# display settings
# Layout (rotation, position, refresh) lives in /etc/X11/xorg.conf MetaModes.
# Don't change modes/rotation with xrandr here: on NVIDIA 620 a live modeset
# touching both heads hangs the display engine. Setting primary is safe.
xrandr --output DP-2 --primary

# emacs server
/usr/bin/emacs --daemon

# start the network manager GUI
/usr/bin/nm-applet &

# start the bluetooth manager GUI
/usr/sbin/blueman-applet &

# start the kdeconnect indicator
/usr/bin/kdeconnect-indicator &

# start the notification daemon
/usr/bin/dunst &

# qtile twm
# /usr/bin/qtile start
