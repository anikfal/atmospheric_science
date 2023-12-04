#!/bin/bash
# Contact person: Amirhossein Nikfal <https://github.com/anikfal>

# Paths to namelist.inpu, MOZBC directory, and WACCM file
##=================================================================================
WRF_namelist_input_file_path=/home/anikfal/WRFTEST/WRF/test/em_real/namelist.input
MOZBC_directory_path=/home/anikfal/WRFTEST/tools/MOZBC
WACCM_data_file_name=waccm-20231101152637411942.nc
##=================================================================================

ls $WRF_namelist_input_file_path 1>/dev/null 2>&1
if [ $? != 0 ]; then
    echo Error:
    echo $WRF_namelist_input_file_path is not valid.
    echo Speficy the correct path to the WRF namelis.input file and run again.
    exit
fi
MOZBC_directory_path=$(echo $MOZBC_directory_path | sed 's:/*$::')
ls $MOZBC_directory_path/mozbc 1>/dev/null 2>&1
if [ $? != 0 ]; then
    echo Error:
    echo $MOZBC_directory_path is not valid. Set the correct path and run again.
    echo The current directory must contain the mozbc executive file.
    exit
fi
ls $PWD/$WACCM_data_file_name 1>/dev/null 2>&1
if [ $? != 0 ]; then
    echo Error:
    echo $WACCM_data_file_name is not a valid file name. Set the correct file-name and run again.
    echo The WACCM file must be in the current directory.
    exit
fi

check_add_var() {
    local wrfvar=$1   #var in wrfinput file
    local waccmvar=$2 #var in waccm file
    grep "float $wrfvar (" wrfinput_vars.txt 1>/dev/null
    if [ $? != 0 ]; then
        return
    fi
    grep "float $waccmvar (" waccm_vars.txt 1>/dev/null
    if [ $? != 0 ]; then
        return
    fi
    echo "'$wrfvar -> $waccmvar'", >>mozbc.inp
}

read_namelist_var() {
    var=$1
    sed -n "/$var/s/.*=//p" $WRF_namelist_input_file_path | sed 's/ //g' | sed 's/,//g'
}

echo " Be sure you have already run WRF real.exe successfully with chem_opt=301, 302, ..."
wrfdir=$(dirname $WRF_namelist_input_file_path)
ncl_filedump $wrfdir/wrfinput_d01.nc | grep float > wrfinput_vars.txt
ncl_filedump $WACCM_data_file_name | grep float > waccm_vars.txt

echo -e "&control\n""\
\n""\
do_bc     = .true.\n""\
do_ic     = .true." >mozbc.inp
echo "domain = $(read_namelist_var max_dom)" >>mozbc.inp
echo -e "dir_wrf = '$wrfdir/'\n""\
dir_moz = '$MOZBC_directory_path/'\n""\
fn_moz  = '$WACCM_data_file_name'\n""\
moz_var_suffix  = ''\n""\
\n""\
spc_map =" >>mozbc.inp
check_add_var o3 O3
check_add_var no NO
check_add_var no2 NO2
check_add_var no3 NO3
check_add_var nh3 NH3
check_add_var hno3 HNO3
check_add_var hno4 HO2NO2
check_add_var n2o5 N2O5
check_add_var ho OH
check_add_var ho2 HO2
check_add_var h2o2 H2O2
check_add_var ch4 CH4
check_add_var co CO
check_add_var hcho CH2O
check_add_var ald CH3CHO
check_add_var mgly CH3COCHO
check_add_var gly GLYOXAL
check_add_var pan PAN
check_add_var macr MACR
check_add_var tol TOLUENE
check_add_var dms DMS
check_add_var so2 SO2
check_add_var eth C2H6
check_add_var ch3oh CH3OH
check_add_var ol2 C2H4
check_add_var csl CRESOL
check_add_var open BIGALD
check_add_var ora2 CH3COOH
check_add_var op1 CH3OOH
check_add_var op2 C2H5OOH
check_add_var ch3o2 CH3O2
check_add_var c2h5oh C2H5OH
check_add_var tpan MPAN
check_add_var hc3 C3H8
check_add_var hc5 BIGALK
check_add_var iso ISOP
check_add_var ket CH3COCH3
check_add_var hket HYAC
check_add_var ete C2H4
check_add_var paa CH3COOOH
echo "/" >>mozbc.inp

echo "------SUCCESSFUL!------"
echo mozbc.inp has been successfully created!
echo "Now run the command below to make boundary values in wrfinput and wrfbdy files"
echo "./mozbc < mozbc.inp > mozbc.out"
