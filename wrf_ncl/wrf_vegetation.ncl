;Contact person: https://github.com/anikfal

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

a = addfile("geo_em.d01.nc","r")

type = "x11"
wks = gsn_open_wks(type,"plt_Surface1")
res = True
res@MainTitle                   = "REAL-TIME WRF"
pltres = True
mpres = True
times = wrf_user_getvar(a,"times",-1)  ; get all times in the file

res@TimeLabel = times(0)   ; Set Valid time to use on plots

slp = wrf_user_getvar(a,"GREENFRAC",-1)    ; slp
wrf_smooth_2d( slp, 3 )            ; smooth slp

opts = res         
opts@ContourParameters = (/ 0.05, 0.75, 0.05 /)
opts@cnFillOn = True
; opts@cnFillPalette = "vegetation_modis"
opts@cnFillPalette = "WhiteGreen"
mpres@mpFillOn = False
mpres@mpFillColors = (/"transparent","LightSkyBlue1","transparent","LightSkyBlue1", "transparent"/)
mpres@mpFillBoundarySets = "AllBoundaries"
mpres@mpOutlineBoundarySets = "AllBoundaries"
; mpres@mpOutlineOn = True
mpres@mpFillBoundarySets = "National"
mpres@mpGeophysicalLineColor = "Black"
mpres@mpNationalLineColor = "Black"
mpres@mpGeophysicalLineThicknessF = 3
mpres@mpNationalLineThicknessF = 3
mpres@mpOceanFillColor = "blue"
contour_psl = wrf_contour(a,wks,slp(0,0,:,:),opts)

pltres@PanelPlot= True
pltres@gsnFrame = False

; MAKE PLOTS                                       
plot = wrf_map_overlays(a, wks, (/contour_psl/), pltres, mpres)


myprov = new(1,graphic)
shpres = True
shpres@gsLineColor = "red"
shpres@gsLineThicknessF = 3
myprov(0) = gsn_add_shapefile_polylines(wks,plot,"/home/anikfal/wrftailor/tehranbasin.shp",shpres)
draw(plot)
frame(wks)