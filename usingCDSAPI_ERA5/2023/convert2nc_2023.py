# #!/usr/bin/python

import os


DIR_DATA = "/glade/u/home/lgchen/lgchen_scratch_derecho/data/ERA5forSODA/original"

START_YEAR = 2023
END_YEAR   = 2023

FN_VAR = ['dt2m', 'mslp', 'snowfall', 'ssrd', 'strd', 't2m', 'tp', 'u10', 'v10']

for var in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        fn_grib = 'era5_' + var + '_1hr_' + str(i_yr) + '.grib'
        fn_nc   = 'era5_' + var + '_1hr_' + str(i_yr) + '.nc'
        str_cmd = 'cdo -b F32 -f nc copy ' + DIR_DATA + '/grib/' + fn_grib + ' ' + DIR_DATA + '/netCDF/1hr/' + fn_nc
        os.system(str_cmd)
