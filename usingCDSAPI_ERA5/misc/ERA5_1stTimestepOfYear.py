#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/hourly"

# FN_VAR = ['snowfall', 'tp']
FN_VAR = ['ssrd', 'strd']
START_YEAR = 1980  # 1979
END_YEAR   = 2020

os.chdir(DIR_DATA)

for var in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var, str_yr))
        fn_hourly = var + '_' + str_yr + '.nc'
        fn_1stTimestep  = var + '_1stTimestep_' + str_yr + '.nc'

        c = 86.4
        if var == 'ssrd': c = 10800
        elif var == 'strd': c = 21600
        else: c = 86.4
        
        # the following line is for snow and tp.
      # str_cmd    = "cdo -divc,86.4 -select,timestep=1 " + "./hourly/" + fn_hourly + " " + "./hourly/" + fn_1stTimestep
        # the following line is for ssrd, -divc,10800 corresponds to seconds in 3 hours.
        str_cmd    = "cdo -divc," + str(c) + " -select,timestep=1 " + fn_hourly + " " + fn_1stTimestep
        os.system(str_cmd)
