#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/forcing"

START_YEAR = 1979
END_YEAR   = 2019

os.chdir(DIR_DATA)
for i_yr in range(START_YEAR, END_YEAR+1):
    str_yr = str(i_yr)
    print("Currently processing for year {}".format(str_yr))
    fn_tp       = 'tp_1dy_' + str_yr + '.nc'
    fn_sf       = 'snowfall_1dy_' + str_yr + '.nc'
    fn_rain_tmp = 'rain_1dy_' + str_yr + '_tmp.nc'
    str_cmd     = 'cdo sub ' + fn_tp + ' ' + fn_sf + ' ' + fn_rain_tmp
    os.system(str_cmd)
    
    fn_rain = 'rain_1dy_' + str_yr + '.nc'
    str_cmd = "cdo -setattribute,rain@units='kg/m2*sec' -chname,var228,rain -setrtoc,-1.e99,0,0 " + fn_rain_tmp + " " + fn_rain
    os.system(str_cmd)
    str_cmd = "rm " + fn_rain_tmp
    os.system(str_cmd)
