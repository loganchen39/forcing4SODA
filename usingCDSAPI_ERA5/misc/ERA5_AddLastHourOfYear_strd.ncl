; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT = "/glade/scratch/lgchen/data/ERA5/netCDF"

    START_YEAR = 1979
    END_YEAR   = 2019

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr      = sprinti("%0.4i", i_yr)
        str_yr_next = sprinti("%0.4i", i_yr+1)
        print("str_yr = " + str_yr)
        
        fn_6hr = "era5_strd_6hr_" + str_yr + ".nc"
        fl_6hr = addfile(DIR_DATA_ROOT + "/hourly/" + fn_6hr, "w")

        fn_1hr = "strd_1stTimestep_" + str_yr_next + ".nc"
        fl_1hr = addfile(DIR_DATA_ROOT + "/hourly/1stTimestep/" + fn_1hr, "r")

        DOFY = 365
        if (i_yr .eq. 1979) then
            DOFY = 364
        else if (isleapyear(i_yr)) then
            DOFY = 366
        else
            DOFY = 365
        end if
        end if

        fl_6hr->strd(DOFY*4-1, :, :) = fl_6hr->strd(DOFY*4-1, :, :) + fl_1hr->var175(0, :, :)

        i_yr = i_yr + 1
    end do

end
