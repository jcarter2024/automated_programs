#!/bin/bash
#$-cwd

#should be in /WRF
bw_dir="$(pwd)/Build_WRF" #the location where Build_WRF is found (and built)

#not convinced the following is needed, but what have we got to lose? 
export LD_LIBRARY_PATH="$bw_dir/wrf_libs_intel/lib:$LD_LIBRARY_PATH"
export LDFLAGS="-L/$bw_dir/wrf_libs_intel/lib"
export CPPFLAGS="-I/$bw_dir/wrf_libs_intel/include"

#here we go...
module load intel/compiler/64/2019/19.0.4

export CC=icc
export FC=ifort
export F90=ifort
export CXX=icpc
export NETCDF=$bw_dir/wrf_libs_intel/
export HDF5=$bw_dir/wrf_libs_intel/

#the following may be needed if recompiling WPS (not needed for registry change)
export WRF_DIR=../WRF/
export JASPERLIB=$bw_dir/wrf_libs_intel/lib/
export JASPERINC=$bw_dir/wrf_libs_intel/include/
