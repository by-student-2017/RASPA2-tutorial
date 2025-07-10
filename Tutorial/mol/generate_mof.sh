#!/bin/bash

# Topologies available: pcu, dia, sql, kgm
tobacco --make_MOF -t pcu -o MOF_pcu.cif

# Generate a structure with a specified metal center (e.g., Scandium, Octahedral geometry)
tobacco -m Sc -pg Oh -d 1.0 -o Sc_Oh.cif

# Generate a Secondary Building Unit (SBU) from a Gaussian .com file
tobacco --build_sbu node -i input.com -o node_sbu.cif

# Generate a linker SBU from a Gaussian .com file (from Avogadro or GaussView, etc)
tobacco --build_sbu linker -i linker.com -o linker_sbu.cif
#tobacco --build_sbu linker -i linker.cif -o linker_sbu.cif


# Assemble the MOF structure using the specified topology and SBUs
tobacco --assemble -n node_sbu.cif -l linker_sbu.cif -t pcu -o final_MOF.cif
