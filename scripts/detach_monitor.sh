# Run xrandr and capture the output
num_monitors=$(xrandr --listactivemonitors | head -n 1 | awk '{ print $2 - $3 }')

if [ "$num_monitors" -gt 1 ]; then
  xrandr --output eDP --auto --output HDMI-A-0 --auto --primary --mode 1920x1080 --rate 60.00 --scale 1x1 --right-of eDP
else
  xrandr --output HDMI-A-0 --off
fi

nitrogen --restore
