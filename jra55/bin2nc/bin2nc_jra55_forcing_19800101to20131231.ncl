load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "LittleEndian")
    setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA = "/glade/p/umcp0006/lgchen/data/JRA55/daily_data"

    fn_bin_daily = (/"dlwrf_jra55_daily.dat", "dswrf_jra55_daily.dat", "evp_jra55_daily.dat", "icec_jra55_daily.dat"  \
                 , "lhtfl_jra55_daily.dat", "pres_jra55_daily.dat", "shtfl_jra55_daily.dat", "spfh_jra55_daily.dat"   \
                 , "srweq_jra55_daily.dat", "tmp_jra55_daily.dat", "tprat_jra55_daily.dat", "u10_jra55_daily.dat"     \
                 , "ulwrf_jra55_daily.dat", "uswrf_jra55_daily.dat", "v10_jra55_daily.dat"/)
    var_nm_daily = (/"dlwrf", "dswrf", "evp", "icec", "lhtfl", "pres", "shtfl", "spfh", "srweq", "tmp", "tprat"  \
        , "u10", "ulwrf", "uswrf", "v10"/)
    var_longname_daily = (/"JRA55 Downward long wave radiation flux"  \
        , "Downward solar radiation flux"  \
        , "Evaporation"                    \
        , "daily avg ice cover"            \
        , "latent heat flux"               \
        , "daily sea level pressure"       \
        , "Sensible heat flux"             \
        , "specific humidity"              \
        , "Snowfall rate water equivalent" \
        , "2m temperature"                 \
        , "total precipitation"            \
        , "10m zonal wind"                 \
        , "Upward long wave radiation flux"\ 
        , "upward solar radiation flux"    \
        , "10m meridional wind"/)
    var_units_daily = (/"W/m^2", "W/m^2", "mm/day", "1 = ice, 0 = no ice", "W/m^2", "Pa", "W/m^2", "kg/kg", "mm/day", "K"  \
        , "mm/day", "m/s", "W/m^2", "W/m^2", "m/s"/)
  ; var_undef_daily = (/1.e+20, 1.e+20, 1.e+20, -9.99e+08, 1.e+20, 1.e+20, 1.e+20, 1.e+20, 1.e+20, 1.e+20, 1.e+20  \
  ;     , 1.e+20, 1.e+20, 1.e+20, 1.e+20/)
    var_undef_daily = (/1e20, 1e20, 1e20, -9.99e8, 1e20, 1e20, 1e20, 1e20, 1e20, 1e20, 1e20  \
        , 1e20, 1e20, 1e20, 1e20/)


    N_VAR = dimsizes(var_nm_daily)  ; 15

    N_DAY = 12419
    NY    = 145
    NX    = 288

    jul_day_19800101 = greg2jul(1980, 01, 01, -1)
    jul_day_20131231 = greg2jul(2013, 12, 31, -1)
  ; N_DAY            = jul_day_20131231 - jul_day_19800101 + 1
    
    time      = new((/N_DAY/), "float")
    latitude  = new((/NY   /), "float")
    longitude = new((/NX   /), "float")

  ; time      = fspan(28854+365, 28854+365+12419-1, 12419)
    time      = fspan(28855+365, 28855+365+12419-1, 12419)
    latitude  = fspan(-90.0 , 90.0   , 145)
  ; longitude = fspan(-180.0, 179.375, 576)
    longitude = fspan(0.0   , 358.75 , 288)

    time_att            = True
    time_att@long_nime  = "time"
    time_att@units      = "days since 1900-01-01 00:00:00"
    time_att@calendar   = "julian"
    time_att@modulo     = " "
    time_att@modulo_beg = "1980-01-01 00:00:00"
    time_att@modulo_end = "2013-12-31 00:00:00"
   
    latitude_att           = True
    latitude_att@long_name = "latitude"
    latitude_att@units     = "degrees_north"
    latitude_att@axis      = "Y"
 
    longitude_att           = True
    longitude_att@long_name = "longitude"
    longitude_att@units     = "degrees_east"
    longitude_att@modulo    = 360.
    longitude_att@axis      = "X"

    var = new((/N_DAY, NY, NX/), "float", 1.e20)
   
    do i_var = 0, N_VAR - 1
        print("i_var = " + sprinti("%0.2i", i_var))

      ; var(:, :, :) = fbindirread(DIR_DATA + "/" + fn_bin_daily(i_var), 0, (/N_DAY, NY, NX/), "float")

      ; var(0, :, :) = fbindirread(DIR_DATA + "/" + fn_bin_daily(i_var), 0, (/       NY, NX/), "float")
      ; print(var(0, 10, :))
      ; exit()

        do i_day = 0, N_DAY - 1
            var(i_day, :, :) = fbindirread(DIR_DATA + "/" + fn_bin_daily(i_var), i_day, (/NY, NX/), "float")
        end do
    
        print("before addfile ...")
        fl_nc = addfile(DIR_DATA + "/netcdf/" + var_nm_daily(i_var) + ".nc", "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "source: jra55 data from binary to netCDF for SODA forcing!"
        fileattdef(fl_nc, global_att)

        ; define file dimensions
        dim_names = (/"time", "latitude", "longitude"/)
        dim_sizes = (/N_DAY , NY        , NX         /)  
        dim_unlim = (/True  , False     , False      /)  
        filedimdef(fl_nc, dim_names, dim_sizes, dim_unlim)

        ; define dimension vars
        filevardef(fl_nc, "time"     , "float", (/"time"     /))
        filevardef(fl_nc, "latitude" , "float", (/"latitude" /))
        filevardef(fl_nc, "longitude", "float", (/"longitude"/))

        fl_nc->time      = time
        fl_nc->latitude  = latitude
        fl_nc->longitude = longitude

        filevarattdef(fl_nc, "time"     , time_att     )
        filevarattdef(fl_nc, "latitude" , latitude_att )
        filevarattdef(fl_nc, "longitude", longitude_att)

        print("Defining file var ...") 
        filevardef(fl_nc, var_nm_daily(i_var), "float", (/"time", "latitude", "longitude"/))

        var_att            = True
        var_att@long_name  = var_longname_daily(i_var)
        var_att@units      = var_units_daily(i_var)
      ; var_att@_FillValue = var_undef_daily(i_var)
        filevarattdef(fl_nc, var_nm_daily(i_var), var_att )

        print("Assigning file var ...")
        fl_nc->$var_nm_daily(i_var)$(:, :, :) = var(:, :, :)

        fl_nc->$var_nm_daily(i_var)$@_FillValue = var_undef_daily(i_var)
    end do

end
