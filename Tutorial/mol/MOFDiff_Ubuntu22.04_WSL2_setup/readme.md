# MOFDiff setup (Edit: 2025/07/30) 
## Docker Engine (free version), GPU: RTX 3070, OS: Ubuntu 22.04 LTS, WSL2, Windows 11

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
- If the above doesn't work, try consulting Copilot.
```
echo "Stopping any running dockerd..."
sudo pkill dockerd
echo "Removing lock files..."
sudo rm -f /var/run/docker.pid
sudo rm -f /var/lib/docker/volumes/metadata.db
sudo rm -f /var/lib/docker/network/files/local-kv.db
echo "Starting dockerd..."
sudo dockerd                 # Restart the Docker daemon
```


- Create the one for moffusion with conda create
```
conda create -n mofdiff python=3.10 -y
conda activate mofdiff
```


- Get deta from zenodo (MOFDiff: Coarse-grained Diffusion for Metal-Organic Framework Design: https://zenodo.org/records/10806179)
- If you are only doing inference (MOF generation): 
```
wget https://zenodo.org/records/10806179/files/pretrained.tar.gz?download=1 -O pretrained.tar.gz
wget https://zenodo.org/records/10806179/files/bb_emb_space.tar.gz?download=1 -O bb_emb_space.tar.gz
```
- When post-processing such as GCMC evaluation and structural classification is also performed
```
wget https://zenodo.org/records/10806179/files/bw_db.tar.gz?download=1 -O bw_db.tar.gz
wget https://zenodo.org/records/10806179/files/WC_optimized.tar.gz?download=1 -O WC_optimized.tar.gz
```


- Store data in MOFDiff_data
```
mkdir pretrained
mv pretrained.tar.gz ./pretrained/
mv bb_emb_space.tar.gz ./pretrained/
mv bw_db.tar.gz ./pretrained/
mv WC_optimized.tar.gz ./pretrained/
```


- Note: In another terminal run:
```
bash install_pytorch_cuda113.sh
bash install_mofdiff.sh
bash unpack_mofdiff_data.sh
```


## Usage
```
export PROJECT_ROOT=$(pwd)/MOFDiff
export diffusion_model_path=$(PROJECT_ROOT)/pretrained/diffusion_model.pt
export bb_cache_path=$(PROJECT_ROOT)/pretrained/bb_emb_space.pt
export data_path=$(PROJECT_ROOT)/pretrained/data.lmdb

cd MOFDiff

python mofdiff/scripts/sample.py --model_path ${diffusion_model_path} --bb_cache_path ${bb_cache_path}
python mofdiff/scripts/optimize.py --model_path ${diffusion_model_path} --bb_cache_path ${bb_cache_path} --data_path ${data_path} --property "working_capacity_vacuum_swing [mmol/g]" --target_v 15.0
python mofdiff/scripts/assemble.py --input ${sample_path}/samples.pt
python mofdiff/scripts/uff_relax.py --input ${sample_path}
```