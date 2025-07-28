# MOFFUSION v.1.0.0 setup (Edit: 2025/07/27) 
## Docker Engine (free version), GPU: RTX 3070, OS: Ubuntu 20.04 LTS, WSL2, Windows 11


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
- If the above doesn't work, try consulting Copilot. (For example, the following command is suggested:)
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
- Note: In another terminal run:
```
conda create -n moffusion python=3.9.18 -y
conda activate moffusion
pip uninstall numpy pymatgen opencv-python transformers -y
pip install numpy==1.26.4
pip install pymatgen==2023.8.10
pip install opencv-python==4.9.0.80
pip install "huggingface-hub>=0.16.4,<1.0.0"
pip install tokenizers==0.21.2
pip install transformers==4.22.2
```


```
bash install_pytorch_cuda113.sh
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


## After that (after the second time or after restarting the PC, etc.) (on Linux shell)
```
conda activate moffusion
cd MOFFUSION
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --no-browser
```

---

## MOFFUSION Jupyter Notebooks Overview

MOFFUSION provides several Jupyter Notebooks tailored for different types of MOF (Metal-Organic Framework) structure generation. Each notebook corresponds to a specific generation mode and is designed to support various research and design workflows.

---

### 1. `demo_text.ipynb`: Conditional Generation on Text

- **Purpose**: Generates MOF structures based on natural language descriptions (e.g., "MOF with high surface area").
- **Application**: Enables intuitive design using textual prompts; accessible even to non-experts.
- **Technical Background**: A Transformer-based encoder converts text into a latent condition vector, which guides the diffusion model during generation.
- **Output**: Saved in `./samples/Demo_text`.
- **Note**: Studies show that text-based conditions can effectively control properties like porosity and topology.

---

### 2. `demo_topo.ipynb`: Conditional Generation on Topology

- **Purpose**: Generates MOFs based on a specified topology (e.g., crystal net or framework type).
- **Application**: Useful for designing MOFs with known structural motifs and desired connectivity.
- **Technical Background**: The model uses topology information as a condition to guide the generation process.
- **Output**: Saved in `./samples/Demo_topo`.
- **Note**: Topology significantly influences MOF properties such as stability and pore architecture.

---

### 3. `demo_H2.ipynb`: Conditional Generation on Hydrogen Working Capacity

- **Purpose**: Generates MOFs optimized for a target hydrogen uptake value.
- **Application**: Ideal for designing materials for hydrogen storage and energy applications.
- **Technical Background**: Numerical input (e.g., desired H₂ capacity) is used as a condition for the diffusion model.
- **Output**: Saved in `./samples/Demo_H2`.
- **Note**: MOFFUSION demonstrates high accuracy in generating structures that meet specified hydrogen storage targets.

---

### 4. `demo_pore_crafting.ipynb`: Pore Crafting

- **Purpose**: Generates MOFs with user-defined pore shapes and sizes.
- **Application**: Suitable for gas separation, catalysis, and drug delivery, where pore geometry is critical.
- **Technical Background**: Uses Signed Distance Functions (SDF) to precisely control pore morphology during generation.
- **Output**: Saved in `./samples/Demo_pore_crafting`.
- **Note**: SDF-based control enables the creation of complex pore structures that are difficult to achieve with traditional models.

---

### 5. `demo_uncond.ipynb`: Unconditional Generation

- **Purpose**: Generates MOF structures without any input condition.
- **Application**: Useful for exploratory structure generation and discovering novel MOFs beyond existing datasets.
- **Technical Background**: The model samples directly from the learned latent space of the diffusion model.
- **Output**: Saved in `./samples/Demo_uncond`.

---

### Output Files and Formats

Each notebook generates the following files:

- **`.cif` files**: Crystallographic Information Files containing atomic coordinates and lattice parameters. These are suitable for downstream simulation and analysis.
- **`.gif` files**: Animated visualizations of the generated MOF structures for quick inspection and presentation.

All files are saved under the `./samples` directory, organized by notebook type.

---

### Structure Optimization and Simulation Pipeline

Generated `.cif` files may require further optimization before use in simulations or experiments. Recommended workflows include:

#### Classical Force Field Optimization
- Tools: LAMMPS, [cif2lammps](https://github.com/by-student-2017/cif2lammps)
- Use: Geometry refinement, partial charge assignment, MD simulation preparation

#### Semi-Empirical Quantum Methods
- Tools: MOPAC, DFTB+
- Use: Fast electronic structure calculations, charge distribution, energy evaluation

#### Ab Initio Quantum Chemistry
- Tools: QE, CP2k, Siesta, Abinit, VASP, etc
- Use: High-accuracy energy calculations, orbital analysis, charge fitting

---

### Gas Adsorption `.cif` files can be used in Grand Canonical Monte Carlo (GCMC) simulations to evaluate gas adsorption properties:

- Tools: RASPA, LAMMPS
- Applications:
  - Hydrogen storage capacity
  - Selectivity for gas separation
  - Diffusion behavior in porous frameworks

---

## Note
- Modification for demo_text.ipynb: Specified strict=False in the load_ckpt function of "MOFFUSION/models/moffusion_text_model.py".
- The results of the demos are stored in the "samples" directory in MOFFUSION, named after each demo. Comments on the results are shown in the "jupyter notebook".


## saved_ckpt
- First, create a folder ./saved_ckpt to save the pre-trained weights. Then, download the pre-trained weights from the provided link and save them in the ./saved_ckpt folder.
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

---

### Overview

MOFFUSION relies heavily on GPU acceleration and specific library versions. While newer systems may prefer Ubuntu 22.04 LTS, **Ubuntu 20.04 LTS remains the most compatible and stable base** for MOFFUSION due to the release periods of its core dependencies. (Side note: I tried it on Ubuntu 18.04 LTS, but it didn't work with Docker or GPU settings. It's difficult unless you're an expert in this field.)

---

### Key Points

- **Library Compatibility**: Most core libraries (e.g., CUDA 11.3, Python 3.9.18, PyTorch 1.11.0) were released during the Ubuntu 20.04 LTS era.
- **Long-Term Support**: Ubuntu 20.04 LTS is supported until **April 2025**, making it ideal for legacy systems and reproducible research.
- **Version Constraints**: Many scientific libraries do not explicitly specify compatibility with newer OS versions, making Ubuntu 20.04 LTS a safer choice.
- **Docker Containers**: Use Ubuntu 20.04 LTS as the base image inside containers to ensure compatibility.
- **WSL2 Environment**: Ubuntu 20.04 LTS can be used directly under WSL2 for native execution with GPU support.

---

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
| OS           | Ubuntu 20.04 LTS | Host system running under WSL2                                       |
| CUDA         | 11.3            | Compatible with PyTorch 1.11.0                                       |
| Python       | 3.9.18          | Maintains compatibility with MOFFUSION                               |
| PyTorch      | 1.11.0          | Recommended for CUDA 11.3                                            |

---

### GPU Support

To enable GPU acceleration inside Docker containers:

1. Install **Docker Engine** (not Docker Desktop) on Ubuntu 20.04 LTS.
2. Install **NVIDIA Container Toolkit**.
3. Use a Docker image based on Ubuntu 20.04 LTS with CUDA 11.3 and Python 3.9.18.
4. Run MOFFUSION inside the container with GPU access.

---

### Example Docker Run Command

```
docker run --gpus all -it \
  -v $(pwd):/workspace \
  --workdir /workspace \
  moffusion:cuda11.3-py3.9
```

---

### Compatibility Note

> **CUDA 11.3 Compatibility**:  
> CUDA has **backward compatibility**, meaning applications built with CUDA 11.3 can run on newer GPUs, such as the **RTX 3070** and other models released in or after **2023**, as long as the installed driver supports CUDA 11.3.  
> However, newer GPUs—such as the **RTX 40 series** or **Blackwell architecture**—may benefit from optimizations available in more recent CUDA Toolkit versions.  
> While CUDA 11.3 can still function on these GPUs, it may not deliver optimal performance or utilize all hardware features.

---

## Known Issues with Conda-Based Setup

Although some documentation may suggest using a `conda` environment for MOFFUSION, we advise against it due to several compatibility and stability issues observed during testing.

### Common Problems

- **PyTorch3D Installation Failures**  
  `pytorch3d` requires tightly matched versions of PyTorch and CUDA. Conda often lacks prebuilt wheels for specific combinations (e.g., PyTorch 1.11.0 + CUDA 11.3), leading to build errors or runtime failures.

- **libcuda.so.5 Errors**  
  Conda environments may not correctly link to the system's GPU drivers, resulting in missing or incompatible `libcuda.so.X` libraries. This causes crashes or prevents GPU usage entirely.

- **ffmpeg and libopenh264 Compatibility**  
  On Ubuntu 22.04+, `ffmpeg` may fail due to missing `libopenh264.so.5`. Conda does not manage system-level libraries well, making manual fixes necessary and error-prone.

### Recommendation

For GPU-enabled execution and reproducible environments, use the Docker-based setup described above. It allows precise control over CUDA, Python, and library versions, and avoids the pitfalls of conda-based installations.

---

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

#### 4. Code solutions
- For code solutions, please refer to the additional description in demo_*.ipynb in seccess of MOFFUSION_v1.0.0_Ubuntu20.04_WSL2_setup ([2] and the end).

#### 5. Restart (on Linux shell)
- After closing the Jupyter notebooks, kill them with "Ctrl + C" in the Linux shell and restart them with the following command:
  ```bash
  wsl --shutdown
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
