#!/bin/bash
#$-cwd

#handy func for cd

verbose_cd() {
    printf "\nLeaving $(pwd)\n"
    cd $1
    printf "\nEntering $(pwd)\n"
}

mktitle() {
    printf "\n************* --> $1 <-- *************\n"
}

source library_functions.sh
source recompile_wrf.sh
source recompile_wps.sh

#########################################
########## B U I L D  T R E E  ##########
#########################################

echo "making Build_WRF in $(pwd)"
mkdir Build_WRF
verbose_cd Build_WRF/
mkdir WRF
mkdir WPS
mkdir wrf_libs_intel

module load intel/compiler/64/2019/19.0.4
module load intel/mkl/64/2019/19.0.4
module load intel/mpi/64/2019/19.0.4

bw_dir=$(pwd)
lib_dir=$bw_dir/wrf_libs_intel
export CC=icc
export FC=ifort
export F90=ifort
export CXX=icpc
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export JASPERLIB=$bw_dir/wrf_libs_intel/lib
export JASPERINC=$bw_dir/wrf_libs_intel/include
export LDFLAGS=-L$bw_dir/wrf_libs_intel/lib
export CPPFLAGS=-I$bw_dir/wrf_libs_intel/include

echo "bw_dir: $bw_dir"
echo "lib_dir: $lib_dir"
echo "CC: $CC"
echo "FC: $FC"
echo "F90: $F90"
echo "CXX: $CXX"
echo "FCFLAGS: $FCFLAGS"
echo "F77: $F77"
echo "FFLAGS: $FFLAGS"
echo "JASPERLIB: $JASPERLIB"
echo "JASPERINC: $JASPERINC"
echo "LDFLAGS: $LDFLAGS"
echo "CPPFLAGS: $CPPFLAGS"

###################################################
########## B U I L D  L I B R A R I E S  ##########
###################################################


build_zlib $lib_dir
build_libpng $lib_dir
build_hdf5 $lib_dir
build_netcdf $lib_dir
cmake_jasper $lib_dir


###########################################
########## C O M P I L E  W R F  ##########
###########################################

build_wrf $bw_dir 
recompile_wrf $bw_dir 

###########################################
########## C O M P I L E  W P S  ##########
###########################################

build_wps $bw_dir 
recompile_wps $bw_dir 








