#!/bin/bash

# Install Docker Engine + NVIDIA Container Toolkit on Ubuntu 20.04 (WSL2)
# Edit: 2025/07/25

sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release

# Docker GPG key addition
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker Engine (free) Installation
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# NVIDIA Container Toolkit
sudo mkdir -p /etc/apt/keyrings
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-docker.gpg

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sed 's|deb |deb [signed-by=/etc/apt/keyrings/nvidia-docker.gpg] |' | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list > /dev/null

sudo apt update
sudo apt install -y nvidia-docker2

echo "Docker and NVIDIA Container Toolkit installation is complete."
echo "Please restart your WSL2 instance manually to apply changes."
