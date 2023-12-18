; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT = "/gpfs/fs1/scratch/lgchen/data/CERA-20C/d2m"
  ; STR_FN_PREFIX = "tas_input4MIPs_atmosphericState_OMIP_MRI-JRA55-do-1-3_gn_"

    START_YEAR = 1901
    END_YEAR   = 2010

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr      = sprinti("%0.4i", i_yr)
        str_yr_next = sprinti("%0.4i", i_yr+1)
        print("str_yr = " + str_yr)
        
        str_fn_yr            = str_yr + "01010000-" + str_yr + "12312230"
        str_fn_3hourly       = "d2m_" + str_yr + ".grb"
        str_abs_fn_3hourly   = DIR_DATA_ROOT + "/grb_3hourly/" + str_fn_3hourly

        str_fn_daily_tmp     = "CERA20C_d2m_" + str_yr + ".nc.tmp"
        str_abs_fn_daily_tmp = DIR_DATA_ROOT + "/nc_daily/" + str_fn_daily_tmp
        str_fn_daily         = "CERA20C_d2m_" + str_yr + ".nc"
        str_abs_fn_daily     = DIR_DATA_ROOT + "/nc_daily/" + str_fn_daily
 
        str_cmd = "cdo -f nc dayavg " + str_abs_fn_3hourly + " " + str_abs_fn_daily_tmp
      ; print("str_cmd = " + str_cmd)
        system(str_cmd)

        str_cmd = "ncrename -v var168,d2m " + str_abs_fn_daily_tmp + " " + str_abs_fn_daily
        system(str_cmd)

        str_cmd = "rm " + str_abs_fn_daily_tmp
        system(str_cmd)

        i_yr = i_yr + 1
    end do

end
