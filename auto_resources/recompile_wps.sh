{\rtf1\ansi\ansicpg1252\cocoartf2759
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/bin/bash\
#$-cwd\
\
#We should be in the same directory as Build_WRF\
bw_dir=$1 #the location where Build_WRF is found (and built)\
cd $bw_dir\
\
cd WPS\
export WRF_DIR=../WRF/\
\
export JASPERLIB=$bw_dir/wrf_libs_intel/lib/\
export JASPERINC=$bw_dir/wrf_libs_intel/include/\
\
./configure\
#Choose 17 serial intel \
\
./compile 2>&1 | tee compile.log\
\
#Check you have linked executables with \
ls -rlt\
\
#modify the static library path \
mod3=" geog_data_path = \\'\\/gpfs\\/software\\/WRF\\/4.4.2\\/WPS_GEOG\\/\\'"\
sed -i "s/^ geog_data_path.*/$mod3/" namelist.wps\
\
cd $bw_dir\
}