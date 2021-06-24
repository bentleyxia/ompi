#!/bin/zsh

echo "get su permission"
sudo echo "done"

LOG_NULL="&> /dev/null"
ROOT_DIR=$(realpath `dirname $0`)

cd $ROOT_DIR

# base functions

autogen () {
	rm -rf /tmp/${MODULE}_log
	zsh -c "libtoolize $LOG_NULL"
	zsh -c "./autogen.pl $LOG"
}

configure () {
	echo "command is $1"
	zsh -c "./configure --prefix=$INSTALL_PATH --enable-debug --with-hwloc=/opt/deps/hwloc $1 $LOG"
}

install () {
	zsh -c "sudo rm -rf $INSTALL_PATH $LOG_NULL"
	zsh -c "sudo make install $LOG"
}

build () {
	zsh -c "make clean $LOG_NULL"
	zsh -c "make -j $LOG"
}

flow () {
	echo "======== start $MODULE autogen ======== "
	autogen
	configure $1
	echo "======== start build $MODULE ======== "
	build
	echo "======== start install $MODULE ======== "
	install
}


# build modules

openpmix () {
	MODULE='openpmix'
	LOG=">> /tmp/${MODULE}_log 2>&1"
	SOURCE_PATH="$ROOT_DIR/3rd-party/$MODULE"
	INSTALL_PATH="/opt/deps/$MODULE"
	cd $SOURCE_PATH
	flow
}

prrte () {
	MODULE='prrte'
	LOG=">> /tmp/${MODULE}_log 2>&1"
	SOURCE_PATH="$ROOT_DIR/3rd-party/$MODULE"
	INSTALL_PATH="/opt/deps/$MODULE"
	cd $SOURCE_PATH
	flow --with-pmix=/opt/deps/openpmix
}

ompi () {
	MODULE='ompi'
	LOG=">> /tmp/${MODULE}_log 2>&1"
	SOURCE_PATH="$ROOT_DIR"
	INSTALL_PATH="/opt/$MODULE"
	cd $SOURCE_PATH
	cd 3rd-party/romio341/mpl && \
		libtoolize && \
		cd $SOURCE_PATH
	flow "--with-pmix=/opt/deps/openpmix --enable-mpi-java --enable-mem-debug --enable-mem-profile --with-prrte=/opt/deps/prrte"
}

# main

main () {
	$1
	$2
	$3
}

if [ "$#" -ne 0 ]
then
    echo "process $1 $2 $3"
    main $1 $2 $3
else
    echo "process all"
    main openpmix prrte ompi
fi
