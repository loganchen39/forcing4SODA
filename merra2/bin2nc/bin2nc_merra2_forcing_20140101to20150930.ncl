load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA = "/glade/scratch/lgchen/data/merra2/daily_binary"

    fn_bin_daily = (/"lwgab.dat", "lwgemb.dat", "precsnoocnb.dat", "qv2mb.dat", "rainocnb.dat", "slpb.dat", "swgdnb.dat", "t2mb.dat", "u10mb.dat", "v10mb.dat"/)
    var_nm_daily = (/"lwgab"    , "lwgem"     , "precsnoocn"     , "qv2m"     , "rainocn"     , "slp"     , "swgdn"     , "t2m"     , "u10m"     , "v10m"     /)

    N_VAR = dimsizes(var_nm_daily)

    N_DAY = 31 + 274
    NY    = 361
    NX    = 576

    jul_day_20141201 = greg2jul(2014, 12, 01, -1)
    jul_day_20151001 = greg2jul(2015, 10, 01, -1)
  ; N_DAY            = jul_day_20151001 - jul_day_20141201 + 1
    
  ; jul_day_end      = jul_day_19800101 + 13149 - 1  ; 20151231

    time      = new((/N_DAY/), "float")
    latitude  = new((/NY   /), "float")
    longitude = new((/NX   /), "float")

  ; time      = fspan(28854+365.0, 28854+365.0+13149-1, 13149)
    time      = fspan(28855+365.0, 28855+365.0+13149-1, 13149)
  ; time      = fspan(28854+365.0, 28854+365.0+N_DAY-1, N_DAY)
    latitude  = fspan(-90.0 , 90.0   , 361)
    longitude = fspan(-180.0, 179.375, 576)

    time_att            = True
    time_att@long_nime  = "time"
    time_att@units      = "days since 1900-01-01 00:00:00"
    time_att@calendar   = "julian"
    time_att@modulo     = " "
    time_att@modulo_beg = "1980-01-01 00:00:00"
    time_att@modulo_end = "2015-12-31 00:00:00"
   
    latitude_att           = True
    latitude_att@long_name = "latitude"
    latitude_att@units     = "degrees_north"
    latitude_att@axis      = "Y"
 
    longitude_att           = True
    longitude_att@long_name = "longitude"
    longitude_att@units     = "degrees_east"
    longitude_att@modulo    = 360.
    longitude_att@axis      = "X"

    var = new((/N_DAY, NY, NX/), "float", -1.0e20)
   
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
        fl_nc = addfile(DIR_DATA + "/" + var_nm_daily(i_var) + ".nc", "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "source: merra2 data from binary to netCDF for SODA_MOM forcing!"
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

        var_att           = True
        var_att@long_name = var_nm_daily(i_var)
        filevarattdef(fl_nc, var_nm_daily(i_var), var_att )

        print("Assigning file var ...")
        fl_nc->$var_nm_daily(i_var)$(:, :, :) = var(:, :, :)

        fl_nc->$var_nm_daily(i_var)$@_FillValue = -9.99e8
    end do

end
