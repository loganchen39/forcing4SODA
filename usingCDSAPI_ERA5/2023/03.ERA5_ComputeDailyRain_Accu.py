# #!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os


DIR_DATA = "/glade/u/home/lgchen/lgchen_scratch_derecho/data/ERA5forSODA/original/netCDF/6hr"

START_YEAR = 2023
END_YEAR   = 2023

os.chdir(DIR_DATA)
for i_yr in range(START_YEAR, END_YEAR+1):
    str_yr = str(i_yr)
    print("Currently processing for year {}".format(str_yr))
    fn_tp       = 'era5_tp_1dy_' + str_yr + '.nc'
    fn_sf       = 'era5_snowfall_1dy_' + str_yr + '.nc'
    fn_rain_tmp = 'era5_rain_1dy_' + str_yr + '_tmp.nc'
    str_cmd     = 'cdo sub ' + fn_tp + ' ' + fn_sf + ' ' + fn_rain_tmp
    os.system(str_cmd)
   
    fn_rain = 'era5_rain_1dy_' + str_yr + '.nc'
    str_cmd = "cdo -setattribute,rain@units='kg/m2*sec' -chname,tp,rain -setrtoc,-1.e99,0,0 "  \
            + fn_rain_tmp + " " + fn_rain
    os.system(str_cmd)

    str_cmd = "ncatted -a code,rain,d,, " + fn_rain
    os.system(str_cmd)
    str_cmd = "ncatted -a table,rain,d,, " + fn_rain
    os.system(str_cmd)
    str_cmd = "rm " + fn_rain_tmp
    os.system(str_cmd)
