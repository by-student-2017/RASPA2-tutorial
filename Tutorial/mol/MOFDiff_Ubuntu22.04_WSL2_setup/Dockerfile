
# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    sudo \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip \
    ffmpeg \
    libopenh264-6 \
    && ln -s /usr/lib/x86_64-linux-gnu/libopenh264.so.6 /usr/lib/x86_64-linux-gnu/libopenh264.so.5 \
    && apt-get clean

# Set python3.10 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install Python dependencies
RUN pip install numpy==1.26.4 \
    pymatgen==2023.11.12 \
    opencv-python==4.9.0.80 \
    "huggingface-hub>=0.16.4,<1.0.0" \
    tokenizers==0.21.2 \
    transformers==4.22.2 \
    ffmpeg-python==0.2.0

# Install PyTorch with CUDA 11.3
RUN pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

# Clone MOFDiff repository
RUN git clone https://github.com/microsoft/MOFDiff.git /opt/MOFDiff

# Set working directory
WORKDIR /opt/MOFDiff

# Default command
CMD ["/bin/bash"]
