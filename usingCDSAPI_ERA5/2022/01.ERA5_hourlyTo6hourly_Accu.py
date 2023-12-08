#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5forSODA/original/netCDF"

FN_VAR = [('snowfall', '1dy', 'var144', "'kg/(m2*s)'", 86.4), ('tp', '1dy', 'var228', "'kg/(m2*s)'", 86.4)  \
    , ('ssrd', '3hr', 'var169', 'W/m2', 10800), ('strd', '6hr', 'var175', 'W/m2', 21600)]
START_YEAR = 2022
END_YEAR   = 2022

os.chdir(DIR_DATA)

for (var_new, xhr, var_old, units, div) in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var_new, str_yr))

        fn_1hr = 'era5_' + var_new + '_1hr_' + str_yr + '.nc'
        fn_xhr = 'era5_' + var_new + '_' + xhr + '_' + str_yr + '.nc'

        # Prepare the CDO str_cmd
        str_cmd = "cdo -setattribute," + var_new + "@units=" + units + " -chname," + var_old + "," + var_new + " -divc," + str(div)
        if var_new == "snowfall" or var_new == "tp": str_cmd += " -daysum "
        elif var_new == "ssrd": str_cmd += " -timselsum,3 "
        else: str_cmd += " -timselsum,6 "
        
        str_cmd += " -shifttime,-1hour "
        if i_yr == START_YEAR:
            # For day 1 of the 1st year, it starts with 7:00 which contains accumulation data during 6:00-7:00,
            # We'll just remove the 1st day. It's only for accumulation vars.
          # str_cmd += " -delete,timestep=1/18 "
            str_cmd += " -delete,timestep=1 "
        else:
            str_cmd += " -delete,timestep=1 "
        str_cmd += "./1hr/" + fn_1hr + " " + "./6hr/" + fn_xhr

        os.system(str_cmd)
