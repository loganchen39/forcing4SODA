#!/bin/tcsh

#BSUB -P UMCP0006                # project code
# #BSUB -W 12:00                 # wall-clock time (hrs:mins)
#BSUB -W 06:00                   # wall-clock time (hrs:mins)
#BSUB -n 1                       # number of tasks in job         
##BSUB -R "span[ptile=16]"       # run 16 MPI tasks per node
#BSUB -J ewss                    # job name
#BSUB -o ewss.%J.out             # output file name in which %J is replaced by the job ID
#BSUB -e ewss.%J.err             # error file name in which %J is replaced by the job ID
#BSUB -q premium                 # queue
#BSUB -N                         # sends report to you by e-mail when the job finishes

ncl eri_hourly2daily_forecast_ewss_1979_2016_Gena.ncl >&! ncl_bsub_ewss_1979_2016_1.log

exit 0
