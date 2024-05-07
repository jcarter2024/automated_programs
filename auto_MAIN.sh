#!/bin/bash
#$-cwd

#To do
#        --> This script is MAIN, it handles communication and script calls
#	We ASSUME that the current working directory $pwd holds Build_WRF (unless starting from scratch)


#for 2019 set up (works as of May 6 2024)
module load intel/compiler/64/2019/19.0.4
module load intel/mkl/64/2019/19.0.4
module load intel/mpi/64/2019/19.0.4

#Ask the questions 
build_from_scratch=0
recompile_wrf=0
download_data=0
run_cases=0

s_path=auto_resources
bw_dir=$(realpath "../Build_WRF")
echo $bw_dir
while true; do
	read -p "Do you wish to build from scratch-->(a), recompile wrf --> (b), recompile wps--> (c), download data (d), run case (e), exit(x)? " ans
    case $ans in
	[Xx]* ) break ;;   
        [Aa]* ) . $s_path/full_build.sh;; 
        [Bb]* ) . $s_path/recompile_wrf.sh $bw_dir;;
	[Cc]* ) . $s_path/recompile_wps.sh $bw_dir;;
	[Dd]* ) . $s_path/download_data.sh $bw_dir;;
	[Ee]* ) . $s_path/run_case.sh $bw_dir;;
        * ) echo "Please answer choice.";;
    esac
done


