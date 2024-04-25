#!/bin/bash
#$-cwd

# Based off a previous script and the current WRF build. Untested. 
#To do:
#	. Switch the path in each library build function for more flexibility


####### FUNCTIONS ############################

build_zlib() {
    wget https://zlib.net/fossils/zlib-1.2.11.tar.gz
    tar xvf zlib-1.2.11.tar.gz >& zlibtar.log
    cd zlib-1.2.11/
    ./configure --prefix="$1/wrf_libs_intel/
    echo "Making zlib..."
    make >& zlibmake.log
    make install >& zlibinstall.log
    echo "cleaning up"
    rm zlib-1.2.11.tar.gz
    rm -r zlib-1.2.11
}


build_libpng () {
  wget https://downloads.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz
    xz -d -v libpng-1.6.37.tar.xz >& libpngxz.log
    tar xvf libpng-1.6.37.tar >& libpngtar.log
    cd libpng-1.6.37/
    ./configure --prefix="$1/wrf_libs_intel/"
    echo "Making libpng..."
    make >& libpngmake.log
    make install >& libpnginstall.log
    cd ../
    echo "cleaning up"
    rm libpng-1.6.37.tar.gz
    rm -r libpng-1.6.37
}

build_hdf5 () {
    wget https://hdf-wordpress-1.s3.amazonaws.com/wp-content/uploads/manual/HDF5/HDF5_1_12_0/source/hdf5-1.12.0.tar.gz 
    tar xvf hdf5-1.12.0.tar.gz
    cd hdf5-1.12.0
    ./configure --prefix="$1/wrf_libs_intel/"
    echo "Making HDF5..."
    make >& hdf5make.log
    make install >& hdf5install.log
    cd ../
    echo "cleaning up"
    rm hdf5-1.12.0.tar.gz
    rm -r hdf5-1.12.0
}

build_netcdf () {
    #both netcdf and netcdf fortran are required
    wget https://downloads.unidata.ucar.edu/netcdf-c/4.9.2/netcdf-c-4.9.2.tar.gz
    tar xvf netcdf-c-4.9.2.tar.gz
    cd netcdf-c-4.9.2
    export LD_LIBRARY_PATH="$1/wrf_libs_intel/lib:$LD_LIBRARY_PATH
    export LDFLAGS="-L/$1/wrf_libs_intel/lib"
    export CPPFLAGS="-I/$1/wrf_libs_intel/include"
    ./configure --prefix=/gpfs/home/jjcarter/wrf/wrf_libs_intel/ --disable-byterange
    echo "Making NETCDF..."
    make >& netcdfmake.log
    make install >& netcdfinstall.log
    cd ../
    echo "cleaning up"
    rm netcdf-c-4.9.2.tar.gz
    rm -r netcdf-c-4.9.2
    wget https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.1/netcdf-fortran-4.6.1.tar.gz
    tar netcdf-fortran-4.6.1.tar.gz
    cd netcdf-fortran-4.6.1  
    ./configure --prefix=/gpfs/home/jjcarter/wrf/wrf_libs_intel/
    echo "Making NETCDF (Fortran)..."
    make >& netcdfFmake.log
    make install >& netcdfFinstall.log
    cd ../
    echo "cleaning up"
    rm netcdf-fortran-4.6.1
    rm -r netcdf-fortran-4.6.1
}

get_jasper () {
    wget https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz
    tar xvf jasper-1.900.29.tar.gz >& jaspertar.log
    cd jasper-1.900.29/
    ./configure --prefix="$1/wrf_libs_intel/"
    echo "Making jasper..."
    make >& jaspermake.log
    make install >& jasperinstall.log
    cd ../
    echo "cleaning up"
    rm jasper-1.900.29.tar.gz
    rm -r jasper-1.900.29
}

######## Code start #####################

module load intel/compiler/64/2019/19.0.4
export CC=icc
export FC=ifort
export F90=ifort
export CXX=icpc

# STEP 1: check if Build_WRF exists
echo "========================================="
echo "       Checking your WRF build..."
echo "========================================="

mkdir Build_WRF
cd Build_WRF/
bw_dir=$(pwd) #the location where Build_WRF is found (and built)

mkdir WRF
mkdir WPS
mkdir wrf_libs_intel

echo "                 ===============    "
echo "                  FILE structure    "
echo "                 ===============    "
echo " -->>              Git directory    "
echo "                        |           "
echo "               Build_WRF $bw_dir    "
echo "                /       |       \   "
echo "             WPS-------WRF----wrf_libs_intel"



#Now build libraries
build_zlib $bw_dir
build_libpng $bw_dir
build_hdf5 $bw_dir
build_netcdf $bw_dir
build_jasper $bw_dir

export NETCDF=$1/wrf_libs_intel/
export HDF5=$1/wrf_libs_intel/

#Now we will build wrf
cd $bw_dir/Build_WRF/
wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
tar xvf v4.5.2/v4.5.2.tar.gz
cd v4.5.2.tar.gz
./configure

#must edit file here

#must source mpi variables for compiler
source /gpfs/software/intel/parallel-studio-xe/2019_4/compilers_and_libraries_2019.4.243/linux/bin/compilervars.sh -arch intel64
#can now compile
./compile -j 4 em_real 2>&1 | tee compile.log
cd ../
rm v4.5.2/v4.5.2.tar.gz

#now build WPS
Wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz
tar xvf v4.5.tar.gz
cd WPS-4.5/
export WRF_DIR=../WRFV4.5.2/

export JASPERLIB=$bw_dir/wrf_libs_intel/lib/
export JASPERINC=$bw_dir/wrf_libs_intel/include/

#Choose 17 serial intel 

./compile 2>&1 | tee compile.log

#Check you have linked executables with 
ls -rlt

cd ../
xvf v4.5.tar.gz
