load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_ERA20C = "/glade/scratch/lgchen/data/era20c"

    ; define the output netCDF file
    fn_nc_mon = "era20c_monthly_avg_1900_2010.nc"
    fl_nc_mon = addfile(DIR_ERA20C + "/monthly_avg/" + fn_nc_mon, "c")

    fl_nc_dim = addfile(DIR_ERA20C + "/320by160/1900.nc", "r")
    
    ; define global attributes
    global_att = True
    global_att@Conventions = "CF-1.0"

    ; define file dimensions
    dim_names = (/"time", "longitude", "latitude"/)
    dim_sizes = (/1332  , 320        , 160       /)
    dim_unlim = (/True  , False      , False     /)
    filedimdef(fl_nc_mon, dim_names, dim_sizes, dim_unlim)

    ; define dimension and other static vars
    filevardef(fl_nc_mon, "time"     , "integer", (/"time"     /))
    filevardef(fl_nc_mon, "longitude", "float"  , (/"longitude"/))
    filevardef(fl_nc_mon, "latitude" , "float"  , (/"latitude" /))

    ; define dynamic vars
    filevardef(fl_nc_mon, "u10", "float", (/"time", "latitude", "longitude"/))
    filevardef(fl_nc_mon, "v10", "float", (/"time", "latitude", "longitude"/))
    filevardef(fl_nc_mon, "t2m", "float", (/"time", "latitude", "longitude"/))

    ; define vars' attributs
    time_att           = True
    time_att@long_name = "time"
    time_att@units     = "months since 1900-01"
    filevarattdef(fl_nc_mon, "time", time_att)

    longitude_att           = True
    longitude_att@long_name = "longitude"
    longitude_att@units     = "degrees_east"
    filevarattdef(fl_nc_mon, "longitude", longitude_att)

    latitude_att           = True
    latitude_att@long_name = "latitude"
    latitude_att@units     = "degrees_north"
    filevarattdef(fl_nc_mon, "latitude", latitude_att)

    fl_nc_mon->time      = ispan(0, 1331, 1)
    fl_nc_mon->latitude  = fl_nc_dim->g4_lat_1
    fl_nc_mon->longitude = fl_nc_dim->g4_lon_2


    u10_att            = True
    u10_att@long_name  = "10 metre U wind component"
    u10_att@units      = "m s**-1"
    u10_att@_FillValue = 1.e+20
    u10_att@center     = "European Center for Medium-Range Weather Forecasts (RSMC)"
    filevarattdef(fl_nc_mon, "u10", u10_att)

    v10_att            = True
    v10_att@long_name  = "10 metre V wind component"
    v10_att@units      = "m s**-1"
    v10_att@_FillValue = 1.e+20
    v10_att@center     = "European Center for Medium-Range Weather Forecasts (RSMC)"
    filevarattdef(fl_nc_mon, "v10", v10_att)

    t2m_att            = True
    t2m_att@long_name  = "2 metre temperature"
    t2m_att@units      = "K"
    t2m_att@_FillValue = 1.e+20
    t2m_att@center     = "European Center for Medium-Range Weather Forecasts (RSMC)"
    filevarattdef(fl_nc_mon, "t2m", t2m_att)

    i_time = 0
    do i_yr = 1900, 2010
        print("i_yr = " + i_yr)

        fn_nc_12hr = sprinti("%0.4i", i_yr) + ".nc"
        fl_nc_12hr = addfile(DIR_ERA20C + "/320by160/" + fn_nc_12hr, "r")

        start_rec = 0
        do i_mon = 1, 12
            dinm    = days_in_month(i_yr, i_mon)
            end_rec = start_rec + 2*dinm - 1
            
            fl_nc_mon->u10(i_time, :, :) = dim_avg_n(fl_nc_12hr->10U_GDS4_SFC(start_rec:end_rec, :, :), 0)
            fl_nc_mon->v10(i_time, :, :) = dim_avg_n(fl_nc_12hr->10V_GDS4_SFC(start_rec:end_rec, :, :), 0)
            fl_nc_mon->t2m(i_time, :, :) = dim_avg_n(fl_nc_12hr->2T_GDS4_SFC (start_rec:end_rec, :, :), 0)

            i_time    = i_time + 1
            start_rec = end_rec + 1
        end do        
    end do  ; end of "do i_yr = 1900, 2010"
end
