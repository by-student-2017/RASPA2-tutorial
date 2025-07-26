#!/bin/bash

# Install PyTorch + CUDA 11.8 in a Miniconda environment in Docker

echo "=== Installing PyTorch with CUDA 11.8 ==="
conda activate moffusion

conda install pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=11.3 -c pytorch -y
conda install -c conda-forge cudatoolkit-dev -y
conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y
conda install pytorch3d -c pytorch3d -y

pip install h5py joblib termcolor scipy einops tqdm matplotlib opencv-python \
    PyMCubes imageio trimesh omegaconf tensorboard notebook Pillow==9.5.0 \
    py3Dmol ipywidgets transformers pormake seaborn
pip install -U scikit-learn

echo "PyTorch + CUDA 11.8 installation complete"
