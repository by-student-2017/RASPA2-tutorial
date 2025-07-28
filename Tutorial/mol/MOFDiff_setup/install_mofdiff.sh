#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== MOFDiff Installation Script (micromamba) ==="

# Clone MOFDiff repository
if [ ! -d "MOFDiff" ]; then
    git clone https://github.com/microsoft/MOFDiff.git
fi
cd MOFDiff

# Check if micromamba is installed
if ! command -v micromamba &> /dev/null; then
    echo "Error: micromamba is not installed. Please install micromamba first."
    exit 1
fi

# Create environment
echo "Creating 'mofdiff' environment with micromamba..."
micromamba create -n mofdiff -f env.yml -y

# Activate environment
echo "Activating 'mofdiff' environment..."
eval "$(micromamba shell hook --shell bash)"
micromamba activate mofdiff

# Install MOFDiff package
echo "Installing MOFDiff package..."
pip install -e ./

# Extract pretrained model files
echo "Extracting pretrained model files..."
mkdir -p pretrained
tar -xvzf pretrained.tar.gz -C pretrained
tar -xvzf bb_emb_space.tar.gz -C pretrained

echo "=== MOFDiff Installation Completed Successfully ==="
