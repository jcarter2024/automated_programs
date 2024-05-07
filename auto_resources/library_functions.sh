#!/bin/bash
#$-cwd

#To do
#        --> This script contains library building functions

####### FUNCTIONS ############################

build_zlib() {
    wget https://zlib.net/fossils/zlib-1.2.11.tar.gz
    tar xvf zlib-1.2.11.tar.gz >& zlibtar.log
    cd zlib-1.2.11/
    ./configure --prefix="$1/wrf_libs_intel/" >& zlibconfig.txt
    echo "Making zlib..."
    make >& zlibmake.log
    make install >& zlibinstall.log
    #check it worked
    if [ ! -f $bw_dir/wrf_libs_intel/include/zlib.h ]; then
        echo "zlib build error"
        kill -INT $$
    else
        echo "cleaning up"
        cd ../
        rm zlib-1.2.11.tar.gz
        rm -r zlib-1.2.11
        rm zlibtar.log
    fi
}


build_libpng () {
  wget https://downloads.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz
    xz -d -v libpng-1.6.37.tar.xz >& libpngxz.log
    tar xvf libpng-1.6.37.tar >& libpngtar.log
    cd libpng-1.6.37/
    ./configure --prefix="$1/wrf_libs_intel/" >& libpngconfig.txt
    echo "Making libpng..."
    make >& libpngmake.log
    make install >& libpnginstall.log
    if [ ! -f $bw_dir/wrf_libs_intel/include/libpng16/pnglibconf.h ]; then
        echo "libpng build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm libpng-1.6.37.tar.xz
        rm libpng-1.6.37.tar
        rm -r libpng-1.6.37
        rm libpngtar.log
        rm libpngxz.log
    fi
}

build_hdf5 () {
    wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_0/source/hdf5-1.12.0.tar.gz 
    tar xvf hdf5-1.12.0.tar.gz >& hdf5tar.log
    cd hdf5-1.12.0
    ./configure --prefix=$1/wrf_libs_intel/ --with-zlib=$1/wrf_libs_intel/ --enable-fortran >& hdf5config.txt
    echo "Making HDF5..."
    make >& hdf5make.log
    make install >& hdf5install.log
    if [ ! -f $bw_dir/wrf_libs_intel/include/H5FDcore.h ]; then
    echo "libpng build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm hdf5-1.12.0.tar.gz
        rm -r hdf5-1.12.0
        rm hdf5tar.log
    fi
}

build_netcdf () {
    #both netcdf and netcdf fortran are required
    wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
    tar xvf netcdf-c-4.9.2.tar.gz >& netcdftar.log
    cd netcdf-c-4.9.2
    export LD_LIBRARY_PATH="$1/wrf_libs_intel/lib:$LD_LIBRARY_PATH"
    export LDFLAGS="-L/$1/wrf_libs_intel/lib"
    export CPPFLAGS="-I/$1/wrf_libs_intel/include"
    ./configure --prefix=$1/wrf_libs_intel/ --disable-byterange >& netcdfconfig.txt
    echo "Making NETCDF..."
    make >& netcdfmake.log
    make install >& netcdfinstall.log
    if [ ! -f $bw_dir/wrf_libs_intel/include/zlib.h ]; then
    echo "libpng build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm netcdf-c-4.9.2.tar.gz
        rm -r netcdf-c-4.9.2
        rm netcdftar.log
    fi

    wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
    tar xvf netcdf-fortran-4.6.1.tar.gz >& netcdfFtar.log
    cd netcdf-fortran-4.6.1  
    ./configure --prefix=$1/wrf_libs_intel/  >& netcdfFconfig.txt
    echo "Making NETCDF (Fortran)..."
    make >& netcdfFmake.log
    make install >& netcdfFinstall.log
    if [ ! -f $1/wrf_libs_intel/include/zlib.h ]; then
    echo "libpng build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm netcdf-fortran-4.6.1.tar.gz
        rm -r netcdf-fortran-4.6.1
        rm netcdfFtar.log
        rm netcdfFmake.log
        rm netcdfFinstall.log
        rm netcdfFconfig.txt
    fi
}

build_jasper () {
    wget https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz
    tar xvf jasper-1.900.29.tar.gz >& jaspertar.log
    cd jasper-1.900.29/
    ./configure --prefix="$1/wrf_libs_intel/" >& jasperconfig.txt
    echo "Making jasper..."
    make >& jaspermake.log
    make install >& jasperinstall.log
    if [ ! -f $bw_dir/wrf_libs_intel/include/zlib.h ]; then
    echo "libpng build error"
        kill -INT $$
    else
        cd ../
        echo "cleaning up"
        rm jasper-1.900.29.tar.gz
        rm -r jasper-1.900.29
        rm jaspertar.log
    fi
}

