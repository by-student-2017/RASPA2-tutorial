RASPA 2.0.37

RASPA2 (Edit: 15/Nov/2021)
(ubuntu 20.04 LTS, ubuntu 18.04 LTS or Debian 10.3 on windows10)

Å† Installation
1. sudo apt -y update
2. sudo apt -y install automake libtool make
3. git clone https://github.com/numat/RASPA2.git
4. cd RASPA2
5. rm -rf autom4te.cache
6. mkdir m4
7. aclocal
8. autoreconf -i
9. automake --add-missing
10. autoconf
11. ./configure --prefix=${HOME}/RASPA2
12. make
13. make install
