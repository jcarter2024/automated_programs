#!/bin/bash
#$-cwd

# Ensure that the user has edited the namelist.wps file, and run geogrid.exe succesfully
read -p "Have you edited the namelist.wps file and run Geogrid?  : " ans 
    case $ans in 
	    [Yy] ) echo "recognised"; module load slurm; sbatch complete_wps_slurm;;
	    [Nn] ) echo " Complete these actions and re-run this script"  ;;
    esac

