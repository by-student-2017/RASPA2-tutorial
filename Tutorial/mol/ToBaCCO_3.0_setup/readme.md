# ToBaCCO 3.0 setup (Edit: 2025/07/10)
## OS: Ubuntu 22.04 LTS, WSL2, Windows11, GPU: RTX 3070

## After installing Anaconda, create a virtual environment
```
conda create --name tobacco_env python=3.7
```


## Activate the environment
```
conda activate tobacco_env
```


## Install required packages
```
conda install numpy=1.19.1
conda install networkx=2.5
conda install scipy=1.5.2
conda install matplotlib
```


## Clone the GitHub repository
```
git clone https://github.com/tobacco-mofs/tobacco_3.0.git
cd tobacco_3.0
```


## Download the topology database
```
python tobacco.py --get_topols_db
```


# ToBaCCO 3.0 usage (Edit: 2025/07/10)
## OS: Ubuntu 22.04 LTS, WSL2, Windows11, GPU: RTX 3070
```
1. mv vertex_assignment.txt vertex_assignment_original.txt 
2. cat << EOF > vertex_assignment.txt
MOF_name: MOF_Zn_bdc
Topology: pcu
vertex assignment: 6c_Zn_1_Ch.cif
edge assignment: 1B_1TrU.cif
EOF
3. python tobacco.py
4. (see) output_cifs
```


## Note: All combinations of data in the files below will be considered.
- nodes
- edges
- template

## Note:
```
ls nodes_database
ls edges_database
ls template_database
```


## Note: configuration.py
```
USER_SPECIFIED_NODE_ASSIGNMENT = True
COMBINATORIAL_EDGE_ASSIGNMENT = False
```
