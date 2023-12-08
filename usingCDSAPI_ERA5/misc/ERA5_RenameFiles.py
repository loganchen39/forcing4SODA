#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

# #!/usr/bin/python

import os


DIR_DATA = "/glade/scratch/lgchen/data/ERA5/netCDF/forcing"

# FN_VAR = [('dt2m', '6hr'), ('mslp', '6hr'), ('q2m', '6hr'), ('rain', '1dy'), ('snowfall', '1dy'), ('ssrd', '3hr'), ('strd', '6hr'), ('t2m', '6hr'), ('tp', '1dy'), ('u10', '6hr'), ('v10', '6hr')]
FN_VAR = [('dt2m', '6hr'), ('mslp', '6hr'), ('rain', '1dy'), ('snowfall', '1dy'), ('t2m', '6hr'), ('tp', '1dy'), ('u10', '6hr'), ('v10', '6hr')]

START_YEAR = 1979
END_YEAR   = 2019

os.chdir(DIR_DATA)

# for i_idx in range(len(FN_VAR)):
for (var, xhr) in FN_VAR:  # what if ['dt2m', '6hr']?
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var, str_yr))

        fn_from    = var + '_' + xhr + '_' + str_yr + '.nc'
        fn_to      = 'era5_' + fn_from
        str_cmd    = "mv " + fn_from + " " + fn_to
        os.system(str_cmd)
