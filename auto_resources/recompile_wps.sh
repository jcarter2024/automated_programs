#$-cwd

#We should be in the same directory as Build_WRF\
bw_dir=$1 #the location where Build_WRF is found (and built)\
cd $bw_dir

cd WPS
export WRF_DIR=../WRF/

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

