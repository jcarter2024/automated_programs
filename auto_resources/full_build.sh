{\rtf1\ansi\ansicpg1252\cocoartf2759
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
#$-cwd\
\
#To do\
#        --> This script handles a full build of wrf \
#        CALLS:\
#		recompile_wrf.sh\
#		recompile_wps.sh\
\
############### 1. Build libraries from scratch?\
\
# check if Build_WRF exists\
echo "========================================="\
echo "       Checking your WRF build..."\
echo "========================================="\
\
cd ../ #<\'97 we now live in the auto_resources folder\
mkdir Build_WRF\
cd Build_WRF/\
bw_dir=$(pwd) #the location where Build_WRF is found (and built)\
\
mkdir WRF\
mkdir WPS\
mkdir wrf_libs_intel\
\
echo "                 ===============    "\
echo "                  FILE structure    "\
echo "                 ===============    "\
echo " -->>              Git directory    "\
echo "                        |           "\
echo "               Build_WRF (bw_dir)    "\
echo "                /       |       \\   "\
echo "             WPS-------WRF----wrf_libs_intel"\
\
#call functions\
source library_functions\
\
export CC=icc\
export FC=ifort\
export F90=ifort\
export CXX=icpc\
\
#Now build libraries\
build_zlib $bw_dir\
build_libpng $bw_dir\
build_hdf5 $bw_dir\
build_netcdf $bw_dir\
build_jasper $bw_dir\
\
#Test="y" ############# Temporary break for testing purposes\
#if [ $Test != "y" ]; then\
\
export NETCDF=$bw_dir/wrf_libs_intel/\
export HDF5=$bw_dir/wrf_libs_intel/\
\
#Now we will build wrf\
cd $bw_dir\
wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz\
tar xvf v4.5.2.tar.gz\
rm v4.5.2.tar.gz\
mv WRFV4.5.2/* WRF/\
rm -rf WRFV4.5.2\
\
#----------------------------- MUST be chmod u+x'd\
. auto_resources/recompile_wrf.sh $bw_dir\
#-----------------------------\
\
#now build WPS\
wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz\
tar xvf v4.5.tar.gz\
rm v4.5.tar.gz\
mv WPS-4.5/* WPS/\
rm -rf WPS-4.5/\
\
\
#----------------------------- MUST be chmod u+x'd\
. auto_resources/recompile_wps.sh $bw_dir\
#-----------------------------\
\
#fi}