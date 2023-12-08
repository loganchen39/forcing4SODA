#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/hourly"

START_YEAR = 1979  # 1980
END_YEAR   = 1979  # 2019

os.chdir(DIR_DATA)
for i_yr in range(START_YEAR, END_YEAR+1):
    print( "Currently processing for year {}".format(str(i_yr)) )

    fn_org = 'era5_sst_6hr_' + str(i_yr) + '.nc'
    os.system('mv ' + fn_org + ' tmp01.nc')
    os.system('ncrename -v var34,sst tmp01.nc tmp02.nc')
    os.system("ncatted -a units,sst,c,c,'K' tmp02.nc")
    os.system('mv tmp02.nc ' + fn_org)
    os.system('rm tmp01.nc')
