#!/bin/bash
# the current directory is automated_programs/

#To do
#        --> This script handles a full build of wrf 
#        CALLS:
#		recompile_wrf.sh
#		recompile_wps.sh

############### 1. Build libraries from scratch?
#call functions
source auto_resources/library_functions.sh

# check if Build_WRF exists
echo "========================================="
echo "       Checking your WRF build..."
echo "========================================="

cd ../
echo "making Build_WRF in $pwd"
mkdir Build_WRF
cd Build_WRF/
bw_dir=$(pwd) #the location where Build_WRF is found (and built)\

mkdir WRF
mkdir WPS
mkdir wrf_libs_intel

lib_dir=$bw_dir/wrf_libs_intel/
echo $lib_dir
echo "                 ===============    "
echo "                  FILE structure    "
echo "                 ===============    "
echo " -->>              Git directory    "
echo "                        |           "
echo "               Build_WRF (bw_dir)    "
echo "                /       |       \   "
echo "             WPS-------WRF----wrf_libs_intel"


export CC=icc
export FC=ifort
export F90=ifort
export CXX=icpc

Test="n" ############# Temporary break for testing purposes\
if [ $Test != "y" ]; then
#Now build libraries
build_zlib $lib_dir
build_libpng $lib_dir
build_hdf5 $lib_dir
build_netcdf $lib_dir
cmake_jasper $lib_dir
#build_jasper $lib_dir
fi

export NETCDF=$bw_dir/wrf_libs_intel/
export HDF5=$bw_dir/wrf_libs_intel/
export JASPERLIB=$bw_dir/wrf_libs_intel/lib/
export JASPERINC=$bw_dir/wrf_libs_intel/include/


#Now we will build wrf
cd $bw_dir
#wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
#tar xvf v4.5.2.tar.gz >& wrftar.txt
#rm v4.5.2.tar.gz
#rm wrftar.txt
#mv WRFV4.5.2/* WRF/
#rm -rf WRFV4.5.2

#The following grabs the latest wrf
https://github.com/wrf-model/WRF/releases/download/v4.6.0/v4.6.0.tar.gz
tar xvf v4.6.0.tar.gz >& wrftar.txt
rm v4.6.0.tar.gz
rm wrftar.txt
mv WRFV4.6.0/* WRF/
rm -rf WRFV4.6.0
#----------------------------- MUST be chmod u+x'd\
. ../automated_programs/auto_resources/recompile_wrf.sh $bw_dir
#-----------------------------

#now build WPS
wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz
tar xvf v4.5.tar.gz >& wpstar.txt
rm v4.5.tar.gz
rm wpstar.txt
mv WPS-4.5/* WPS/
rm -rf WPS-4.5/


#----------------------------- MUST be chmod u+x'd
. ../automated_programs/auto_resources/recompile_wps.sh $bw_dir
#-----------------------------

#fi}
