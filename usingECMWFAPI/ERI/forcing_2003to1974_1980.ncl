load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_FORCING   = "/glade/p/work/lgchen/data/MOM5/INPUT"
    DIR_1974_1980 = DIR_FORCING + "/2003to1974_1980"

;   FN_NC_ERI = (/"era_i_mslp_1x1_1999-2008.nc", "era_i_t_2m_1x1_1999-2008.nc", "era_i_q_1x1_1999-2008.nc"  \
;       , "era_i_u_10m_1x1_1999-2008.nc", "era_i_v_10m_1x1_1999-2008.nc", "era_i_strd_1x1_1999-2008.nc"     \
;       , "era_i_ssrd_1x1_1999-2008.nc", "era_i_prcpt_1x1_1999-2008.nc", "era_i_snflt_1x1_1999-2008.nc"/)
    FN_NC_ERI = (/"era_i_mslp_1x1_", "era_i_t_2m_1x1_", "era_i_q_1x1_"  \
        , "era_i_u_10m_1x1_", "era_i_v_10m_1x1_", "era_i_strd_1x1_"     \
        , "era_i_ssrd_1x1_", "era_i_prcpt_1x1_", "era_i_snflt_1x1_"/)

    VAR_NM    = (/"msl", "t2m", "q", "u10", "v10", "strd", "ssrd", "lsp", "lsf"/)
    N_VAR     = dimsizes(VAR_NM)

    fl_nc_t2m = addfile(DIR_FORCING + "/era_i_t_2m_1x1_1999-2008.nc", "r")

    time_att            = True
    time_att@long_name  = "time"
    time_att@units      = "days since 1900-01-01 00:00:00"
    time_att@calendar   = "julian"
    time_att@modulo     = " "
    time_att@modulo_beg = "1974-01-01 00:00:00"
    time_att@modulo_end = "1981-01-01 00:00:00"

    do i_var = 0, N_VAR - 1
        print("i_var = " + i_var)

        fl_nc_eri = addfile(DIR_FORCING + "/" + FN_NC_ERI(i_var) + "1999-2008.nc", "r")

        fl_nc_new = addfile(DIR_1974_1980 + "/" + FN_NC_ERI(i_var) + "1974-1980.nc", "c")

        ; define file/global attributes
        global_att = True
        global_att@description = "ERI forcing from 2003 to 1974-1980"
        fileattdef(fl_nc_new, global_att)

        ; define file dimensions
        dim_names = (/"time", "latitude", "longitude"/)
        dim_sizes = (/2557  , 181       , 360        /)  
        dim_unlim = (/True  , False     , False      /)
        filedimdef(fl_nc_new, dim_names, dim_sizes, dim_unlim)

        ; copy dimension vars directly from old ERI forcing file, no need to define
        fl_nc_new->latitude  = fl_nc_t2m->latitude
        fl_nc_new->longitude = fl_nc_t2m->longitude

        ; define time dimension var
        filevardef(fl_nc_new, "time", "float", (/"time"/))
        filevarattdef(fl_nc_new, "time", time_att)
;       fl_nc_new->time = int2flt(ispan(27028, 29584, 1))

        ; define var and copy attributes
        var_type = "short"
        if (i_var .eq. 2 .or. i_var .eq. 5 .or. i_var .eq. 6 .or. i_var .eq. 7 .or. i_var .eq. 8) then
            var_type = "float"
        end if
;       var_type = "float"

        filevardef(fl_nc_new, VAR_NM(i_var), var_type, (/"time", "latitude", "longitude"/))
        copy_VarAtts(fl_nc_eri->$VAR_NM(i_var)$, fl_nc_new->$VAR_NM(i_var)$)
        fl_nc_new->$VAR_NM(i_var)$(0   :364 , :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1825, :, :)  ; 1974
        fl_nc_new->$VAR_NM(i_var)$(365 :729 , :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1825, :, :)  ; 1975
        fl_nc_new->$VAR_NM(i_var)$(730 :788 , :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1519, :, :)  ; 1976
        fl_nc_new->$VAR_NM(i_var)$(789      , :, :) = fl_nc_eri->$VAR_NM(i_var)$(1519     , :, :)  ; 1976
        fl_nc_new->$VAR_NM(i_var)$(790 :1095, :, :) = fl_nc_eri->$VAR_NM(i_var)$(1520:1825, :, :)  ; 1976
        fl_nc_new->$VAR_NM(i_var)$(1096:1460, :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1825, :, :)  ; 1977
        fl_nc_new->$VAR_NM(i_var)$(1461:1825, :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1825, :, :)  ; 1978
        fl_nc_new->$VAR_NM(i_var)$(1826:2190, :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1825, :, :)  ; 1979
        fl_nc_new->$VAR_NM(i_var)$(2191:2249, :, :) = fl_nc_eri->$VAR_NM(i_var)$(1461:1519, :, :)  ; 1980
        fl_nc_new->$VAR_NM(i_var)$(2250     , :, :) = fl_nc_eri->$VAR_NM(i_var)$(1519     , :, :)  ; 1980
        fl_nc_new->$VAR_NM(i_var)$(2251:2556, :, :) = fl_nc_eri->$VAR_NM(i_var)$(1520:1825, :, :)  ; 1980

        fl_nc_new->time = (/int2flt(ispan(27028, 29584, 1))/)
    end do
end
