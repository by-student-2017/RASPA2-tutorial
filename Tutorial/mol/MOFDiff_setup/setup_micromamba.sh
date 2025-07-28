#!/bin/bash

# setup_micromamba.sh
# This script sets up micromamba on Ubuntu 20.04 with CUDA 11.3

set -e

# Define micromamba installation directory
export MAMBA_ROOT_PREFIX=$HOME/micromamba
export PATH=$MAMBA_ROOT_PREFIX/bin:$PATH

# Update and install required packages
sudo apt update && sudo apt install -y curl bzip2 tar

# Create installation directory
mkdir -p $MAMBA_ROOT_PREFIX/bin

# Download and install micromamba
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj -C $MAMBA_ROOT_PREFIX/bin/ --strip-components=1 bin/micromamba

# Initialize shell
micromamba shell init -s bash --root-prefix $MAMBA_ROOT_PREFIX

# Append to .bashrc safely
echo 'export MAMBA_ROOT_PREFIX=$HOME/micromamba' >> ~/.bashrc
echo 'export PATH=$MAMBA_ROOT_PREFIX/bin:$PATH' >> ~/.bashrc

export MAMBA_ROOT_PREFIX=$HOME/micromamba
export PATH=$MAMBA_ROOT_PREFIX/bin:$PATH
eval "$(micromamba shell hook --shell bash)"

# Apply shell changes for current session
eval "$(micromamba shell hook --shell bash)"

# Create environment
micromamba create -y -n mofdiff-env python=3.9
micromamba clean -a -y

echo "Micromamba installation completed successfully."
echo "To use the environment later, run: micromamba activate mofdiff-env"
