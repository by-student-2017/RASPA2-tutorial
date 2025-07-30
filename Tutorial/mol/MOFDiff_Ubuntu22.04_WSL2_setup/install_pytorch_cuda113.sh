#!/bin/bash

# This script installs PyTorch with CUDA 11.3 support in a Conda environment.
# Assumes Python 3.10 is already installed and Conda is available.

echo "Installing PyTorch with CUDA 11.3 support..."

# Install PyTorch, torchvision, and torchaudio with CUDA 11.3
pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 -f https://download.pytorch.org/whl/torch_stable.html

echo "Installation complete."
