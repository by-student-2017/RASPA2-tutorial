#-----------------------------------------------------------
# Database
https://hjkgrp.mit.edu/publication/zhao-core-2025/
https://github.com/core-cof/CoRE-COF-Database
https://github.com/iRASPA/RASPA2/tree/master/structures/mofs/cif
https://zenodo.org/records/15055758
https://mof.tech.northwestern.edu/
https://zenodo.org/records/11237900
#-----------------------------------------------------------
# Rule-based structure generation tool
ToBaCCo（Topological Building Block Construction）: https://github.com/tobacco-mofs/tobacco_3.0

# VQ-VAE（Vector Quantized VAE）
https://github.com/parkjunkil/MOFFUSION

https://pypi.org/project/pycofbuilder/
https://github.com/Zhangshitong-hub/MOF-MembraneConstructor
https://mofsimplify.mit.edu/
#-----------------------------------------------------------
MOFXDB API Databases
https://mof.tech.northwestern.edu/databases
#-----------------------------------------------------------
https://github.com/mtap-research/CoRE-MOF-Tools
https://github.com/coudertlab/CoRE-MOF
#-----------------------------------------------------------


#-----------------------------------------------------------
# Podman Desktop (https://podman-desktop.io/)
1. (Download Now): Windows installer x64, version v1.20.2
2. podman-desktop-1.20.2-setup-x64.exe
3. conda deactivate
4. (click) Set up -> Next -> Yes -> Installation -> All Next
(Podmanv5.5.2  RUNNING)
#-----------------------------------------------------------
# podman version 3.4.4, WSL2, Ubuntu 22.04, RTX 7030
1. sudo apt update
2. sudo apt install podman -y
3. podman --version
4. podman build -t moffusion --build-arg BASE_IMAGE=docker.io/nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 ./
6. git clone https://github.com/parkjunkil/MOFFUSION.git
7. cd MOFFUSION
8. (Download): *.pth files, manually. (saved_ckpt in MOFFUSION)
9. cd ../
10. podman run -it --rm -p 8888:8888 -v $(pwd)/MOFFUSION:/workspace/MOFFUSION moffusion
11. cd MOFFUSION
12. pip install numpy==1.26.4
13. jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser
  (Open EI or firefox, etc)
  Note: After http://localhost:8888/?token=, copy and paste the alphanumeric characters that appear after ?token= into the URL of your web browser.
14. (double click) demo_H2.ipynb -> Run -> Run All Cells

# CPU version
#------------------------------------------------
os.environ["CUDA_VISIBLE_DEVICES"] = f"{gpu_ids}"
-> 
#os.environ["CUDA_VISIBLE_DEVICES"] = f"{gpu_ids}"
#------------------------------------------------
opt.device = "cpu"
MOFFUSION = create_model(opt)
#------------------------------------------------

# nvidia-docker2
#------------------------------------------------
nvidia-smi
#------------------------------------------------
exit
#-----------------------------------------------------------


#-----------------------------------------------------------
# Failed: Bash (WSL2, Ubuntu 22.04)
bash install_moffusion.sh
#-----------------------------------------------------------
# Failed: Doker (WSL, Ubuntu 22.04)
sudo apt update
sudo apt install docker.io

podman --version
podman build -t moffusion ./

podman run --gpus all -it moffusion
#-----------------------------------------------------------
# Failed: Doker (WSL, Ubuntu 22.04)
sudo apt update
sudo apt install docker.io

sudo systemctl start docker
sudo systemctl enable docker

podman --version
podman build -t moffusion ./

podman run --gpus all -it moffusion
#-----------------------------------------------------------
