#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/forcing"

# FN_VAR = ['dt2m', 'mslp', 'snowfall', 'ssrd', 'strd', 't2m', 'tp', 'u10', 'v10']
# FN_VAR = ['snowfall', 'tp']
FN_VAR = ['rain']

START_YEAR = 1979
END_YEAR   = 2019

os.chdir(DIR_DATA)

for var in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var, str_yr))
        fn_daily   = var + '_1dy_' + str_yr + '.nc'
        fn_monthly = var + '_1mn_' + str_yr + '.nc'
        str_cmd    = "cdo setday,15 -monmean " + fn_daily + " " + fn_monthly
        os.system(str_cmd)
