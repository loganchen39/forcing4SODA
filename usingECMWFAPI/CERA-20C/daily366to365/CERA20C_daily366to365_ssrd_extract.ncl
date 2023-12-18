; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT = "/gpfs/fs1/scratch/lgchen/data/CERA-20C/ssrd/nc_daily"

    START_YEAR = 1902
    END_YEAR   = 2010

    LEAP_YEARS = (/1904, 1908, 1912, 1916, 1920, 1924, 1928, 1932, 1936, 1940, 1944, 1948, 1952  \
                 , 1956, 1960, 1964, 1968, 1972, 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008/)

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr      = sprinti("%0.4i", i_yr)
        print("str_yr = " + str_yr)

        str_fn = "CERA20C_ssrd_" + str_yr + ".nc"
        i_time_start = 1
        i_time_end   = 365
        if (any(LEAP_YEARS .eq. i_yr)) then
            print("Leap year, i_yr = " + str_yr)
            i_time_end = 366
            str_cmd = "ncks -d time,1,366 " + DIR_DATA_ROOT + "/" + str_fn + " " + DIR_DATA_ROOT + "/366to365/" + str_fn
        else 
            str_cmd = "ncks -d time,1,365 " + DIR_DATA_ROOT + "/" + str_fn + " " + DIR_DATA_ROOT + "/366to365/" + str_fn
        end if
        system(str_cmd)

        i_yr = i_yr + 1
    end do

end
