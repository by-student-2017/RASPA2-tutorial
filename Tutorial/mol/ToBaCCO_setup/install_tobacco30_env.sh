#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Display starting message
echo "Starting setup for tobacco_3.0 environment..."

# Install Anaconda (if not already installed)
echo "Downloading Anaconda installer..."
wget https://repo.anaconda.com/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda3
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"

# Create and activate conda environment
echo "Creating conda environment 'tobacco_env' with Python 3.7..."
conda create --name tobacco_env python=3.7 -y
conda activate tobacco_env

# Install required packages
echo "Installing required packages..."
conda install numpy=1.19.1 -y
conda install networkx=2.5 -y
conda install scipy=1.5.2 -y
conda install matplotlib -y

# Clone the GitHub repository
echo "Cloning tobacco_3.0 repository..."
git clone https://github.com/tobacco-mofs/tobacco_3.0.git
cd tobacco_3.0

# Download the topology database
echo "Downloading topology database..."
python tobacco.py --get_topols_db

echo "Setup completed successfully."
