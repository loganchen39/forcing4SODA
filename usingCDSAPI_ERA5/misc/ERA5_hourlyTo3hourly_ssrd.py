#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/hourly"

FN_VAR = ['ssrd']
START_YEAR = 1980  # 1979
END_YEAR   = 2019

os.chdir(DIR_DATA)
for var in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var, str_yr))
        fn_hourly = var + '_' + str_yr + '.nc'
        fn_3hr    = "era5_" + var + '_3hr_' + str_yr + '.nc'
      # str_cmd   = "cdo timselmean,3 " + "./hourly/" + fn_hourly + " " + "./forcing/" + fn_3hr
        str_cmd   = "cdo -setattribute,ssrd@units='W/m2' -chname,var169,ssrd -divc,10800. -timselsum,3 -delete,timestep=1 -shifttime,-1hour " + fn_hourly + " " + fn_3hr
        os.system(str_cmd)
