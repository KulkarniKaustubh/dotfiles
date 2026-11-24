#!/bin/bash

# Timeout in seconds to detect a quick keypress sequence
TIMEOUT=0.3

# Start with no keys pressed
j_pressed=false

while true; do
  # Wait for a key press
  key=$(xev -event keyboard -root | grep --line-buffered "state")

  if [[ $key =~ "j" ]]; then
    # If 'j' is pressed, mark it as pressed
    j_pressed=true

    # Wait for 'k' within the timeout
    sleep $TIMEOUT

    # Check if 'k' is pressed
    if xev -event keyboard -root | grep --line-buffered "state" | grep -q "k"; then
      # If 'k' is pressed right after 'j', send Escape
      xdotool key Escape
      j_pressed=false  # Reset
    else
      # If 'k' is not pressed, type 'j'
      xdotool key j
      j_pressed=false  # Reset
    fi
  fi

  if [[ $j_pressed == false ]]; then
    # Type the key normally if no special sequence is detected
    xdotool key "$key"
  fi
done
