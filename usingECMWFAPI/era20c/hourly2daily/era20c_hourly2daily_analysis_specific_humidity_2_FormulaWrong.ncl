load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA = "/glade/scratch/lgchen/data/era20c/analysis/modified"

  ; fn_bin_daily = (/"lwgab.dat", "slpb.dat"/)
  ; var_nm_daily = (/"lwga"     , "slp"     /)

  ; N_VAR = dimsizes(var_nm_daily)

    N_DAY = 10  ; 11323  ; 13149
    NY    = 361
    NX    = 720

    jul_day_19800101 = greg2jul(1980, 01, 01, -1)
    jul_day_20101231 = greg2jul(2010, 12, 31, -1)

 
    time      = new((/N_DAY/), "float")
    latitude  = new((/NY   /), "float")
    longitude = new((/NX   /), "float")

  ; time      = fspan(28854+365.0, 28854+365.0+13149-1, 13149)
    time      = fspan(28855+365.0, 28855+365.0+10-1, 10)
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

    N_VAR_ANALYSIS = 1
    VAR_NM_ANALYSIS = (/"q2m"/)
  ; VAR_CODE        = (/"var168"/)
  ; var = new((/N_VAR_ANALYSIS, N_DAY, NY, NX/), "float", -1.0e20)
    var = new((/                10   , NY, NX/), "float", -1.0e20)
 
 
    ; for analysis
    fl_nc_dt2m = addfile(DIR_DATA + "/era20c_dt2m_1980_2010.nc", "r")
    fl_nc_mslp = addfile(DIR_DATA + "/era20c_mslp_1980_2010.nc", "r")
    
    do i_day = 0, 10    - 1
        print("i_day = " + sprinti("%0.2i", i_day))
        tmp_exp          = 611.21 * exp(17.502*(fl_nc_dt2m->dt2m(i_day, :, :) - 273.16) / (fl_nc_dt2m->dt2m(i_day, :, :) + 32.19))
        var(i_day, :, :) = 0.622*tmp_exp / (fl_nc_mslp->mslp(i_day, :, :) - (1 - 0.622)*tmp_exp)
    end do


    ; write out to netCDF file
    fl_nc = addfile(DIR_DATA + "/era20c_" + VAR_NM_ANALYSIS(0) + "_1980_2010_2.nc", "c")

    ; define file (global) attributes
    global_att             = True
    global_att@description = "source: era20c data to daily netCDF for SODA_MOM forcing!"
    fileattdef(fl_nc, global_att)

    ; define file dimensions
    dim_names = (/"time", "latitude", "longitude"/)
    dim_sizes = (/10    , NY        , NX         /)  
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
    filevardef(fl_nc, VAR_NM_ANALYSIS(0), "float", (/"time", "latitude", "longitude"/))

    var_att           = True
    var_att@long_name = VAR_NM_ANALYSIS(0)
    filevarattdef(fl_nc, VAR_NM_ANALYSIS(0), var_att )

    print("Assigning file var ...")
    fl_nc->$VAR_NM_ANALYSIS(0)$(:, :, :) = var(:, :, :)

    fl_nc->$VAR_NM_ANALYSIS(0)$@_FillValue = -9.99e8

end
