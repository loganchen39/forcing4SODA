#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/pkg-library/20190627/bin/python3
# #!/usr/bin/python

import os
import calendar
import numpy as np
import xarray as xr


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/2021/netCDF"

FN_VAR = [('snowfall', '1dy'), ('tp', '1dy'), ('ssrd', '3hr'), ('strd', '6hr')]
dict_freq = {'3hr':8, '6hr':4, '1dy':1}

START_YEAR = 2021
END_YEAR   = 2021

for (var_new, xhr) in FN_VAR: 
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr      = str(i_yr)
        if i_yr == END_YEAR:
            # For the last year 1978's last hour accumulation data, it uses  the 1st 
            # step of 1978, or actually the last hour data of 1977. 
            str_yr_next = str(i_yr)
        else:
            str_yr_next = str(i_yr + 1)
        print("Currently processing {} for year {} ... ".format(var_new, str_yr))

        fn_xhr    = 'era5_' + var_new + '_' + xhr + '_' + str_yr + '.nc'
        fn_lasthr = 'era5_' + var_new + '_1stTimestep_' + str_yr_next + '.nc'

        ds_xhr    = xr.open_dataset(DIR_DATA + '/6hr/' + fn_xhr)
        ds_lasthr = xr.open_dataset(DIR_DATA + '/1stTimestep/' + fn_lasthr)

        dofy = 365
        if calendar.isleap(i_yr):
            dofy = 366
        elif i_yr == START_YEAR:
          # dofy = 364
            pass
        else:
            dofy = 365

        ds_xhr[var_new][dofy*dict_freq[xhr]-1, :, :] += ds_lasthr[var_new][0, :, :]
        ds_xhr.to_netcdf(DIR_DATA + '/6hr/' + fn_xhr, mode='a')

        ds_xhr.close()
        ds_lasthr.close()
