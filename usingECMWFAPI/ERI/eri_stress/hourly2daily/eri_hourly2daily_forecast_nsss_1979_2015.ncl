load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA = "/glade/scratch/lgchen/data/eri_stress/netcdf"

    N_DAY = 13514  ; 13505 + 9
    NY    = 181
    NX    = 360

    jul_day_19790101 = greg2jul(1979, 01, 01, -1)
    jul_day_20151231 = greg2jul(2015, 12, 31, -1)

 
    time      = new((/N_DAY/), "float")
    latitude  = new((/NY   /), "float")
    longitude = new((/NX   /), "float")

  ; time      = fspan(28854+365.0, 28854+365.0+13149-1, 13149)
  ; time      = fspan(28854+365.0, 28854+365.0+N_DAY-1, N_DAY)
  ; time      = fspan(28855+365.0, 28855+365.0+11323-1, 11323)
    time      = fspan(28855.0    , 28855      +13514-1, 13514)
  ; latitude  = fspan(-90.0, 90.0 , 181)
    latitude  = fspan( 90.0,-90.0 , 181)
    longitude = fspan(0.0  , 359  , 360)

    time_att            = True
    time_att@long_nime  = "time"
    time_att@units      = "days since 1900-01-01 00:00:00"
    time_att@calendar   = "julian"
    time_att@modulo     = " "
    time_att@modulo_beg = "1979-01-01 00:00:00"
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

    N_VAR_ANALYSIS = 1
    VAR_NM_ANALYSIS = (/"nsss"/)
    VAR_CODE        = (/"NSSS_GDS0_SFC"/)
  ; var = new((/N_VAR_ANALYSIS, N_DAY, NY, NX/), "float", -1.0e20)
    var = new((/                N_DAY, NY, NX/), "float",  1.0e20)
  
    ; for analysis
    do i_var = 0, N_VAR_ANALYSIS - 1
        cnt_day = 0
        print("var = " + VAR_NM_ANALYSIS(i_var))

        do i_yr = 1979, 2015
            str_yr = sprinti("%0.4i", i_yr)
            print("i_yr = " + str_yr)

            if (isleapyear(i_yr)) then
                dofy = 366
            else
                dofy = 365
            end if

            fl_nc = addfile(DIR_DATA + "/" + str_yr + "_ntss.nc", "r")
            
            do i_day = 0, dofy - 1
                var(cnt_day+i_day, :, :) = (fl_nc->$VAR_CODE(i_var)$(2*i_day+0, 3, :, :) + fl_nc->$VAR_CODE(i_var)$(2*i_day+1, 3, :, :)) / (24.0*60*60)
            end do

            cnt_day = cnt_day + dofy
        end do


        ; write out to netCDF file
        fl_nc = addfile(DIR_DATA + "/" + VAR_NM_ANALYSIS(i_var) + "_1979_2015.nc", "c")

        ; define file (global) attributes
        global_att             = True
        global_att@description = "source: era-interim data to daily netCDF for SODA_MOM forcing!"
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
      ; var_att@long_name = VAR_NM_ANALYSIS(i_var)
        var_att@long_name = "North-South surface stress"
        var_att@units     = "N m**-2"
        filevarattdef(fl_nc, VAR_NM_ANALYSIS(i_var), var_att )

        print("Assigning file var ...")
        fl_nc->$VAR_NM_ANALYSIS(i_var)$(:, :, :) = var(:, :, :)

        fl_nc->$VAR_NM_ANALYSIS(i_var)$@_FillValue = 1.0e20
    end do

end
