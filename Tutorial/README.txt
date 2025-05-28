RASPA 2.0.37

RASPA2 (Edit: 15/Nov/2021)
(ubuntu 20.04 LTS, ubuntu 18.04 LTS or Debian 10.3 on windows10)

## Installation
1. cd ~
2. sudo apt -y update
3. sudo apt -y install gcc automake libtool make
4. sudo apt -y install libfftw3-dev libblas-dev liblapack-dev
5. git clone https://github.com/numat/RASPA2.git
6. cd ~/RASPA2
7. git pull
8. export CFLAGS="-Wall -O3 -ffast-math"
9. export CC="gcc"
10. export RASPA_DIR=${HOME}/RASPA/simulations/
11. rm -rf autom4te.cache
12. mkdir m4
13. aclocal
14. autoreconf -i
15. automake --add-missing
16. autoconf
17. ./configure --prefix=${RASPA_DIR}
18. make
19. make install
20. echo 'export RASPA_DIR=${HOME}/RASPA/simulations/' >> ~/.bashrc
21. source ~/.bashrc
