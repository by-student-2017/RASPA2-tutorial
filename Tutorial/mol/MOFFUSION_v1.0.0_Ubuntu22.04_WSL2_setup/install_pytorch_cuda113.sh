#!/bin/bash

# Install PyTorch + CUDA 11.3 in a Miniconda environment in Docker

echo "=== Step 1: Activating conda environment ==="
source ~/miniconda3/etc/profile.d/conda.sh  # Make conda activate available
conda activate moffusion || { echo "Error: conda environment 'moffusion' not found."; exit 1; }

echo "=== Step 2: Installing PyTorch with CUDA 11.3 ==="
conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=11.3 -c pytorch -y

echo "=== Step 3: Installing additional CUDA dev tools ==="
conda install -c conda-forge cudatoolkit-dev -y

echo "=== Step 4: Installing fvcore and iopath ==="
conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y

echo "=== Step 5: Installing PyTorch3D ==="
conda install pytorch3d -c pytorch3d -y

echo "=== Step 6: Installing Python packages via pip ==="
pip install h5py joblib termcolor scipy einops tqdm matplotlib opencv-python \
    PyMCubes imageio trimesh omegaconf tensorboard notebook Pillow==9.5.0 \
    py3Dmol ipywidgets transformers pormake seaborn

pip install -U scikit-learn

echo "=== Installation complete ==="
