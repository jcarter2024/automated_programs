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
export LDFLAGS="-L$bw_dir/wrf_libs_intel/lib"
export CPPFLAGS="-I$bw_dir/wrf_libs_intel/include"

export NETCDF=$bw_dir/wrf_libs_intel/
export HDF5=$bw_dir/wrf_libs_intel/

#the following may be needed if recompiling WPS (not needed for registry change)
export JASPERLIB=$bw_dir/wrf_libs_intel/lib/
export JASPERINC=$bw_dir/wrf_libs_intel/include/


###################
echo $bw_dir
echo $CC 
echo $F90
echo $CXX
echo $FC
echo $FCFLAGS
echo $F77
echo $FFLAGS
echo $JASPERLIB
echo $JASPERINC
echo $LDFLAGS
echo $CPPFLAGS
echo $NETCDF
echo $HDF5

############ Recompile starts ##############
./clean
./configure -D

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

#copy the slurms over to the WRF directory
slurm_path=$(realpath "../automated_programs/auto_resources/Slurm_scripts")
echo $slurm_path

cp $slurm_path/real_slurm $bw_dir/WRF/
cp $slurm_path/wrf_slurm $bw_dir/WRF/

#edit the slurm to reflect the WRF_DIR? Not needed
#mod1="WRF_DIR = $WRF_DIR"\
mod2="bw_dir = $bw_dir"
#sed -i "s/^WRF_DIR.*/${mod1}/" $bw_dir/WRF/real_slurm
#sed -i "s/^WRF_DIR.*/${mod1}/" $bw_dir/WRF/wrf_slurm
sed -i "s/^bw_dir=.*/${mod2}/" $bw_dir/WRF/real_slurm
sed -i "s/^bw_dir=.*/${mod2}/" $bw_dir/WRF/wrf_slurm
