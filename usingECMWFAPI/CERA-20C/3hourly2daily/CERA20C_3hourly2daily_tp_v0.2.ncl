; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT = "/gpfs/fs1/scratch/lgchen/data/CERA-20C/tp"

    N_LAT   = 181
    N_LON   = 360
    var_rec = new((/N_LAT, N_LON/), "float")

    START_YEAR = 1901
    END_YEAR   = 2010

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr      = sprinti("%0.4i", i_yr)
        str_yr_next = sprinti("%0.4i", i_yr+1)
        print("str_yr = " + str_yr)
        
        str_fn_3hourly       = "tp_" + str_yr + ".grb"
        fl_grb = addfile(DIR_DATA_ROOT + "/grb_3hourly/" + str_fn_3hourly, "r")

        str_fn_daily         = "CERA20C_tp_" + str_yr + ".nc"
        str_abs_fn_daily     = DIR_DATA_ROOT + "/nc_daily/366to365/" + str_fn_daily
        fl_nc_daily          = addfile(str_abs_fn_daily, "w")

        DOFY = 365
        if (isleapyear(i_yr)) then
            DOFY = 366
        end if

      ; fl_nc_daily->tp(0, :, :) = (/var_rec/)

        if (i_yr .eq. START_YEAR) then
            do i_day = 1, DOFY - 1
                fl_nc_daily->tp(i_day, :, :) = (/fl_grb->TP_GDS0_SFC(i_day-1, 7, :, :)/)
            end do
            fl_nc_daily->tp(365, :, :) = (/fl_grb->TP_GDS0_SFC(364, 7, :, :)/)
        else
            do i_day = 0, DOFY - 1
                fl_nc_daily->tp(i_day, :, :) = (/fl_grb->TP_GDS0_SFC(i_day, 7, :, :)/)
            end do
        end if

      ; var_rec = (/fl_grb->TP_GDS0_SFC(DOFY - 1, 7, :, :)/)

 
        i_yr = i_yr + 1
    end do

end
