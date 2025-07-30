#!/bin/bash

echo "Activating Conda environment 'mofdiff'..."
source $(conda info --base)/etc/profile.d/conda.sh
conda activate mofdiff

echo "Cloning MOFDiff repository..."
git clone https://github.com/microsoft/MOFDiff.git
export PROJECT_ROOT=$(pwd)/MOFDiff
cd $PROJECT_ROOT

echo "Installing Python dependencies..."
sed -i 's/lammps==2023.11.21/lammps==2023.8.2.3.1/' requirements.txt
pip install 'pip<24.1'
sed -i 's/pytorch-lightning==1.6.1/pytorch-lightning==1.6.5/' requirements.txt
sed -i 's/quippy-ase==0.9+gitnone/quippy-ase==0.9.14/' requirements.txt
sed -i 's/monty==2024.1.26/monty==2024.2.2/' requirements.txt
sed -i 's/protobuf==4.25.1/protobuf==3.20.1/' requirements.txt
sed -i 's/pymatgen==2024.2.20/pymatgen==2023.8.10/' requirements.txt
pip install -r requirements.txt

echo "# MOFDiff environment" >> ~/.bashrc
echo "export diffusion_model_path=\$HOME/MOFDiff/pretrained/diffusion_model.pt" >> ~/.bashrc
echo "export bb_cache_path=\$HOME/MOFDiff/pretrained/bb_emb_space.pt" >> ~/.bashrc
echo "export data_path=\$HOME/MOFDiff/pretrained/data.lmdb" >> ~/.bashrc

echo "MOFDiff setup completed successfully."
echo "Please manually set PROJECT_ROOT each time you enter the MOFDiff directory:"
echo "  export PROJECT_ROOT=\$(pwd)/MOFDiff"
