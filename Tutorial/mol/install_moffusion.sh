#!/bin/bash

# Create and activate conda environment
conda create -n moffusion python=3.9.18 -y
source activate moffusion

# Install PyTorch with CUDA 11.8 (compatible with RTX 7030)
conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 pytorch-cuda=11.8 -c pytorch -c nvidia -y

# Install additional CUDA development tools
conda install -y -c conda-forge cudatoolkit-dev

# Install required dependencies
conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y
conda install pytorch3d -c pytorch3d -y
pip install h5py joblib termcolor scipy einops tqdm matplotlib opencv-python PyMCubes imageio trimesh omegaconf tensorboard notebook Pillow==9.5.0 py3Dmol ipywidgets transformers pormake seaborn
pip install -U scikit-learn

# Download pretrained models
mkdir -p saved_ckpt
wget https://figshare.com/ndownloader/files/46925977 -O saved_ckpt/vqvae.pth
wget https://figshare.com/ndownloader/files/46925971 -O saved_ckpt/mof_constructor_topo.pth
wget https://figshare.com/ndownloader/files/46925974 -O saved_ckpt/mof_constructor_BB.pth
wget https://figshare.com/ndownloader/files/46931689 -O saved_ckpt/moffusion_uncond.pth

echo "MOFFUSION installation completed successfully."
