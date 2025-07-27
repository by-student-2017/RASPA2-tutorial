#!/bin/bash

# === Step 1: Download and install Miniconda ===
echo "Downloading Miniconda installer..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3-latest.sh

echo "Installing Miniconda to $HOME/miniconda3..."
bash Miniconda3-latest.sh -b -p $HOME/miniconda3

# === Step 2: Initialize conda ===
echo "Initializing conda..."
echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
echo 'source "$HOME/miniconda3/etc/profile.d/conda.sh"' >> ~/.bashrc
# Reload bashrc (source is invalid in this script because it is a subshell)
# Initialize conda directly instead
export PATH="$HOME/miniconda3/bin:$PATH"
source "$HOME/miniconda3/etc/profile.d/conda.sh"

# === Step 3: Accept Terms of Service for Anaconda channels ===
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

echo "Miniconda setup complete."
