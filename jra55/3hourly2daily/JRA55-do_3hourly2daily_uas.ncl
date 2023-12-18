; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT = "/gpfs/fs1/p/univ/umcp0009/lgchen/data/JRA55-do/uas"
    STR_FN_PREFIX = "uas_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-3_gn_"

    START_YEAR = 1958
    END_YEAR   = 2017

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr      = sprinti("%0.4i", i_yr)
        str_yr_next = sprinti("%0.4i", i_yr+1)
      ; print("str_yr = " + str_yr)
        
        str_fn_yr          = str_yr + "01010000-" + str_yr + "12312230"
        str_fn_3hourly     = STR_FN_PREFIX + str_fn_yr + ".nc"
        str_abs_fn_3hourly = DIR_DATA_ROOT + "/3hourly/" + str_fn_3hourly

        str_fn_daily       = "uas_" + str_yr + ".nc"
        str_abs_fn_daily   = DIR_DATA_ROOT + "/daily/" + str_fn_daily
 
        str_cmd = "cdo dayavg " + str_abs_fn_3hourly + " " + str_abs_fn_daily
        print("str_cmd = " + str_cmd)
        system(str_cmd)
 
        i_yr = i_yr + 1
    end do

end
