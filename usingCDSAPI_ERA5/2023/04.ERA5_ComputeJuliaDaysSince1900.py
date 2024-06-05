# #!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/pkg-library/20190627/bin/python3
# #!/usr/bin/python

import os
import calendar


START_YEAR = 1900
END_YEAR   = 2023

dict_jday = {}
dict_jday[1900] = 0

for i_yr in range(START_YEAR+1, END_YEAR+1):
    dofy = 365
    if calendar.isleap(i_yr-1): 
        dofy = 366
    dict_jday[i_yr] = dict_jday[i_yr-1] + dofy
    print("i_yr = " + str(i_yr) + ", jday = " + str(dict_jday[i_yr]))
