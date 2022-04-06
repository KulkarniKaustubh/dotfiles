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
/usr/bin/picom -b --config $HOME/.config/picom/picom.conf --experimental-backend

# disable mouse acceleration
xinput --set-prop 8 'libinput Accel Profile Enabled' 0, 1

# reduce mouse sensitivity
xinput --set-prop 8 'libinput Accel Speed' -0.2

# nvidia settings
nvidia-settings --load-config-only

# emacs server
/usr/bin/emacs --daemon

# start the network manager GUI
nm-applet &

# start the bluetooth manager GUI
blueman-applet &

# qtile twm
# /usr/bin/qtile start
