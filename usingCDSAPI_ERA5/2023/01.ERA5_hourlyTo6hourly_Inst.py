# #!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os


DIR_DATA = "/glade/u/home/lgchen/lgchen_scratch_derecho/data/ERA5forSODA/original/netCDF"

FN_VAR = [('dt2m', '6hr', 'var168', 'K'), ('mslp', '6hr', 'var151', 'Pa'), ('t2m', '6hr', 'var167', 'K')  \
       ,  ('u10', '6hr', 'var165', 'm/s'), ('v10', '6hr', 'var166', 'm/s')]
# FN_VAR = [('dt2m', '6hr', 'var168', 'K'), ('mslp', '6hr', 'var151', 'Pa')]

START_YEAR = 2023
END_YEAR   = 2023

os.chdir(DIR_DATA)

for (var_new, xhr, var_old, units) in FN_VAR:
    for i_yr in range(START_YEAR, END_YEAR+1):
        str_yr = str(i_yr)
        print("Currently processing {} for year {}".format(var_new, str_yr))

        fn_1hr = 'era5_' + var_new + '_1hr_' + str_yr + '.nc'
        fn_6hr = 'era5_' + var_new + '_6hr_' + str_yr + '.nc'
        str_cmd   = "cdo -setattribute," + var_new + "@units=" + units + " -chname," + var_old + "," + var_new  \
            + " -timselmean,6 ./1hr/" + fn_1hr + " " + "./6hr/" + fn_6hr
        os.system(str_cmd)
