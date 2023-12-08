#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3
# #!/usr/bin/python


import cdsapi

c = cdsapi.Client()
DIR_DATA = "/glade/scratch/lgchen/data/ERA5forSODA/original/grib"

START_YEAR = 2020
END_YEAR   = 2022

for i_yr in range(START_YEAR, END_YEAR + 1):
    c.retrieve('reanalysis-era5-single-levels',
        {'product_type': 'reanalysis',
         'format'      : 'grib',
         'variable'    : 'surface_thermal_radiation_downwards',
         'year'        : str(i_yr),
         'month'       : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12',],
         'day'         : ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15',
                          '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31',],
         'time'        : ['00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00', '09:00', '10:00', '11:00',
                          '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00',],
        },
        DIR_DATA + '/era5_strd_1hr_' + str(i_yr) + '.grib')
