#!/bin/bash

# MIT License

# Copyright (c) 2024 Amirhossein Nikfal

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of the GFS Download Manager and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# When using or redistributing the Software in whole or in part,
# you are required to include a citation to the following paper:
# Nikfal, A. and Karimi, M.A., 2024. Operational workflow to simulate biophysical variables, based on the coupled WRF/SEBAL models. Computers and Electronics in Agriculture, 222, p.109003.

###################################### INPUT VARIABLES ######################################
start_year=2024     #Year of the start of the run
start_month=6      #Month of the start of the run
start_day=28        #Day of the start of the run
total_run_hours=36  #Total run hours
gfs_start_hour=12    # Choosable values: 0, 6, 12, or 18
gfs_hour_interval=3 #Temporal resolution for the forecast intervals in hour (eg. 3 or 6 hours)
#############################################################################################

echo "Start of the program:" >log
date >>log
echo "#########################################################" >>log
echo "" >>log
check_gfs_start_hour() {
    valid_set=(0 6 12 18)
    local start_hour=$1
    for valid_hour in "${valid_set[@]}"; do
        if [[ "$start_hour" -eq "$valid_hour" ]]; then
            return 1
        fi
    done
    return 0
}
if check_gfs_start_hour $((10#$gfs_start_hour)); then
    echo "Warning: gfs_start_hour should be among 0, 6, 12, or 18"
    echo Exiting ..
    exit
fi
start_month=$(printf "%02d\n" $start_month)
start_day=$(printf "%02d\n" $start_day)
gfs_start_hour=$(printf "%02d\n" $gfs_start_hour)
echo Looking for GFS data. Please wait a few seconds ..
for ii in $(seq -f "%03g" 0 $gfs_hour_interval $total_run_hours); do
  urls+=("ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$start_year$start_month$start_day"/$gfs_start_hour"/atmos/gfs.t"$gfs_start_hour"z.pgrb2.0p50.f$ii")
  gfsnames+=(gfs.t"$gfs_start_hour"z.pgrb2.0p50.f$ii)
done
for url in ${urls[*]}; do
  wget -S --spider $url 2>outwget
  nofile=$(grep "No such file" outwget)
  nosignal=$(grep "unable to resolve host address" outwget)
  echo "#############################" >>log
  echo "nofile is: " $nofile >>log
  echo "nosignal is: " $nosignal >>log
  if [[ -z $nofile && -z $nosignal ]]; then
    echo Data Found: $url
    echo Data Found: $url >>log
    date >>log
    echo "" >>log
    wget -np -nv -c $url &
  else
    until [[ -z $nofile && -z $nosignal ]]; do
      echo Retrying $url >>log
      date >>log
      echo "" >>log
      if [[ ! -z $nofile ]]; then
        sleep 60
      fi
      wget -S --spider $url 2>outwget
      nofile=$(grep "No such file" outwget)
      nosignal=$(grep "unable to resolve host address" outwget)
    done
    echo 2Data Found: $url >>log
    date >>log
    echo "" >>log
    wget -np -nv -c $url &
  fi
done #for loop
wait #wait for all background jobs to terminate

#Finding and downloading the missing files
rm gfslist0 2>/dev/null
ls gfs.t"$gfs_start_hour"z* >gfslist
for gfsf in ${gfsnames[*]}; do
  echo $gfsf >>gfslist0
done
diff gfslist0 gfslist | grep "<" | cut -d" " -f2 >difflist
readarray -t allmissings <difflist
echo All missing files: ${allmissings[@]}
until [[ -z $allmissings ]]; do
  echo "#########################################################" >>log
  echo "Downloading missing files: " >>log
  date >>log
  echo "" >>log
  for missedfile in ${allmissings[*]}; do
    wget -np -nv -c "ftp://ftp.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.$start_year$start_month$start_day"/$gfs_start_hour"/atmos/"$missedfile &
    echo Downloading: $missedfile >>log
    if [[ $missedfile == ${allmissings[${#allmissings[@]} - 1]} ]]; then #for older bash (version 4.2 and eralier)
      wait
    fi
  done #for loop
  ls gfs.t"$gfs_start_hour"z* >gfslist
  diff gfslist0 gfslist | grep "<" | cut -d" " -f2 >difflist
  readarray -t allmissings <difflist
done

rm outwget gfslist gfslist0 difflist 2>/dev/null
echo "" >>log
echo "#########################################################" >>log
echo "End of the program:" >>log
date >>log
mv log log$start_year$start_month$start_day 2>/dev/null