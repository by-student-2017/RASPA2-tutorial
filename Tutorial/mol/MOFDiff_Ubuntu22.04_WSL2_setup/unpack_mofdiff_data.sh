#!/bin/bash

echo "Unpacking MOFDiff data files..."

# Create pretrained directory inside MOFDiff if it doesn't exist
mkdir -p ./MOFDiff/pretrained

# Copy pretrained directory contents if not already inside MOFDiff/pretrained
if [ -d "./pretrained" ]; then
  cp -r pretrained/* ./MOFDiff/pretrained/
fi

# Change to pretrained directory
cd ./MOFDiff/pretrained

# List of required files
files=("pretrained.tar.gz" "bb_emb_space.tar.gz" "bw_db.tar.gz" "WC_optimized.tar.gz")

# Check and extract each file
for file in "${files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Error: Required file '$file' not found in current directory."
    exit 1
  fi
  echo "Extracting $file..."
  tar -xzf "$file"
done

# Return to MOFDiff root directory
cd ./../..

echo "All MOFDiff data files unpacked successfully."
