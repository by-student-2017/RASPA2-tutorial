# MOFDiff setup (Edit: 2025/07/28) 
## Micromamba, GPU: RTX 3070, OS: Ubuntu 20.04 LTS, WSL2, Windows 11


## WSL2 (on command prompt)
- Run the following in a Windows command prompt with administrator privileges:
```
wsl --help
wsl -l -o
wsl --install Ubuntu-20.04
```


## Installation (on Linux shell)
- From now on, use the Linux shell (which may be selectable by pressing "shift + right click").
```
bash setup_micromamba.sh
```


```
micromamba activate mofdiff-env
sudo apt update && sudo apt install -y build-essential g++ cmake python3-dev
micromamba install pip wheel setuptools cython pybind11 -c conda-forge -y
CXX=g++ CXXFLAGS="-std=c++11" pip install pyeqeq==0.0.10
```


- Get deta from zenodo (MOFDiff: Coarse-grained Diffusion for Metal-Organic Framework Design: https://zenodo.org/records/10806179)
```
wget https://zenodo.org/records/10806179/files/bb_emb_space.tar.gz?download=1 -O bb_emb_space.tar.gz
wget https://zenodo.org/records/10806179/files/bw_db.tar.gz?download=1 -O bw_db.tar.gz
wget https://zenodo.org/records/10806179/files/pretrained.tar.gz?download=1 -O pretrained.tar.gz
wget https://zenodo.org/records/10806179/files/WC_optimized.tar.gz?download=1 -O WC_optimized.tar.gz
```


```
bash install_mofdiff.sh
```


- (option: Instattion Zeo++ and RASPA2)
```
bash install_zeopp_raspa2.sh

# or 

bash install_zeopp.sh
bash install_raspa2.sh
```


## After that (after the second time or after restarting the PC, etc.) (on Linux shell)
```
micromamba activate mofdiff-env
cd MOFDiff
```


## postprocess (Zeo++, RASPA2)
```
bash postprocess_mofdiff.sh

or

bash postprocess_zeopp.sh
bash postprocess_raspa2.sh
```

---
