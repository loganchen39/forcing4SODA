; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT = "/glade/scratch/lgchen/data/ERA5/netCDF"

    START_YEAR = 1979
    END_YEAR   = 2018

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr      = sprinti("%0.4i", i_yr)
        str_yr_next = sprinti("%0.4i", i_yr+1)
        print("str_yr = " + str_yr)
        
        str_fn_1dy = "snowfall_1dy_" + str_yr + ".nc"
        fl_1dy     = addfile(DIR_DATA_ROOT + "/forcing/" + str_fn_1dy, "w")

        str_fn_1hr = "snowfall_1stTimestep_" + str_yr_next + ".nc"
        fl_1hr     = addfile(DIR_DATA_ROOT + "/hourly/" + str_fn_1hr, "r")

        DOFY = 365
        if (i_yr .eq. 1979) then
            DOFY = 364
        else if (isleapyear(i_yr)) then
            DOFY = 366
        else
            DOFY = 365
        end if
        end if

        fl_1dy->var144(DOFY-1, :, :) = fl_1dy->var144(DOFY-1, :, :) + fl_1hr->var144(0, :, :)

        i_yr = i_yr + 1
    end do

end
