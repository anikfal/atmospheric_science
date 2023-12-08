;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
w=addfile("geo_em.d01.nc", "w")  ;;; Enter your WPS geog file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

westasia_dust = addfile("DS.nc", "r")
wasf = westasia_dust->dustsource
lat2d=w->XLAT_M(0,:,:)
lon2d=w->XLONG_M(0,:,:)
erod=w->EROD;Read Ginoux source function
eroddd=w->EROD;Read Ginoux source function
wasf_rgird  = rgrid2rcm (wasf&south_north, wasf&west_east, wasf, lat2d, lon2d, 0); regrid WASF to the spatial resolution of domain 
copy_VarCoords(erod,wasf_rgird); get the name of dimensions back

;Additional codes to integrate WASF with other parts of the domain
;===================================================================
wasf_rgird_1d = ndtooned(wasf_rgird)
wasf_rgird_1d_in = wasf_rgird_1d
if(any(ismissing(wasf_rgird_1d_in))) then
wasf_rgird_1d_in(ind(ismissing(wasf_rgird_1d_in))) = 0
end if
erod_in = onedtond(wasf_rgird_1d_in, dimsizes(erod))
copy_VarCoords(erod,erod_in); get the name of dimensions back
wasf_rgird_1d(ind(.not.ismissing(wasf_rgird_1d))) = 0
if(any(ismissing(wasf_rgird_1d))) then
wasf_rgird_1d(ind(ismissing(wasf_rgird_1d))) = 1
end if
erod_01 = onedtond(wasf_rgird_1d, dimsizes(erod))
erod_out = erod*erod_01
copy_VarCoords(erod,erod_out); get the name of dimensions back
erod_integrated = erod_in + erod_out
copy_VarCoords(erod,erod_integrated); get the name of dimensions back

w->EROD = erod_integrated ;replace Ginoux function with WASF, while preserving default Ginoux function for parts of the domain out of WASF
