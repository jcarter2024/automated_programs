#!bin/bash

build_wps() {
#now build WPS
verbose_cd $1
wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.5.tar.gz
tar xvf v4.5.tar.gz >& wpstar.txt
rm v4.5.tar.gz
rm wpstar.txt
mv WPS-4.5/* WPS/
rm -rf WPS-4.5/
}

recompile_wps() {
bw_dir=$1
WRF_DIR=$bw_dir/WRF

verbose_cd $bw_dir/WPS
echo 17 | ./configure
#Choose 17 serial intel 

./compile 2>&1 | tee compile.log

#Check you have linked executables with 
ls -rlt

#modify the static library path 
mod3=" geog_data_path = \'\/gpfs\/software\/WRF\/4.4.2\/WPS_GEOG\/\'"
sed -i "s/^ geog_data_path.*/$mod3/" namelist.wps

verbose_cd $bw_dir

#copy the slurms over to the WPS directory
slurm_path=$(realpath "../Slurm_scripts")
echo $slurm_path

#NOTE --> The ungrib wrf path will likely need to be changed!
cp $slurm_path/geogrid_slurm $bw_dir/WPS/
cp $slurm_path/ungrib_slurm $bw_dir/WPS/
cp $slurm_path/metgrid_slurm $bw_dir/WPS/
#Now we have a unified post-geogrid wps script that auto submits a wps_slurm
cp $slurm_path/complete_wps_slurm $bw_dir/WPS/
cp $slurm_path/post_geogrid.sh $bw_dir/WPS/


#edit the slurm to reflect the WRF_DIR
mod1="export WRF_DIR=$WRF_DIR/"
mod2="bw_dir=$bw_dir"
sed -i "s~^export WRF_DIR.*~${mod1}~" $bw_dir/WPS/ungrib_slurm
sed -i "s~^export WRF_DIR.*~${mod1}~" $bw_dir/WPS/metgrid_slurm
sed -i "s~^bw_dir=.*~${mod2}~" $bw_dir/WPS/ungrib_slurm
sed -i "s~^bw_dir=.*~${mod2}~" $bw_dir/WPS/metgrid_slurm
}
