#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5forSODA/original/netCDF"

FN_VAR = [('snowfall', '1dy', 'var144', "'kg/(m2*s)'", 86.4), ('tp', '1dy', 'var228', "'kg/(m2*s)'", 86.4) \
       ,  ('ssrd', '3hr', 'var169', 'W/m2', 10800), ('strd', '6hr', 'var175', 'W/m2', 21600)]
START_YEAR = 2022
END_YEAR   = 2022

os.chdir(DIR_DATA)

for (var_new, xhr, var_old, units, div) in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var_new, str_yr))
        fn_1hr = 'era5_' + var_new + '_1hr_' + str_yr + '.nc'
        fn_1stTimestep  = "era5_" + var_new + '_1stTimestep_' + str_yr + '.nc'

        # div is used to change the original units to target units, see my CDO blog.
        # Here it's already changed to per day, per 3-hour or per 6-hour, not just per hour, 
        # so it can be added to daily or 6-hourly files directly later.
        str_cmd    = "cdo -setattribute," + var_new + "@units=" + units + " -chname," + var_old + "," + var_new  \
            + " -divc," + str(div) + " -select,timestep=1 ./1hr/" + fn_1hr + " ./1stTimestep/" + fn_1stTimestep
        os.system(str_cmd)
