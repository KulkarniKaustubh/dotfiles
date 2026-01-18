
#!/bin/bash

echo "Running the sync command from source to destination..."
sleep 0.2
rclone sync --exclude "*/.git/" --exclude "*/repos/" --exclude "*/.mypy_cache/" --exclude "*/build/" --exclude "*/install/" --exclude "*/log/" --exclude "*/nltk_data/" --max-size 50M -P --interactive /home/kaustubh/CU\ Boulder/ kulkarnikaustubh2000_CUBoulder:
echo "Running the sync command from destination to source..."
sleep 0.2
rclone sync --exclude "*/.git/" --exclude "*/repos/" --exclude "*/.mypy_cache/" --exclude "*/build/" --exclude "*/install/" --exclude "*/log/" --exclude "*/nltk_data/" --max-size 50M -P --interactive kulkarnikaustubh2000_CUBoulder: /home/kaustubh/CU\ Boulder

echo "Done!"
