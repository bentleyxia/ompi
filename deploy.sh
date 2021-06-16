#!/bin/zsh

cd /home/xialb/git/ompi

cd 3rd-party/openpmix
libtoolize
./autogen.pl
./configure --prefix=/opt/deps/pmix --enable-debug --with-hwloc=/opt/deps/hwloc
make clean
make -j
sudo rm -rf /opt/deps/pmix
sudo make install

cd ../prrte
libtoolize
./autogen.pl
./configure --prefix=/opt/deps/prrte --enable-debug --with-pmix=/opt/deps/pmix --with-hwloc=/opt/deps/hwloc
make clean
make -j
sudo rm -rf /opt/deps/prrte
sudo make install

cd ../ompi
libtoolize
./autogen.pl
./configure --prefix=/opt/ompi --enable-mpi-java --enable-debug --enable-mem-debug --enable-mem-profile --with-pmix=/opt/deps/pmix --with-prrte=/opt/deps/prrte --with-hwloc=/opt/deps/hwloc
make clean
make -j
sudo rm -rf /opt/ompi
sudo make install
