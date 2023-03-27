#!/bin/bash

# Set the URLs for the files to download
URL1="https://github.com/LiuKaoji/YTCore/releases/download/1.0.0/Python.zip"
URL2="https://github.com/LiuKaoji/YTCore/releases/download/1.0.0/ffmpeg.zip"
URL3="https://github.com/LiuKaoji/YTCore/releases/download/1.0.0/env.zip"


# Set the names of the files to download
FILENAME1="Python.zip"
FILENAME2="ffmpeg.zip"
FILENAME3="env.zip"

# Set the name of the directory to extract the files to
EXTRACTDIR="YTCore"

# Create the directory to extract the files to
mkdir -p "$EXTRACTDIR"

# Download the first file from the first URL
echo "Downloading $FILENAME1 from $URL1..."
curl -o "$FILENAME1" -L "$URL1"

# Download the second file from the second URL
echo "Downloading $FILENAME2 from $URL2..."
curl -o "$FILENAME2" -L "$URL2"

# Download the third file from the third URL
echo "Downloading $FILENAME3 from $URL3..."
curl -o "$FILENAME3" -L "$URL3"

# Extract the contents of the first file to the specified directory
echo "Extracting contents of $FILENAME1 to YTCore/Library"
unzip -q -o "$FILENAME1" -d "YTCore/Library"

# Extract the contents of the second file to the specified directory
echo "Extracting contents of $FILENAME2 to /YTCore/Utility/YTVideoMuxer/DLMediaUtils"
unzip -q -o "$FILENAME2" -d "/YTCore/Utility/YTVideoMuxer/DLMediaUtils"

echo "Moving $FILENAME3 to YTCore/Resource/..."
mv -f "$FILENAME3" "YTCore/Resource/"

# Remove the downloaded files
echo "Removing downloaded files..."
rm "$FILENAME1" "$FILENAME2"

echo "Done."

