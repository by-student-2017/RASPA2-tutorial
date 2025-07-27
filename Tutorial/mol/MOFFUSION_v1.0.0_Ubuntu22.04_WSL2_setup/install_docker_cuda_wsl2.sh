#!/bin/bash

# Install Docker Engine + NVIDIA Container Toolkit on Ubuntu 22.04 (WSL2)
# Adjusted for Ubuntu 20.04 compatibility
# Edit: 2025/07/25

set -e

sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release

# Docker GPG key addition
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository (force focal for Ubuntu 20.04 compatibility)
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu focal stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker Engine Installation
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# NVIDIA Container Toolkit
sudo mkdir -p /etc/apt/keyrings
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-docker.gpg

# Force ubuntu20.04 distribution for NVIDIA Docker
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu20.04/nvidia-docker.list | \
  sed 's|deb |deb [signed-by=/etc/apt/keyrings/nvidia-docker.gpg] |' | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list > /dev/null

sudo apt update
sudo apt install -y nvidia-docker2

echo "Docker and NVIDIA Container Toolkit installation is complete."
echo "Please restart your WSL2 instance manually to apply changes."
