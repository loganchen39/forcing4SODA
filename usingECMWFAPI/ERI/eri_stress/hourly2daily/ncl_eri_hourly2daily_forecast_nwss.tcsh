#!/bin/tcsh

#BSUB -P UMCP0006                # project code
#BSUB -W 12:00                    # wall-clock time (hrs:mins)
#BSUB -n 1                       # number of tasks in job         
##BSUB -R "span[ptile=16]"       # run 16 MPI tasks per node
#BSUB -J era20c_snowfall_6hr2daily   # job name
#BSUB -o era20c_snowfall_6hr2daily.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e era20c_snowfall_6hr2daily.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                 # queue
#BSUB -N                         # sends report to you by e-mail when the job finishes

ncl eri_hourly2daily_forecast_nwss.ncl >&! ncl_bsub_nwss_1.log

exit 0
