load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA = "/glade/scratch/lgchen/data/era20c"

    N_DAY = 11323  ; 13149
    NY    = 361
    NX    = 720
 
    N_VAR_ANALYSIS  = 5
    VAR_NM_ANALYSIS = (/"mslp"  , "u10m"  , "v10m"  , "t2m", "dt2m"/)
  ; var = new((/N_VAR_ANALYSIS, N_DAY, NY, NX/), "float", -1.0e20)
    var = new((/                N_DAY, NY, NX/), "float", -1.0e20) 


    ; for analysis
    do i_var = 0, N_VAR_ANALYSIS - 1
        print("i_var = " + sprinti("%0.2i", i_var))
        fl_nc = addfile(DIR_DATA + "/analysis/modified/era20c_" + VAR_NM_ANALYSIS(i_var) + "_1980_2010.nc", "w")
        
        do i_lat = 0, 179
            print("i_lat = " + sprinti("%0.3i", i_lat))

            do i_lon = 0, NX - 1
                print("i_lon = " + sprinti("%0.3i", i_lon))
                var_tmp = fl_nc->$VAR_NM_ANALYSIS(i_var)$(:, i_lat, i_lon)
                fl_nc->$VAR_NM_ANALYSIS(i_var)$(:, i_lat, i_lon) = fl_nc->$VAR_NM_ANALYSIS(i_var)$(:, 360 - i_lat, i_lon)
                fl_nc->$VAR_NM_ANALYSIS(i_var)$(:, 360 - i_lat, i_lon) = var_tmp
            end do
        end do
    end do

end
