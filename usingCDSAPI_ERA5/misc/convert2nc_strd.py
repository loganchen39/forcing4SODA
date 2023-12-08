#!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5"

START_YEAR = 1979
END_YEAR   = 2019

for i_yr in range(START_YEAR, END_YEAR+1):
    fn_grib = 'strd_' + str(i_yr) + '.grib'
    fn_nc   = 'strd_' + str(i_yr) + '.nc'
    str_cmd = 'cdo -b F32 -f nc copy ' + DIR_DATA + '/grib/' + fn_grib + ' ' + DIR_DATA + '/netCDF/' + fn_nc
    os.system(str_cmd)
