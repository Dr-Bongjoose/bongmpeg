
#!/bin/bash

#check if anyfiles were provided as arguments
if [ $# -eq 0 ]; then
	echo "No files provided!"
	echo "Usage: ./convert_for_resolve.sh video1.mp4 video2.mkv ..."
	exit 1
fi

#loop through every file provided
for file in "$@"; do
	#get the filename without the extension
	filename="${file%.*}"

	echo "--- 🎬 Starting conversion for: $file ---"


	# Run the ffmpeg command using the variables.
	ffmpeg -i "$file" -c:v dnxhd -profile:v dnxhr_hq -c:a pcm_s16le "${filename}_resolve.mov"

 	echo "--- ✅ Finished. Output is ${filename}_resolve.mov ---"
	echo "" # Add a blank line for readability.
done

echo "All conversions complete!"
