# NOFFUSION v.1.0.0 setup (Edit: 2025/07/25) 
## Docker Engine (free version), GPU: RTX 3070, OS: Ubuntu 22.04 LTS, WSL2, Windows 11

## Installation
```
bash install_docker_cuda_wsl2.sh
```
- Note: Close normally


```
sudo dockerd
```
- Note: Leave this terminal open (the daemon should be running)


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
- In my environment, ffmpeg is very old, version 2.1 (released in 2013), and the direct cause of the error is that the palettegen and paletteuse filters are not supported. Therefore, I slightly rewrote "visualizer.py" in "MOFFUSION/visualize" directory to use PillowWriter.
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
