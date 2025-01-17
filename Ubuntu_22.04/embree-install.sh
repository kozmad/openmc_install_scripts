################################################################################
#embree source install
################################################################################
#!/bin/bash
set -ex
if [ "x" == "$1x" ]; then
	ccores=1
else
	ccores=$1
fi

sudo apt-get install --yes gcc\
       	build-essential\
	cpp\
        make\
        cmake\
        libglfw3\
        libglfw3-dev\
        libtbb2\
        libtbb-dev\
        libopenimageio2.2\
        libopenimageio-dev

sudo pip install numpy
WD=`pwd`

#if there is a .done-file then skip this step
if [ ! -e $0.done ]; then
   cd $HOME
   mkdir -p openmc
   cd openmc
   mkdir -p embree
   cd embree
   if [ ! -e embree ]; then
      git clone --single-branch --branch v3.13.3 --depth 1 https://github.com/embree/embree.git
   else
      cd embree
      git checkout v3.13.3
      git fetch
      git pull
      cd ..
   fi
   mkdir -p build
   cd build
   cmake ../embree -DCMAKE_INSTALL_PREFIX=$HOME/openmc/embree \
                -DEMBREE_ISPC_SUPPORT=OFF \
                -DEMBREE_TUTORIALS=OFF
   make -j $ccores
   make install

   cd ${WD}
   touch ${0}.done
else
   name=`basename $0`
   echo embree appears to already be installed \(lock file ${name}.done exists\) - skipping.
fi
