;Code to calculate ETo
;Contact person: Amir H. Nikfal <https://github.com/anikfal>

   jday  = 105       ; April 15, 2021
   lat   = 34.8694444
   staz  = 1740.8
   pressure      = 825.25
   wind          = 2.5
   tmax  = 21.4	
   tmin  = 0.01
   rhmax = 48
   rhmin = 8
   uz    = wind    ; m/s
   z     = 10.0      ; m      (wind height above ground)
   sunhr = daylight_fao56(jday, lat)      ; hrs/day

                     ; standard constants
   P0    = pressure     ; kPa
   Z0    = 0.0       ; m
   albedo= 0.23      ; default

;===================

   tavg   = (tmin+tmax)*0.5                            ; 16.9   C
   slp    = satvpr_slope_fao56(tavg, (/0,2/))                ; 0.122  kPa/C
   p      = prsatm_tz_fao56(tavg, staz, P0, Z0, (/0,2,2/))    ; 100.11  kPa
   g      = psychro_fao56(p, (/2,2/))                       ; 0.0666  kPa/sqrt(c)
   G      = 0.0                                        ; recommended for daily data
   esAvg = satvpr_mean_fao56(tmin, tmax, (/0,2/))   ; 1.997   [EQN 12]

   u2     = u2_fao56(uz, z, (/0,0/))                        ; 2.078 m/s  [wunit=1: km/hr->m/s)
   ea     = actvpr_mnmx_fao56(tmin, tmax, rhmin, rhmax, (/0,2/))   ; 1.409
   edef = esAvg-ea                                     ; 0.589

   radext = radext_fao56(jday, lat, 1)                 ; 41.088 MJ/(m2-day)
   sunhrx = daylight_fao56(jday, lat)                  ; 16.10 hr
   radsol = radsol_fao56(radext,sunhrx,sunhr,(/1,1/),False) ; 22.07 MJ/(m2-day)
   radsol_clr = radsol_clrsky_fao56(radext, False)     ; 30.82 MJ/(m2-day); FAO 56 says 30.90
   netlw  = netlw_fao56(tmin, tmax, ea, radext, radsol, (/0,2,1,1/), False) ; 3.73 MJ/(m2-day); FAO 56 says 3.71
   netsw  = netsw_fao56(radsol, albedo)               ; 17.00 MJ/(m2-day)
   netrad = netrad_fao56(netsw, netlw)                 ; 13.27 MJ/(m2-day)

   dnom = slp + g*(1+0.34*u2)                          ; 0.236
   dnom@long_name = "denominator in P-M"

   ET0 = (0.408*(netrad-G)*slp + g*(900.0/(tavg+273))*u2*edef)/dnom                      ; 3.877 mm/day
   ET0@units = "mm/day"
   print(ET0)
