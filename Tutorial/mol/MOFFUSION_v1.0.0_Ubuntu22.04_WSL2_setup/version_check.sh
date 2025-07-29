#!/bin/bash

echo "=== OS & Kernel Info ==="
lsb_release -a || echo "lsb_release not available"
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
echo "=== Python Version ==="
~/miniconda3/bin/conda run -n moffusion python --version

echo ""
echo "=== PyTorch & CUDA Versions ==="
~/miniconda3/bin/conda run -n moffusion python -c "import torch; print('PyTorch:', torch.__version__); print('CUDA available:', torch.cuda.is_available()); print('CUDA version:', torch.version.cuda)"

echo ""
echo "=== torchvision / torchaudio ==="
~/miniconda3/bin/conda run -n moffusion python -c "import torchvision; print('torchvision:', torchvision.__version__)"
~/miniconda3/bin/conda run -n moffusion python -c "import torchaudio; print('torchaudio:', torchaudio.__version__)"

echo ""
echo "=== fvcore / iopath ==="
~/miniconda3/bin/conda run -n moffusion python -c "import fvcore; print('fvcore:', fvcore.__version__)"
~/miniconda3/bin/conda run -n moffusion python -c "import iopath; print('iopath:', iopath.__version__)"

echo ""
echo "=== PyTorch3D ==="
~/miniconda3/bin/conda run -n moffusion python -c "import pytorch3d; print('pytorch3d:', pytorch3d.__version__)"

echo ""
echo "=== Python Packages (pip) ==="
~/miniconda3/bin/conda run -n moffusion pip list | grep -E 'h5py|joblib|termcolor|scipy|einops|tqdm|matplotlib|opencv-python|PyMCubes|imageio|trimesh|omegaconf|tensorboard|notebook|Pillow|py3Dmol|ipywidgets|transformers|pormake|seaborn|scikit-learn'

echo ""
echo "=== MOFFUSION Version Info ==="
if [ -d /workspace/MOFFUSION ]; then
  echo "MOFFUSION directory exists."
  echo "Version: v1.0.0 (from GitHub tag)"
  grep -i version /workspace/MOFFUSION/* 2>/dev/null | head -n 5
else
  echo "MOFFUSION directory not found."
fi
