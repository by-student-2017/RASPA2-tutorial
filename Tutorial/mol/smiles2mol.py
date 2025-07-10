from rdkit import Chem
from rdkit.Chem import AllChem

# Corrected SMILES for 2-aminoterephthalic acid
smiles = 'NC1=CN=CN1N'

# Convert SMILES to molecule
mol = Chem.MolFromSmiles(smiles)

# Add hydrogens before generating 3D coordinates
mol = Chem.AddHs(mol)

# Generate 3D coordinates
AllChem.EmbedMolecule(mol)

# Write to MOL file
Chem.MolToMolFile(mol, '4.5-DAI.mol')

print("MOL file for 2-aminoterephthalic acid has been created successfully.")

