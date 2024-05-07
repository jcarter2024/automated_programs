#!bin/bash

#We should be in the same directory as Build_WRF\
bw_dir=$1 #the location where Build_WRF is found (and built)\
cd $bw_dir
cd WPS

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

export WRF_DIR=$bw_dir/WRF
export JASPERLIB=$bw_dir/wrf_libs_intel/lib/
export JASPERINC=$bw_dir/wrf_libs_intel/include/

./configure
#Choose 17 serial intel 

./compile 2>&1 | tee compile.log

#Check you have linked executables with 
ls -rlt

#modify the static library path 
mod3=" geog_data_path = \'\/gpfs\/software\/WRF\/4.4.2\/WPS_GEOG\/\'"
sed -i "s/^ geog_data_path.*/$mod3/" namelist.wps

cd $bw_dir

#copy the slurms over to the WPS directory
slurm_path=$(realpath "../automated_programs/auto_resources/Slurm_scripts")
echo $slurm_path

#NOTE --> The ungrib wrf path will likely need to be changed!
cp $slurm_path/ungrib_slurm $bw_dir/WPS/
cp $slurm_path/metgrid_slurm $bw_dir/WPS/


#edit the slurm to reflect the WRF_DIR
mod1="export WRF_DIR = $WRF_DIR/"
sed -i "s~^export WRF_DIR.*~${mod1}~" $bw_dir/WPS/ungrib_slurm
sed -i "s~^export WRF_DIR.*~${mod1}~" $bw_dir/WPS/metgrid_slurm
