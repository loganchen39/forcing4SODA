load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_ERA20C = "/glade/scratch/lgchen/data/era20c"

    ; define the output netCDF file
    fn_nc_mon = "era20c_monthly_avg_1900_2010.nc"
    fl_nc_mon = addfile(DIR_ERA20C + "/monthly_avg/" + fn_nc_mon, "r")
    N_TIME      = 1332
    N_LAT_MON   = 160
    N_LON_MON   = 320
    lon_mon     = fl_nc_mon->longitude
    lat_mon_org = fl_nc_mon->latitude
    lat_mon     = new((/N_LAT_MON/), "float", -1.0e20)
    do i_lat = 0, 159
        lat_mon(i_lat) = lat_mon_org(159 - i_lat)
    end do
;   print(lat_mon)

    var_mon = new((/N_TIME, N_LAT_MON, N_LON_MON/), "float", -1.0e20)
 

    N_LAT_REGRID = 94
    N_LON_REGRID = 192

    fn_nc_regrid = "era20c_monthly_avg_1900_2010_regrid.nc"
    fl_nc_regrid = addfile(DIR_ERA20C + "/monthly_avg/" + fn_nc_regrid, "c")

    
    ; define global attributes
    global_att = True
    global_att@Conventions = "CF-1.0"

    ; define file dimensions
    dim_names = (/"time", "longitude", "latitude"/)
    dim_sizes = (/1332  , 192        , 94        /)
    dim_unlim = (/True  , False      , False     /)
    filedimdef(fl_nc_regrid, dim_names, dim_sizes, dim_unlim)

    ; define dimension and other static vars
    filevardef(fl_nc_regrid, "time"     , "integer", (/"time"     /))
    filevardef(fl_nc_regrid, "longitude", "float"  , (/"longitude"/))
    filevardef(fl_nc_regrid, "latitude" , "float"  , (/"latitude" /))

    ; define dynamic vars
    filevardef(fl_nc_regrid, "u10", "float", (/"time", "latitude", "longitude"/))
    filevardef(fl_nc_regrid, "v10", "float", (/"time", "latitude", "longitude"/))
    filevardef(fl_nc_regrid, "t2m", "float", (/"time", "latitude", "longitude"/))

    ; define vars' attributs
    time_att           = True
    time_att@long_name = "time"
    time_att@units     = "months since 1900-01"
    filevarattdef(fl_nc_regrid, "time", time_att)

    yyyymm  = yyyymm_time(1900, 2010, "integer")
;   yyyymmf = yyyymm_to_yyyyfrac(yyyymm, 0.0)
;   fl_nc_regrid->time      = ispan(0, 1331, 1)
    fl_nc_regrid->time      = yyyymm
;   fl_nc_regrid->time@units = "months as YYYYMM"


    longitude_att           = True
    longitude_att@long_name = "longitude"
    longitude_att@units     = "degrees_east"
    filevarattdef(fl_nc_regrid, "longitude", longitude_att)

    latitude_att           = True
    latitude_att@long_name = "latitude"
    latitude_att@units     = "degrees_north"
    filevarattdef(fl_nc_regrid, "latitude", latitude_att)

    fl_nc_regrid->latitude  = fspan(-88.5419, 88.5394, 94 )
    fl_nc_regrid->longitude = fspan(0       , 358.125, 192)
;   print(fl_nc_regrid->latitude )
;   print(fl_nc_regrid->longitude)

    u10_att            = True
    u10_att@long_name  = "10 metre U wind component"
    u10_att@units      = "m s**-1"
    u10_att@_FillValue = 1.e+20
    u10_att@center     = "European Center for Medium-Range Weather Forecasts (RSMC)"
    filevarattdef(fl_nc_regrid, "u10", u10_att)

    v10_att            = True
    v10_att@long_name  = "10 metre V wind component"
    v10_att@units      = "m s**-1"
    v10_att@_FillValue = 1.e+20
    v10_att@center     = "European Center for Medium-Range Weather Forecasts (RSMC)"
    filevarattdef(fl_nc_regrid, "v10", v10_att)

    t2m_att            = True
    t2m_att@long_name  = "2 metre temperature"
    t2m_att@units      = "K"
    t2m_att@_FillValue = 1.e+20
    t2m_att@center     = "European Center for Medium-Range Weather Forecasts (RSMC)"
    filevarattdef(fl_nc_regrid, "t2m", t2m_att)


    ; t2m
    print("Regridding t2m ...")
    do i_lat = 0, 159
        var_mon(:, i_lat, :) = fl_nc_mon->t2m(:, 159 - i_lat, :)
    end do
    fl_nc_regrid->t2m = linint2(lon_mon, lat_mon, var_mon, True, fl_nc_regrid->longitude, fl_nc_regrid->latitude, 0)

    ; u10
    print("Regridding u10 ...")
    do i_lat = 0, 159
        var_mon(:, i_lat, :) = fl_nc_mon->u10(:, 159 - i_lat, :)
    end do
    fl_nc_regrid->u10 = linint2(lon_mon, lat_mon, var_mon, True, fl_nc_regrid->longitude, fl_nc_regrid->latitude, 0)

    ; v10
    print("Regridding v10 ...")
    do i_lat = 0, 159
        var_mon(:, i_lat, :) = fl_nc_mon->v10(:, 159 - i_lat, :)
    end do
    fl_nc_regrid->v10 = linint2(lon_mon, lat_mon, var_mon, True, fl_nc_regrid->longitude, fl_nc_regrid->latitude, 0)
end
