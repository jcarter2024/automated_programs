#!/bin/bash
#$-cwd
#this script should download data for you. For now we will support GFS. 

#Example
#! /bin/csh -f
#
# c-shell script to download selected files from rda.ucar.edu using Wget
# NOTE: if you want to run under a different shell, make sure you change
#       the 'set' commands according to your shell's syntax
# after you save the file, don't forget to make it executable
#   i.e. - "chmod 755 <name_of_script>"
#
# Experienced Wget Users: add additional command-line flags here
#   Use the -r (--recursive) option with care
##set opts = "-N"
#
#set cert_opt = ""
# If you get a certificate verification error (version 1.10 or higher),
# uncomment the following line:
##set cert_opt = "--no-check-certificate"
#
# download the file(s)
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191129/gfs.0p25.2019112912.f000.grib2
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191129/gfs.0p25.2019112918.f000.grib2
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191130/gfs.0p25.2019113000.f000.grib2
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191130/gfs.0p25.2019113006.f000.grib2
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191130/gfs.0p25.2019113012.f000.grib2
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191130/gfs.0p25.2019113018.f000.grib2
#wget $cert_opt $opts https://data.rda.ucar.edu/ds084.1/2019/20191201/gfs.0p25.2019120100.f000.grib2
 
# Code should iterate through dates, I just don't have the time to do this right now...

read -p "enter start year (4 digit) and month (2 digit) and day (2 digit) separated by a space " s_year s_month s_day 
read -p "enter start time, either 00, 06, 12, 18" s_hour

read -p "enter end year (4 digit) and month (2 digit) and day (2 digit) separated by a space " e_year e_month e_day 
read -p "enter end time, either 00, 06, 12, 18" e_hour  


http="https://data.rda.ucar.edu/ds084.1/${year}/${year}${month}${day}/gfs.0p25.${year}${month}${day}12.f000.grib2"
echo $http


