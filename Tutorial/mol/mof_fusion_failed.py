from rdkit import Chem
from rdkit.Chem import AllChem

mol = Chem.MolFromMolFile("mol/BDBA.mol")
mol = Chem.AddHs(mol)
AllChem.EmbedMolecule(mol)
AllChem.UFFOptimizeMolecule(mol)
smiles = Chem.MolToSmiles(mol)

from omegaconf import OmegaConf
from models.mof_constructor_topo_model import ResNetModel as MOFConstructor

# cpu version: use_gpu: false in mof_constructor_topo.yaml
cfg = OmegaConf.load("configs/mof_constructor.yaml")
constructor = MOFConstructor(cfg)

# seed: 123 in mof_constructor_topo.yaml
#mof_structure = constructor.generate(linker_smiles=smiles, topology="pcu") # Primitive Cubic
#mof_structure = constructor.generate(linker_smiles=smiles, topology="dia") # Diamond
#mof_structure = constructor.generate(linker_smiles=smiles, topology="fcu") # Face-Centered Cubic
#mof_structure = constructor.generate(linker_smiles=smiles, topology="sql") # Square Lattice
#mof_structure = constructor.generate(linker_smiles=smiles, topology="acs") # Acetylene Square
#mof_structure = constructor.generate(linker_smiles=smiles, topology="rra") # Rod-Rod Assembly
#mof_structure = constructor.generate(linker_smiles=smiles, topology="kgm") # Kagome
mof_structure = constructor.generate(linker_smiles=smiles, topology="hcb") # Honeycomb

from ase import Atoms
from ase.io import write

symbols = mof_structure['symbols']
positions = mof_structure['positions']
cell = mof_structure['cell']

mof = Atoms(symbols=symbols, positions=positions, cell=cell, pbc=True)
write("MOF.cif", mof)
