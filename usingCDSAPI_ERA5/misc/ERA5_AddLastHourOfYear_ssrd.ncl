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
        
        str_fn_3hr = "era5_ssrd_3hr_" + str_yr + ".nc"
        fl_3hr     = addfile(DIR_DATA_ROOT + "/hourly/" + str_fn_3hr, "w")

        str_fn_1hr = "ssrd_1stTimestep_" + str_yr_next + ".nc"
        fl_1hr     = addfile(DIR_DATA_ROOT + "/hourly/1stTimestep/" + str_fn_1hr, "r")

        DOFY = 365
        if (i_yr .eq. 1979) then
            DOFY = 364
        else if (isleapyear(i_yr)) then
            DOFY = 366
        else
            DOFY = 365
        end if
        end if

        fl_3hr->ssrd(DOFY*8-1, :, :) = fl_3hr->ssrd(DOFY*8-1, :, :) + fl_1hr->var169(0, :, :)

        i_yr = i_yr + 1
    end do

end
