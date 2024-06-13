#!/bin/bash
module load slurm


read -p "Do you wish to build from scratch-->(a), recompile wrf --> (b), recompile wps--> (c), download data (d), run case (e), exit(x)? " ans

if [[ ans=="a" ]]; then
    cd auto_resources
    sbatch buildwrf_slurm
elif [[ ans=="x" ]]; then
    break
else
    echo "Please answer choice."
fi

