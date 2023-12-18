load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA = "/glade/scratch/lgchen/data/era20c"

  ; fn_bin_daily = (/"precsnoocnb.dat", "qv2m.dat", "rainocnb.dat", "slp.dat", "swgdnb.dat", "t2mb.dat", "u10mb.dat", "v10mb.dat"/)
  ; var_nm_daily = (/"precsnoocn"     , "qv2m"    , "rainocn"     , "slp"    , "swgdn"     , "t2m"     , "u10m"     , "v10m"     /)

  ; fn_bin_daily = (/"lwgemb.dat"/)
  ; var_nm_daily = (/"lwgem"     /)

  ; fn_bin_daily = (/"lwgab.dat", "slpb.dat"/)
  ; var_nm_daily = (/"lwga"     , "slp"     /)

  ; fn_bin_daily = (/"qv2mb.dat"/)
  ; var_nm_daily = (/"qv2m"     /)


  ; N_VAR = dimsizes(var_nm_daily)

    N_DAY = 11323  ; 13149
    NY    = 361
    NX    = 720

    jul_day_19800101 = greg2jul(1980, 01, 01, -1)
    jul_day_20101231 = greg2jul(2010, 12, 31, -1)

 
    time      = new((/N_DAY/), "float")
    latitude  = new((/NY   /), "float")
    longitude = new((/NX   /), "float")

  ; time      = fspan(28854+365.0, 28854+365.0+13149-1, 13149)
    time      = fspan(28855+365.0, 28855+365.0+11323-1, 11323)
  ; time      = fspan(28854+365.0, 28854+365.0+N_DAY-1, N_DAY)
    latitude  = fspan(-90.0, 90.0 , 361)
    longitude = fspan(0.0  , 359.5, 720)

    time_att            = True
    time_att@long_nime  = "time"
    time_att@units      = "days since 1900-01-01 00:00:00"
    time_att@calendar   = "julian"
    time_att@modulo     = " "
    time_att@modulo_beg = "1980-01-01 00:00:00"
    time_att@modulo_end = "2010-12-31 00:00:00"
   
    latitude_att           = True
    latitude_att@long_name = "latitude"
    latitude_att@units     = "degrees_north"
    latitude_att@axis      = "Y"
 
    longitude_att           = True
    longitude_att@long_name = "longitude"
    longitude_att@units     = "degrees_east"
    longitude_att@modulo    = 360.
    longitude_att@axis      = "X"

    N_VAR_ANALYSIS = 4
    VAR_NM_ANALYSIS = (/"mslp", "u10m", "v10m", "t2m"/)
    var = new((/N_VAR_ANALYSIS, N_DAY, NY, NX/), "float", -1.0e20)
  
    ; for analysis
    cnt_day = 0
    do i_yr = 1980, 2010
        str_yr = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_yr)

        if (isleapyear(i_yr)) then
            dofy = 366
        else
            dofy = 365
        end if

        fl_nc = addfile(DIR_DATA + "/analysis/" + str_yr + ".nc", "r")
        
        do i_day = 0, dofy - 1
            ; var151: mean sea level pressure, unit: Pa 
            var(0, cnt_day+i_day, :, :) = dim_avg_n(fl_nc->var151(4*i_day:4*(i_day+1)-1, :, :), 0)

            ; var165: 10 meter U wind component, unit: m/s  
            var(1, cnt_day+i_day, :, :) = dim_avg_n(fl_nc->var165(4*i_day:4*(i_day+1)-1, :, :), 0)

            ; var166: 10 meter V wind component, unit: m/s 
            var(2, cnt_day+i_day, :, :) = dim_avg_n(fl_nc->var166(4*i_day:4*(i_day+1)-1, :, :), 0)

            ; var167: 2 meter temperature, unit: K
            var(3, cnt_day+i_day, :, :) = dim_avg_n(fl_nc->var167(4*i_day:4*(i_day+1)-1, :, :), 0)
        end do

        cnt_day = cnt_day + dofy
    end do


    ; write out to netCDF file
    do i_var = 0, N_VAR_ANALYSIS - 1
        fl_nc = addfile(DIR_DATA + "/analysis/era20c_" + VAR_NM_ANALYSIS(i_var) + "_1980_2010.nc", "c")

        ; define file (global) attributes
        global_att             = True
        global_att@description = "source: era20c data to daily netCDF for SODA_MOM forcing!"
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
        filevardef(fl_nc, VAR_NM_ANALYSIS(i_var), "float", (/"time", "latitude", "longitude"/))

        var_att           = True
        var_att@long_name = VAR_NM_ANALYSIS(i_var)
        filevarattdef(fl_nc, VAR_NM_ANALYSIS(i_var), var_att )

        print("Assigning file var ...")
        fl_nc->$VAR_NM_ANALYSIS(i_var)$(:, :, :) = var(i_var, :, :, :)

        fl_nc->$VAR_NM_ANALYSIS(i_var)$@_FillValue = -9.99e8
    end do


end
