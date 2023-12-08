#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF"

# FN_VAR = ['dt2m', 'mslp', 't2m', 'u10', 'v10']
FN_VAR   = ['sst']
START_YEAR = 1979
END_YEAR   = 1982  # 2019

os.chdir(DIR_DATA)

for var in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var, str_yr))
        fn_hourly = var + '_' + str_yr + '.nc'
        fn_6hr    = 'era5_' + var + '_6hr_' + str_yr + '.nc'
      # str_cmd   = "cdo timselmean,6 " + "./hourly/" + fn_hourly + " " + "./forcing/" + fn_6hr
        str_cmd   = "cdo timselmean,6 " + "./hourly/" + fn_hourly + " " + "./hourly/coare4/" + fn_6hr
        os.system(str_cmd)
