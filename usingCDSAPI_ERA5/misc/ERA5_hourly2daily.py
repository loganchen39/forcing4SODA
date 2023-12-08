#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF"

FN_VAR = ['snowfall', 'tp']
# FN_VAR = ['snowfall']
START_YEAR = 1980  # 1979
END_YEAR   = 2019

os.chdir(DIR_DATA)

for var in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var, str_yr))
        fn_hourly = var + '_' + str_yr + '.nc'
        fn_daily  = var + '_1dy_' + str_yr + '.nc'
        str_cmd    = "cdo -divc,86.4 -daysum -delete,timestep=1 -shifttime,-1hour " + "./hourly/" + fn_hourly + " " + "./forcing/" + fn_daily
        os.system(str_cmd)
