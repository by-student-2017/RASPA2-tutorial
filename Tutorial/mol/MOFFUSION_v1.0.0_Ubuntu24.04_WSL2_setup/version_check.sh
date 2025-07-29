#!/bin/bash

echo "=== OS & Kernel Info ==="
lsb_release -a
uname -r

echo ""
echo "=== Docker Versions ==="
docker --version
docker compose version
docker buildx version
containerd --version

echo ""
echo "=== NVIDIA Container Toolkit Versions ==="
nvidia-container-cli --version
dpkg -l | grep nvidia-docker

echo ""
echo "=== Conda Environment Activation ==="
source ~/miniconda3/etc/profile.d/conda.sh
conda activate moffusion || { echo "Error: conda environment 'moffusion' not found."; exit 1; }

echo ""
echo "=== PyTorch & CUDA Versions ==="
python -c "import torch; print('PyTorch:', torch.__version__); print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda)"

echo ""
echo "=== torchvision / torchaudio ==="
python -c "import torchvision; print('torchvision:', torchvision.__version__)"
python -c "import torchaudio; print('torchaudio:', torchaudio.__version__)"

echo ""
echo "=== fvcore / iopath ==="
python -c "import fvcore; print('fvcore:', fvcore.__version__)"
python -c "import iopath; print('iopath:', iopath.__version__)"

echo ""
echo "=== PyTorch3D ==="
python -c "import pytorch3d; print('pytorch3d:', pytorch3d.__version__)"

echo ""
echo "=== Python Packages (pip) ==="
pip list | grep -E 'h5py|joblib|termcolor|scipy|einops|tqdm|matplotlib|opencv-python|PyMCubes|imageio|trimesh|omegaconf|tensorboard|notebook|Pillow|py3Dmol|ipywidgets|transformers|pormake|seaborn|scikit-learn'

echo ""
echo "=== MOFFUSION Version Info ==="
if [ -d MOFFUSION ]; then
  echo "MOFFUSION directory exists."
  echo "Version: v1.0.0 (from GitHub tag)"
  grep -i version MOFFUSION/* 2>/dev/null | head -n 5
else
  echo "MOFFUSION directory not found."
fi

