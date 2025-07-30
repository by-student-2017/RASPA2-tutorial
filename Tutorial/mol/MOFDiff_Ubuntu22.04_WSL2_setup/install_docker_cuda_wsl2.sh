#!/bin/bash

# install_docker_cuda_wsl2.sh
# This script sets up Docker with CUDA support in WSL2

set -e

echo "Updating package lists..."
sudo apt update

echo "Installing required packages..."
sudo apt install -y     ca-certificates     curl     gnupg     lsb-release     software-properties-common

echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |     sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up Docker repository..."
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg]   https://download.docker.com/linux/ubuntu   $(lsb_release -cs) stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Installing NVIDIA Container Toolkit..."
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |     sudo gpg --dearmor -o /etc/apt/keyrings/nvidia-docker.gpg

curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |     sed 's|deb |deb [signed-by=/etc/apt/keyrings/nvidia-docker.gpg] |g' |     sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update
sudo apt install -y nvidia-docker2

echo "Configuring Docker daemon for NVIDIA runtime..."
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF

echo "Restarting Docker service..."
sudo pkill dockerd || true
sudo rm -f /var/run/docker.pid
sudo dockerd &

echo "Verifying GPU access from Docker..."
docker run --rm --gpus all nvidia/cuda:11.3.1-base nvidia-smi

echo "Docker with CUDA support is successfully set up in WSL2."
