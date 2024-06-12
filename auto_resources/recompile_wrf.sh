#!/bin/bash

build_wrf() {

mktitle "Building WRF"
verbose_cd $1
wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
tar xvf v4.5.2.tar.gz >& wrftar.txt
rm v4.5.2.tar.gz
rm wrftar.txt
mv WRFV4.5.2/* WRF/
rm -rf WRFV4.5.2
}

recompile_wrf() {

mktitle "Compiling WRF"
verbose_cd $1/WRF

./clean
echo 1 | echo 15 | ./configure -D

# Edit configure.wrf file here
mod1='DM_FC           =       mpiifort'
mod2='DM_CC           =       mpiicc'
sed -i "s/^DM_FC.*/${mod1}/" configure.wrf
sed -i "s/^DM_CC.*/${mod2}/" configure.wrf

# Source mpi variables for compiler
source /gpfs/software/intel/parallel-studio-xe/2019_4/bin/compilervars.sh -arch intel64

# now compile
./compile -j 4 em_real 2>&1 | tee compile.log 

verbose_cd $1
#copy the slurms over to the WRF directory
slurm_path=$(realpath "../Slurm_scripts")
echo $slurm_path

cp $slurm_path/real_slurm $1/WRF/
cp $slurm_path/wrf_slurm $1/WRF/

#edit the slurm to reflect the WRF_DIR
mod2="bw_dir = $1"
sed -i "s/^bw_dir=.*/${mod2}/" $bw_dir/WRF/real_slurm
sed -i "s/^bw_dir=.*/${mod2}/" $bw_dir/WRF/wrf_slurm
}
