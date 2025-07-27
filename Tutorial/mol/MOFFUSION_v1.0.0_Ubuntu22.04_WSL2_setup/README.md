# NOFFUSION v.1.0.0 setup (Edit: 2025/07/26) 
## Docker Engine (free version), GPU: RTX 3070, OS: Ubuntu 20.04 LTS, WSL2, Windows 11

## WSL2
```
wsl --help
wsl -l -o
wsl --install Ubuntu-22.04
```


## Installation
```
bash setup_miniconda3.sh
```


```
bash install_docker_cuda_wsl2.sh
```
- Note: Close normally


```
sudo dockerd
```
- Note: Leave this terminal open (the daemon should be running)
- If Docker is Already Running. You may encounter the following error:


  failed to start daemon, ensure docker is not running or delete /var/run/docker.pid: process with PID XXXX is still running


- In this case, follow these steps to resolve it:
```
ps aux | grep dockerd        # Check if the Docker daemon is running and find its PID
sudo kill <PID>              # Stop the running Docker daemon process
sudo rm /var/run/docker.pid  # Remove the leftover PID file
sudo dockerd                 # Restart the Docker daemon
```


```
conda create -n moffusion python=3.9.18 -y
conda activate moffusion
pip uninstall numpy pymatgen opencv-python transformers ffmpeg -y
pip install numpy==1.26.4
pip install pymatgen==2023.11.12
pip install opencv-python==4.9.0.80
pip install "huggingface-hub>=0.16.4,<1.0.0"
pip install tokenizers==0.21.2
pip install transformers==4.22.2
pip install ffmpeg-python
sudo apt install libopenh264-6
sudo ln -s /usr/lib/x86_64-linux-gnu/libopenh264.so.6 /usr/lib/x86_64-linux-gnu/libopenh264.so.5
```


- Note: In another terminal run:
```
bash install_pytorch_cuda118.sh
bash install_moffusion_v1.sh
```


```
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser
```
- Note: After http://localhost:8888/?token=, copy and paste the alphanumeric characters that appear after ?token= into the URL of your web browser.
- (double click) demo_H2.ipynb -> Run -> Run All Cells
- It is difficult to set up a GPU in Podman, and it is necessary to rewrite the python code to run it on a CPU. Therefore, I used the free Docker engine.
- For other GPUs, please show Chat-GPT the files here and try to get it to support your GPU.
- This site was created using WSL2, so if you have any problems with line breaks, please use the command dos2unix.


## Note
- Modification for demo_text.ipynb: Specified strict=False in the load_ckpt function of MOFFUSION/models/moffusion_text_model.py.
- The results of the demos are stored in the "samples" directory in MOFFUSION, named after each demo. Comments on the results are shown in the "jupyter notebook".


## saved_ckpt
- You need to manually download the following *.pth and put it in saved_ckpt. Also, please make sure that saved_ckpt and *.pth are in MOFFUSION. If not, you can manually copy saved_ckpt to MOFFUSION.
- [vqvae.pth](https://figshare.com/ndownloader/files/46925977)
- [mof_constructor_topo.pth](https://figshare.com/ndownloader/files/46925971)
- [mof_constructor_BB.pth](https://figshare.com/ndownloader/files/46925974)
- [moffusion_uncond.pth](https://figshare.com/ndownloader/files/46931689)
- [moffusion_topo.pth](https://figshare.com/ndownloader/files/46926004)
- [moffusion_H2.pth](https://figshare.com/ndownloader/files/46931701)
- [moffusion_text.pth](https://figshare.com/ndownloader/files/46925995)


## MOFFUSION Recommended Environment

This document outlines the recommended environment for running **MOFFUSION**, focusing on stability, compatibility, and long-term support. It includes guidance for both **Docker-based** and **WSL2-based** setups, with considerations for GPU acceleration.

### Overview

MOFFUSION relies heavily on GPU acceleration and specific library versions. While the core dependencies are aligned with **Ubuntu 20.04 LTS**, we recommend using **Ubuntu 22.04 LTS** for host systems due to its extended support and compatibility.

#### Key Points

- **Library Compatibility**: Most libraries (e.g., CUDA 11.3, Python 3.9.18) were released during the Ubuntu 20.04 LTS era.
- **Host OS Recommendation**: Ubuntu 22.04 LTS is preferred for host systems due to support until **April 2027**.
- **Docker Containers**: Use Ubuntu 20.04 LTS as the base image inside containers to ensure compatibility.
- **WSL2 Environment**: Ubuntu 22.04 LTS is used with CUDA 11.8 for better integration with newer drivers and toolkits.

### Recommended Configurations

#### Docker-Based Setup (Containerized Execution)

| Component     | Version        | Notes                                                                 |
|--------------|----------------|-----------------------------------------------------------------------|
| Base Image   | Ubuntu 20.04 LTS | Ensures compatibility with MOFFUSION dependencies                    |
| CUDA         | 11.3            | Stable and widely supported for PyTorch 1.11.0                        |
| Python       | 3.9.18          | Compatible with MOFFUSION and CUDA 11.3                              |
| PyTorch      | 1.11.0          | Verified to work with CUDA 11.3                                      |
| Docker Engine| Latest          | GPU support via NVIDIA Container Toolkit                             |

#### WSL2-Based Setup (Native Execution)

| Component     | Version        | Notes                                                                 |
|--------------|----------------|-----------------------------------------------------------------------|
| OS           | Ubuntu 22.04 LTS | Host system running under WSL2                                       |
| CUDA         | 11.8            | Compatible with newer NVIDIA drivers and WSL2 integration            |
| Python       | 3.9.18          | Maintains compatibility with MOFFUSION                               |
| PyTorch      | 1.13.1          | Recommended for CUDA 11.8                                            |

### GPU Support

To enable GPU acceleration inside Docker containers:

1. Install **Docker Engine** (not Docker Desktop) on Ubuntu 22.04 LTS.
2. Install **NVIDIA Container Toolkit**.
3. Use a Docker image based on Ubuntu 20.04 LTS with CUDA 11.3 and Python 3.9.18.
4. Run MOFFUSION inside the container with GPU access.

### Example Docker Run Command

```
docker run --gpus all -it \
  -v $(pwd):/workspace \
  --workdir /workspace \
  moffusion:cuda11.3-py3.9 \
```


## Troubleshooting GPU Memory Issues in MOFFUSION Notebooks

When working with MOFFUSION notebooks, especially in environments like WSL2 or with limited GPU memory (e.g., RTX 3070 with 8GB VRAM), you may encounter kernel crashes or memory allocation errors. This guide provides best practices to help mitigate GPU memory issues.

---

### Best Practices to Avoid GPU Memory Problems

#### 1. Close Other Jupyter Notebook Tabs
- Other notebooks may retain models or data in GPU memory.
- Close unused tabs to ensure memory is released.

#### 2. Close Other Browser Tabs and Windows
- Web pages using WebGL or GPU acceleration (e.g., YouTube, Google Earth) can consume GPU resources.
- Close unnecessary tabs to reduce GPU load.

#### 3. Terminate Unused Python Processes
- Use the following command to identify and terminate idle Python processes:
  ```bash
  ps aux | grep python
  ```


## Citation
1. Journal version
```
@inproceedings{,
  author={Park, Junkil and Lee, Youhan and Kim, Jihan},
  title={Multi-modal conditional diffusion model using signed distance functions for metal-organic frameworks generation},
  Journal={Nature Communications},
  year={2024},
}
```
2. arXiv version
```
@article{,
  author={Park, Junkil and Lee, Youhan and Kim, Jihan},
  title={Multi-modal conditioning for metal-organic frameworks generation using 3D modeling techniques},
  Journal={chemrxiv},
  year={2024},
}
```


## License
- This project is licensed under the MIT License. Please check the LICENSE file for more information.
