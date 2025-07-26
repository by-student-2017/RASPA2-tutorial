#!/bin/bash

# Step 1: Download Miniconda installer
echo "Downloading Miniconda installer..."
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/Miniconda3-latest.sh

# Step 2: Run the installer silently
echo "Installing Miniconda to $HOME/miniconda3..."
bash ~/Miniconda3-latest.sh -b -p $HOME/miniconda3

# Step 3: Initialize conda
echo "Initializing conda..."
$HOME/miniconda3/bin/conda init bash

# Step 4: Add conda to PATH and source conda.sh in .bashrc
echo "Updating .bashrc..."
echo 'export PATH="$HOME/miniconda3/bin:$PATH"' >> ~/.bashrc
echo 'source "$HOME/miniconda3/etc/profile.d/conda.sh"' >> ~/.bashrc

echo "Miniconda installation and initialization complete."
echo "Please restart your terminal or run 'source ~/.bashrc' to apply changes."
