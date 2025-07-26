# Use NVIDIA CUDA base image compatible with RTX 3070
FROM docker.io/nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/opt/conda/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    ca-certificates \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    /opt/conda/bin/conda clean -afy

# Accept Anaconda Terms of Service
RUN /opt/conda/bin/conda init bash && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    /opt/conda/bin/conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Create and activate conda environment
RUN /opt/conda/bin/conda create -n moffusion python=3.9.18 -y && \
    echo "conda activate moffusion" >> ~/.bashrc

# Install PyTorch with CUDA 11.8
RUN /opt/conda/bin/conda run -n moffusion conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=11.3 -c pytorch -y && \
    /opt/conda/bin/conda run -n moffusion conda install -c conda-forge cudatoolkit-dev -y

# Install additional dependencies
RUN /opt/conda/bin/conda run -n moffusion conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y && \
    /opt/conda/bin/conda run -n moffusion conda install pytorch3d -c pytorch3d -y && \
    /opt/conda/bin/conda run -n moffusion pip install h5py joblib termcolor scipy einops tqdm matplotlib opencv-python PyMCubes imageio trimesh omegaconf tensorboard notebook Pillow==9.5.0 py3Dmol ipywidgets transformers pormake seaborn && \
    /opt/conda/bin/conda run -n moffusion pip install -U scikit-learn

# Create directory for pretrained models
RUN mkdir -p /workspace/saved_ckpt

WORKDIR /workspace
CMD ["/bin/bash"]
