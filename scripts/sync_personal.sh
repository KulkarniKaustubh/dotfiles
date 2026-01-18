#!/bin/bash

echo "Running the sync command from source to destination..."
sleep 0.2
rclone sync --max-size 50M -P --interactive /home/kaustubh/Stuff/Personal kulkarnikaustubh2000_Personal:
echo "Running the sync command from destination to source..."
sleep 0.2
rclone sync --max-size 50M -P --interactive kulkarnikaustubh2000_Personal: /home/kaustubh/Stuff/Personal

echo "Done!"
