#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/pkg-library/20190627/bin/python3

import os
import calendar
import numpy as np
import xarray as xr
# import Nio


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/6hourly"

FN_VAR   = [('dt2m', '6hr', False), ('mslp', '6hr', False), ('q2m', '6hr', False), ('rain', '1dy', True)  \
         ,  ('snowfall', '1dy', True), ('ssrd', '3hr', True), ('strd', '6hr', True), ('t2m', '6hr', False)  \
         ,  ('tp', '1dy', True), ('u10', '6hr', False), ('v10', '6hr', False)]

START_YEAR = 1950
END_YEAR   = 1978

dict_jday = {} 
dict_jday[1950] = 18262  # corresponds to 19500101-00:00:00
# dict_jday[1979] = 28854  # corresponds to 19790101-00:00:00
for i_yr in range(START_YEAR+1, END_YEAR+1):
    dofy = 365
    if calendar.isleap(i_yr-1): 
        dofy = 366
    dict_jday[i_yr] = dict_jday[i_yr-1] + dofy
# print(dict_jday)

dict_freq = {'3hr':8, '6hr':4, '1dy':1}

os.chdir(DIR_DATA)

for (var, xhr, is_accu) in FN_VAR:  
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {} ... ".format(var, str_yr))

        fn_org = 'era5_' + var + '_' + xhr + '_' + str_yr + '.nc'
        os.rename(fn_org, 'tmp00.nc')
 
        # process time units with ncatted, which does not require an output file
        os.system('ncatted -a bounds,time,d,, tmp00.nc')
        os.system("ncatted -a units,time,m,c,'days since 1900-01-01 00:00:00' tmp00.nc")

        # reverse lat
        os.system('cdo -invertlat tmp00.nc tmp01.nc')
        # cdo does not support julian, so need to put it after cdo.
        os.system("ncatted -a calendar,time,m,c,'julian' tmp01.nc")

        # remove var time_bnds
        os.system('ncks -x -v time_bnds tmp01.nc tmp02.nc')

        # reset time value with dict_jday and xhr, how to use these external vars with CDO expr and ncap2??
        # Previously we used PyNio successfully, now we'll switch to use xarray.
        ds     = xr.open_dataset('./tmp02.nc')
      # tm_var = ds['time']
        tm_sz  = ds.dims['time']
        print('tm_sz = ' + str(tm_sz))

        dofy = 365
        if i_yr == 1950 and is_accu:
            dofy = 364
        elif calendar.isleap(i_yr):
            dofy = 366

        assert tm_sz == dofy * dict_freq[xhr], 'The size of time var is wrong, var = ' + var + ', i_yr = ' + str(i_yr)

        start_jday = dict_jday[i_yr]
        if i_yr == 1950 and is_accu:
            start_jday += 1

        tm_na = np.zeros(tm_sz)
        
        i_tm = 0
        for i_jdy in range(start_jday, start_jday + dofy): 
            for i_freq in range(0, dict_freq[xhr]):
              # ds['time'][i_tm] = i_jdy + i_freq*(1.0/dict_freq[xhr])
                tm_na[i_tm] = i_jdy + i_freq*(1.0/dict_freq[xhr])
                i_tm += 1

        ds['time'] = tm_na

        ds.to_netcdf('./tmp02.nc', mode='a')
        ds.close()
        
        os.rename('tmp02.nc', fn_org)

      # os.remove('tmp*.nc')
        os.system('rm tmp*.nc')
