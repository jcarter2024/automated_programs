#!/bin/bash

#To do
# OPTIONAL -- Add support for ADIOS2
#        --> This script contains library building functions

########################### VERSIONS ##########################

#The package id chooses a group of working library combinations, 0 is old (working), 1 is more modern (untested)
#NOTE netcdf and jasper are duplicated as already operating at latest version
package_id=0

# ------ ZLIB
zlib_urls=( https://zlib.net/fossils/zlib-1.2.11.tar.gz https://zlib.net/zlib-1.3.1.tar.gz )

# ------ libpng
libpng_urls=( https://downloads.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz https://sourceforge.net/projects/libpng/files/libpng16/1.6.43/libpng-1.6.43.tar.xz )

# ------ hdf5
hdf5_urls=( https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_0/source/hdf5-1.12.0.tar.gz https://github.com/HDFGroup/hdf5/releases/download/hdf5_1.14.4.3/hdf5-1.14.4-3.tar.gz )

# ------ netcdf
netcdf_urls=( https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz )

# ------ netcdf_Fortran
netcdfF_urls=( https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz )

# ------ jasper
jasper_urls=( https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz https://github.com/jasper-software/jasper/archive/refs/tags/version-4.2.4.tar.gz )

zlib_url=${zlib_urls[$package_id]}
libpng_url=${libpng_urls[$package_id]}
hdf5_url=${hdf5_urls[$package_id]}
netcdf_url=${netcdf_urls[$package_id]}
netcdfF_url=${netcdfF_urls[$package_id]}
jasper_url=${jasper_urls[$package_id]}

# ------- strip the version to install correctly
zlib_tar="${zlib_url##*/}"
zlib_v=(${zlib_tar//".tar"/ })

libpng_tar="${libpng_url##*/}"
libpng_v=(${libpng_tar//".tar"/ })

hdf5_tar="${hdf5_url##*/}"
hdf5_v=(${hdf5_tar//".tar"/ })

netcdf_tar="${netcdf_url##*/}"
netcdf_v=(${netcdf_tar//".tar"/ })

netcdfF_tar="${netcdfF_url##*/}"
netcdfF_v=(${netcdfF_tar//".tar"/ })

jasper_tar="${jasper_url##*/}"
jasper_v=(${jasper_tar//".tar"/ })


####### FUNCTIONS ############################

build_zlib() {
    wget $zlib_url
    tar xvf $zlib_tar >& zlibtar.log
    cd $zlib_v
    ./configure --prefix=$1 >& zlibconfig.txt
    echo "Making zlib..."
    make >& zlibmake.log
    make install >& zlibinstall.log
    #check it worked
    if [ ! -f $1include/zlib.h ]; then
        echo "zlib build error"
        kill -INT $$
    else
        echo "cleaning up"
        cd ../
        rm $zlib_tar
        rm -r $zlib_v
        rm zlibtar.log
    fi
}
#build_zlib "/Users/joshuacarter/Desktop/bashtestingdelete/intel_test/"

build_libpng() {
    wget $libpng_url
    tar xvf $libpng_tar >& libpngtar.log
    cd $libpng_v
    ./configure --prefix=$1 >& libpngconfig.txt
    echo "Making libpng..."
    make >& libpngmake.log
    make install >& libpnginstall.log
    #check it worked
    if [ ! -f $1include/pngconf.h ]; then
        echo "libpng build error"
        kill -INT $$
    else
        echo "cleaning up"
        cd ../
        rm $libpng_tar
        rm -r $libpng_v
        rm libpngtar.log
    fi
}
#build_libpng "/Users/joshuacarter/Desktop/bashtestingdelete/intel_test/"

build_hdf5() {
    wget $hdf5_url
    tar xvf $hdf5_tar >& hdf5tar.log
    cd $hdf5_v
    ./configure --prefix=$1 --with-zlib=$1 --enable-fortran >& hdf5config.txt
    echo "Making HDF5..."
    make >& hdf5make.log
    make install >& hdf5install.log
    if [ ! -f $1include/H5FDcore.h ]; then
        echo "hdf5 build error"
        kill -INT $$
    else
        echo "cleaning up"
        cd ../
        rm $hdf5_tar
        rm -r $hdf5_v
        rm hdf5tar.log
    fi
}
#build_hdf5 "/Users/joshuacarter/Desktop/bashtestingdelete/intel_test/"

build_netcdf () {
    wget $netcdf_url
    tar xvf $netcdf_tar >& netcdftar.log
    echo $netcdf_v
    cd $netcdf_v
    pwd
    export LD_LIBRARY_PATH="$1lib:$LD_LIBRARY_PATH"
    export LDFLAGS="-L$1lib"
    export CPPFLAGS="-I$1include"
    ./configure --prefix=$1 --disable-byterange >& netcdfconfig.txt
    echo "Making NETCDF..."
    make >& netcdfmake.log
    make install >& netcdfinstall.log
    if [ ! -f $1include/netcdf.h ]; then
    echo "netcdf build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm $netcdf_tar
        rm -r $netcdf_v
        rm netcdftar.log
    fi

    wget $netcdfF_url
    tar xvf $netcdfF_tar >& netcdfFtar.log
    cd $netcdfF_v  
    ./configure --prefix=$1  >& netcdfFconfig.txt
    echo "Making NETCDF (Fortran)..."
    make >& netcdfFmake.log
    make install >& netcdfFinstall.log
    if [ ! -f $1include/netcdf_nf_interfaces.mod ]; then
    echo "netcdf Fortran build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm $netcdfF_tar
        rm -r $netcdfF_v
        rm netcdfFtar.log
    fi
}

cmake_jasper () {
    wget $jasper_url
    tar xvf $jasper_tar >& jaspertar.log
    #create a temporary build directory because cmake things
    mkdir BUILD
    BUILD_DIR=$(pwd)/BUILD
    echo $BUILD_DIR
    cd "jasper-$jasper_v"
    #Must include LIBDIR or will install by default in lib64
    cmake  -B$BUILD_DIR -DCMAKE_INSTALL_PREFIX=$1 -DCMAKE_INSTALL_LIBDIR=lib
    cmake --build $BUILD_DIR
    cmake --build $BUILD_DIR --target install
    if [ ! -f $1include/jasper/jasper.h ]; then
    echo "jasper build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm $jasper_tar
        rm -r "jasper-$jasper_v"
        rm -r BUILD
        rm jaspertar.log
    fi
}

build_jasper () {
    wget $jasper_url
    tar xvf $jasper_tar >& jaspertar.log
    cd $jasper_v
    ./configure --prefix="$1" >& jasperconfig.txt
    echo "Making jasper..."
    make >& jaspermake.log
    make install >& jasperinstall.log
    if [ ! -f $1include/jasper/jasper.h ]; then
    echo "jasper build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm $jasper_tar
        rm -r $jasper_v
        rm jaspertar.log
    fi
}

