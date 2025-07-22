#!/bin/bash
# A script to batch convert video files to DNxHR for DaVinci Resolve.
# It uses GPU-accelerated decoding and moves the original to a folder.

# Define the name of the folder where original files will be moved.
ARCHIVE_DIR="originals"

# Check if any files were provided as arguments.
if [ $# -eq 0 ]; then
    echo "No files provided!"
    echo "Usage: ./convert_for_resolve.sh video1.mp4 video2.mkv ..."
    exit 1
fi

# Create the archive directory if it doesn't exist.
# The -p flag prevents errors if the directory already exists.
mkdir -p "$ARCHIVE_DIR"
echo "Originals will be moved to the '$ARCHIVE_DIR' folder."
echo ""

# Loop through every file provided to the script.
for file in "$@"; do
    # Get the filename without the extension (e.g., "my_video" from "my_video.mp4").
    filename="${file%.*}"

    echo "--- 🎬 Starting conversion for: $file ---"

    # Run the ffmpeg command using the variables.
    # -hwaccel cuda: Tells ffmpeg to use the NVIDIA GPU for decoding.
    # This offloads the decoding work from the CPU, speeding up the process.
    ffmpeg -hwaccel cuda -i "$file" -c:v dnxhd -profile:v dnxhr_hq -c:a pcm_s16le "${filename}_resolve.mov"

    # Check if the last command (ffmpeg) was successful (exit code 0).
    if [ $? -eq 0 ]; then
        echo "--- ✅ Finished. Output is ${filename}_resolve.mov ---"
        # If successful, move the original file to the archive directory.
        mv "$file" "$ARCHIVE_DIR/"
        echo "--- 📁 Moved original file '$file' to '$ARCHIVE_DIR/' ---"
    else
        # If ffmpeg fails, print an error and do not move the file.
        echo "--- ❌ Error: ffmpeg failed to convert '$file'. Original file not moved. ---"
    fi

    echo "" # Add a blank line for readability.
done

echo "All conversions complete!"
