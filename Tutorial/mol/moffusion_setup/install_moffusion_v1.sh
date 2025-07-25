#!/bin/bash

# Download OFFUSION v1.0.0 and build the Docker image

set -e

echo "=== Step 1: Downloading MOFFUSION v1.0.0 ==="
if [ ! -e v1.0.0.tar.gz ]; then
  wget https://github.com/parkjunkil/MOFFUSION/archive/refs/tags/v1.0.0.tar.gz
fi

echo "=== Step 2: Extracting archive ==="
tar xvf v1.0.0.tar.gz

echo "=== Step 3: Renaming folder to MOFFUSION ==="
mv MOFFUSION-1.0.0 MOFFUSION

echo "=== Step 4: Creating saved_ckpt directory ==="
mkdir -p MOFFUSION/saved_ckpt
echo "Manually place the required .pth files in MOFFUSION/saved_ckpt."

echo "=== Step 5: Building Docker image ==="
docker build -t moffusion --build-arg BASE_IMAGE=nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 ./

echo "=== Step 6: Running Docker container ==="
docker run --rm -it -p 8888:8888 --gpus all \
  -v $(pwd)/MOFFUSION:/workspace/MOFFUSION \
  moffusion bash -c "cd /workspace/MOFFUSION"

echo "=== Step 7: Access Jupyter Notebook ==="
echo "In the container run:"
echo "jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser"
echo "Go to http://localhost:8888/?token=... in your browser and paste the token."
echo "Open demo_H2.ipynb and click “Run All Cells”."
