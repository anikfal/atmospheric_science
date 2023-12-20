#!/bin/bash
#Contact person: Amirhossein Nikfal <https://github.com/anikfal>

# Paths to Global_emissions and namelist.wps, and namelist.input (optional)
#=====================================================================================
global_emissions=/home/anikfal/Global_emissions_v3
namelist_wps=/home/anikfal/WRFTEST/WPS/namelist.wps
namelist_input=/home/anikfal/WRFTEST/WRF/test/em_real/namelist.input
#-------------------------------------------------------------------------------------
# After running this program, for linking the outputs, the variable below will be used:
domain_number_link=1
#=====================================================================================

if [ ! -f prep_chem_sources.inp ]; then
    echo Error!
    echo "There is no <prep_chem_sources.inp> in current directory"
    echo "Please nagivage to prep_chem_sources <bin> directory and run again"
    exit
fi

while getopts hlL option; do
    ls $namelist_input 1>/dev/null 2>&1
    if [ $? != 0 ]; then
        echo Error!
        echo You want to link the prep_chem_sources outputs to the WRF run directory.
        echo But $namelist_input is not valid.
        echo Please set the correct path to the WRF namelist.input and run again.
        exit
    fi
    case $option in
    l)
        wrfdir=${namelist_input%/*}
        echo Linking outputemiss*g$domain_number_link-ab.bin "-->" $wrfdir/emissopt3_d01
        ln -sf $PWD/outputemiss*g$domain_number_link-ab.bin $wrfdir/emissopt3_d01
        echo Linking outputemiss*g$domain_number_link-bb.bin "-->" $wrfdir/emissfire_d01
        ln -sf $PWD/outputemiss*g$domain_number_link-bb.bin $wrfdir/emissfire_d01
        echo Linking outputemiss*-g$domain_number_link-gocartBG.bin "-->" $wrfdir/wrf_gocart_backg
        ln -sf $PWD/outputemiss*-g$domain_number_link-gocartBG.bin $wrfdir/wrf_gocart_backg
        echo Successful!
        exit
        ;;
    L)
        wrfdir=${namelist_input%/*}
        echo Linking outputemiss*g$domain_number_link-ab.bin "-->" $wrfdir/emissopt3_d01
        ln -sf $PWD/outputemiss*g$domain_number_link-ab.bin $wrfdir/emissopt3_d01
        echo Linking outputemiss*g$domain_number_link-bb.bin "-->" $wrfdir/emissfire_d01
        ln -sf $PWD/outputemiss*g$domain_number_link-bb.bin $wrfdir/emissfire_d01
        echo Linking outputemiss*-g$domain_number_link-gocartBG.bin "-->" $wrfdir/wrf_gocart_backg
        ln -sf $PWD/outputemiss*-g$domain_number_link-gocartBG.bin $wrfdir/wrf_gocart_backg
        echo Successful!
        exit
        ;;
    h)
        echo "    -L,  Link outputs of prep_chem_sources to the WRF run directory"
        echo "    -h,  Print help options"
        exit
        ;;
    esac
done

ls $namelist_wps 1>/dev/null 2>&1
if [ $? != 0 ]; then
    echo Error!
    echo $namelist_wps is not valid.
    echo Please set the correct path to namelist.wps and run again.
    exit
fi
ls $global_emissions 1>/dev/null 2>&1
if [ $? != 0 ]; then
    echo Error!
    echo $global_emissions is not valid.
    echo Please set the correct path to global_emissions directory and run again.
    exit
fi

echo ---------------------------------------------------------------------------------------------------------------
echo "Make sure that your namelist.wps and namelist.input files are okay,"
echo "And you can run the WRF model without errors by chem_opt=0"
echo ---------------------------------------------------------------------------------------------------------------

if [ ! -f prep_chem_sources.inp_copy ]; then
    cp prep_chem_sources.inp prep_chem_sources.inp_copy
    echo A copy of prep_chem_sources.inp has been saved as prep_chem_sources.inp_copy in the current directory.
fi

get_from_namelist() { #first argument is the namelist variable, second argument is the field number
    myvar=$(sed -n "/$1/p" $namelist_wps | awk -F"=" '{print $NF}' | cut -d, -f$2)
    if [[ -z "$myvar" ]]; then
        myvar=0
    fi
}

get_from_namelist max_dom 1
NGRIDS__=$myvar

get_from_namelist start_date 1
alldate=$myvar
date=$(echo $alldate | cut -d '_' -f 1)
alltime=$(echo $alldate | cut -d '_' -f 2)
iyear222=$(echo $date | cut -d '-' -f 1)
iyear__=${iyear222:1}
imon__=$(echo $date | cut -d '-' -f 2)
iday__=$(echo $date | cut -d '-' -f 3)
ihour__=$(echo $alltime | cut -d ':' -f 1)

get_from_namelist e_we 1
e_we__1=$myvar
get_from_namelist e_we 2
e_we__2=$myvar
get_from_namelist e_we 3
e_we__3=$myvar
get_from_namelist e_we 4
e_we__4=$myvar

get_from_namelist e_sn 1
e_sn__1=$myvar
get_from_namelist e_sn 2
e_sn__2=$myvar
get_from_namelist e_sn 3
e_sn__3=$myvar
get_from_namelist e_sn 4
e_sn__4=$myvar

get_from_namelist parent_id 1
NXTNEST__1=$myvar
get_from_namelist parent_id 2
NXTNEST__2=$myvar
get_from_namelist parent_id 3
NXTNEST__3=$myvar
get_from_namelist parent_id 4
NXTNEST__4=$myvar

get_from_namelist dx 1
DELTAX__1=$myvar

get_from_namelist dy 1
DELTAY__1=$myvar

get_from_namelist parent_grid_ratio 1
NSTRATX__1=$myvar
get_from_namelist parent_grid_ratio 2
NSTRATX__2=$myvar
get_from_namelist parent_grid_ratio 3
NSTRATX__3=$myvar
get_from_namelist parent_grid_ratio 4
NSTRATX__4=$myvar

get_from_namelist i_parent_start 1
NINEST__1=$myvar
get_from_namelist i_parent_start 2
NINEST__2=$myvar
get_from_namelist i_parent_start 3
NINEST__3=$myvar
get_from_namelist i_parent_start 4
NINEST__4=$myvar

get_from_namelist j_parent_start 1
NJNEST__1=$myvar
get_from_namelist j_parent_start 2
NJNEST__2=$myvar
get_from_namelist j_parent_start 3
NJNEST__3=$myvar
get_from_namelist j_parent_start 4
NJNEST__4=$myvar

get_from_namelist ref_lat 1
ref_lat__1=$myvar

get_from_namelist ref_lon 1
ref_lon__1=$myvar

get_from_namelist truelat2 1
truelat2__1=$myvar

get_from_namelist truelat1 1
truelat1__1=$myvar

cat >1prep.sed <<EOL
/grid_type/ s/.*=.*/grid_type='lambert',/
/use_edgar/ s/.*=.*/use_edgar=2/
/use_retro/ s/.*=.*/use_retro=1/
/use_streets/ s/.*=.*/use_streets=0/
/use_seac4rs/ s/.*=.*/use_seac4rs=1/
/use_fwbawb/ s/.*=.*/use_fwbawb=1/
/use_bioge/ s/.*=.*/use_bioge=1/
/use_gfedv2/ s/.*=.*/use_gfedv2=1/
/use_bbem_plumerise/ s/.*=.*/use__bbem_plumerise=0/
/use_bbem/ s/.*=.*/use_bbem=1/
/merge_GFEDv2_bbem/ s/.*=.*/merge_GFEDv2_bbem=1/
/use_gocart_bg/ s/.*=.*/use__gocart_bg=1/
/use_gocart/ s/.*=.*/use_gocart=1/
/use_volcanoes/ s/.*=.*/use_volcanoes=0/
/use_degass_volcanoes/ s/.*=.*/use_degass_volcanoes=0/
/pond/ s/.*=.*/pond=1/
/fuel_data_dir/ s/.*=.*/\!fuel_data_dir=1/
/proj_to_ll/ s/.*=.*/proj_to_ll='NOT'/
/chem_out_prefix/ s/.*=.*/chem_out_prefix = 'outputemiss',/
/chem_out_format/ s/.*=.*/chem_out_format = 'vfm',/
/special_output_to_wrf/ s/.*=.*/special_output_to_wrf = 'YES',/
/NGRIDS/ s/.*=.*/NGRIDS = $NGRIDS__,/
/NNXP/ s/.*=.*/NNXP = $e_we__1, $e_we__2, $e_we__3, $e_we__4/
/NNYP/ s/.*=.*/NNYP = $e_sn__1, $e_sn__2, $e_sn__3, $e_sn__4/
/NXTNEST/ s/.*=.*/NXTNEST = $NXTNEST__1, $NXTNEST__2, $NXTNEST__3, $NXTNEST__4/
/DELTAX/ s/.*=.*/DELTAX = $DELTAX__1,/
/DELTAY/ s/.*=.*/DELTAY = $DELTAY__1,/
/NSTRATX/ s/.*=.*/NSTRATX = $NSTRATX__1, $NSTRATX__2, $NSTRATX__3, $NSTRATX__4/
/NSTRATY/ s/.*=.*/NSTRATY = $NSTRATX__1, $NSTRATX__2, $NSTRATX__3, $NSTRATX__4/
/NINEST/ s/.*=.*/NINEST = $NINEST__1, $NINEST__2, $NINEST__3, $NINEST__4/
/NJNEST/ s/.*=.*/NJNEST = $NJNEST__1, $NJNEST__2, $NJNEST__3, $NJNEST__4/
/POLELAT/ s/.*=.*/POLELAT = $ref_lat__1,/
/POLELON/ s/.*=.*/POLELON = $ref_lon__1,/
/STDLAT2/ s/.*=.*/STDLAT2 = $truelat2__1,/
/STDLAT1/ s/.*=.*/STDLAT1 = $truelat1__1,/
/CENTLAT/ s/.*=.*/CENTLAT = $ref_lat__1,/
/CENTLON/ s/.*=.*/CENTLON = $ref_lon__1,/
/iyear/ s/.*=.*/iyear = $iyear__,/
/imon/ s/.*=.*/imon = $imon__,/
/iday/ s/.*=.*/iday = $iday__,/
/ihour/ s/.*=.*/ihour = $ihour__,/
/retro_data_dir/ s@.*=.*@retro_data_dir = '$global_emissions/Emission_data/RETRO/anthro',@
/gocart_data_dir/ s@.*=.*@gocart_data_dir = '$global_emissions/Emission_data/GOCART/emissions',@
/edgar_data_dir/ s@.*=.*@edgar_data_dir = '$global_emissions/Emission_data/EDGARV4'@
/seac4rs_data_dir/ s@.*=.*@seac4rs_data_dir = '$global_emissions/Emission_data/SEAC4RS'@
/fwbawb_data_dir/ s@.*=.*@fwbawb_data_dir = '$global_emissions/Emission_data/Emissions_Yevich_Logan'@
/bioge_data_dir/ s@.*=.*@bioge_data_dir = '$global_emissions/Emission_data/biogenic_emissions'@
/gfedv2_data_dir/ s@.*=.*@gfedv2_data_dir = '$global_emissions/Emission_data/GFEDv2-8days'@
/bbem_wfabba_data_dir/ s@.*=.*@bbem_wfabba_data_dir = '$global_emissions/Emission_data/fires_data/WF_ABBA_v60_saulo/filt/f'@
/bbem_modis_data_dir/ s@.*=.*@bbem_modis_data_dir = '$global_emissions/Emission_data/fires_data/MODIS/Fires.'@
/bbem_inpe_data_dir/ s@.*=.*@bbem_inpe_data_dir = '$global_emissions/Emission_data/fires_data/DSA/Focos'@
/bbem_extra_data_dir/ s@.*=.*@bbem_extra_data_dir = '$global_emissions/Emission_data/fires_data/BLMALASKA/current.dat'@
/veg_type_data_dir/ s@.*=.*@veg_type_data_dir = '$global_emissions/surface_data/GL_IGBP_MODIS_INPE/MODIS'@
/olson_data_dir/ s@.*=.*@olson_data_dir = '$global_emissions/Emission_data/OLSON2/OLSON'@
/carbon_density_data_dir/ s@.*=.*@carbon_density_data_dir = '$global_emissions/surface_data/GL_OGE_INPE'@
/gocart_bg_data_dir/ s@.*=.*@gocart_bg_data_dir = '$global_emissions/Emission_data/GOCART'@
EOL

sed -f 1prep.sed prep_chem_sources.inp >prep_chem_sources.inp_temp
mv prep_chem_sources.inp_temp prep_chem_sources.inp
rm 1prep.sed

cat >1prep.sed <<EOL
/use__gocart_bg/ s/.*=.*/use_gocart_bg=1/
/use__bbem_plumerise/ s/.*=.*/use_bbem_plumerise=0/
EOL
sed -f 1prep.sed prep_chem_sources.inp >prep_chem_sources.inp_temp
mv prep_chem_sources.inp_temp prep_chem_sources.inp
rm 1prep.sed

echo Successful!
echo prep_chem_sources.inp is all set.
echo Now you can run prep_chem_sources_RADM_WRF_FIM_.exe
