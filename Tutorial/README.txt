RASPA 2.0.37

RASPA2 (Edit: 15/Nov/2021)
(ubuntu 20.04 LTS, ubuntu 18.04 LTS or Debian 10.3 on windows10)

## Installation
1. sudo apt -y update
2. sudo apt -y install gcc automake libtool make
3. sudo apt -y install libfftw3-dev libblas-dev liblapack-dev
4. git clone https://github.com/numat/RASPA2.git
5. cd ~/RASPA2
6. git pull
7. export CFLAGS="-Wall -O3 -ffast-math"
8. export CC="gcc"
9. export RASPA_DIR=${HOME}/RASPA/simulations/
10. rm -rf autom4te.cache
11. mkdir m4
12. aclocal
13. autoreconf -i
14. automake --add-missing
15. autoconf
16. ./configure --prefix=${RASPA_DIR}
17. make
18. make install