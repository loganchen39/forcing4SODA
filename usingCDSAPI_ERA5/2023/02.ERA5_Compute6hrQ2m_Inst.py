# #!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os


DIR_DATA = "/glade/u/home/lgchen/lgchen_scratch_derecho/data/ERA5forSODA/original/netCDF/6hr"

START_YEAR = 2023
END_YEAR   = 2023

os.chdir(DIR_DATA)
for i_yr in range(START_YEAR, END_YEAR+1):
    str_yr = str(i_yr)
    print("Currently processing for year {}".format(str_yr))
    fn_dt2m     = 'era5_dt2m_6hr_'    + str_yr + '.nc'
    fn_mslp     = 'era5_mslp_6hr_'    + str_yr + '.nc'
    fn_combine  = 'era5_combine_6hr_' + str_yr + '.nc'
    str_cmd     = 'cdo merge ' + fn_dt2m + ' ' + fn_mslp + ' ' + fn_combine
    os.system(str_cmd)
    
    fn_q2m  = 'era5_q2m_6hr_' + str_yr + '.nc'
  # str_cmd = "cdo -setattribute,q2m@units='kg/kg' -expr,'q2m=0.62188*(611.21*exp(17.502*(var168-273.16)/(var168-32.19)))/(var151-(1-0.62188)*(611.21*exp(17.502*((var168-273.16)/(var168-32.19)))));' " \
  #         + fn_combine + " " + fn_q2m
    str_cmd = "cdo -setattribute,q2m@units='kg/kg' -expr,'q2m=0.62188*(611.21*exp(17.502*(dt2m-273.16)/(dt2m-32.19)))/(mslp-(1-0.62188)*(611.21*exp(17.502*((dt2m-273.16)/(dt2m-32.19)))));' " \
            + fn_combine + " " + fn_q2m
    os.system(str_cmd)
    str_cmd = "rm " + fn_combine
    os.system(str_cmd)
