#!/bin/zsh

DEPS=/opt/deps
export PATH=$DEPS/automake/bin:$DEPS/m4/bin:$DEPS/autoconf/bin:$DEPS/autotool/bin:$DEPS/libtool/bin:$PATH
export LD_LIBRARY_PATH=$DEPS/libtool/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$DEPS/libtool/lib:$LIBRARY_PATH

