#!/bin/bash

#We should be in the same directory as Build_WRF
bw_dir=$1 #the location where Build_WRF is found (and built)
cd $bw_dir

cd WRF/

######## Code start #####################
#for 2019 set up (works as of May 6 2024)
module load intel/compiler/64/2019/19.0.4
module load intel/mkl/64/2019/19.0.4
module load intel/mpi/64/2019/19.0.4

######### Export library paths etc #######
export CC=icc
export FC=ifort
export F90=ifort
export CXX=icpc

#not convinced the following is needed, but what have we got to lose? 
export LD_LIBRARY_PATH="$bw_dir/wrf_libs_intel/lib:$LD_LIBRARY_PATH"
export LDFLAGS="-L/$bw_dir/wrf_libs_intel/lib"
export CPPFLAGS="-I/$bw_dir/wrf_libs_intel/include"

export NETCDF=$bw_dir/wrf_libs_intel/
export HDF5=$bw_dir/wrf_libs_intel/

#the following may be needed if recompiling WPS (not needed for registry change)
export JASPERLIB=$bw_dir/wrf_libs_intel/lib/
export JASPERINC=$bw_dir/wrf_libs_intel/include/


############ Recompile starts ##############
./clean
./configure

# Edit configure.wrf file here
mod1='DM_FC           =       mpiifort'
mod2='DM_CC           =       mpiicc'
sed -i "s/^DM_FC.*/${mod1}/" configure.wrf
sed -i "s/^DM_CC.*/${mod2}/" configure.wrf

# Source mpi variables for compiler
source /gpfs/software/intel/parallel-studio-xe/2019_4/bin/compilervars.sh -arch intel64

# now compile
./compile -j 4 em_real 2>&1 | tee compile.log 

cd $bw_dir