#!/bin/tcsh

#BSUB -P UMCP0006                   # project code
#BSUB -W 06:00                      # wall-clock time (hrs:mins)
#BSUB -n   1                        # number of tasks in job         
# #BSUB -n 768                      # number of tasks in job         
##BSUB -R "span[ptile=16]"          # run 16 MPI tasks per node
#BSUB -J merra2_bin2nc         # job name
#BSUB -o merra2_bin2nc.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e merra2_bin2nc.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                    # queue
# #BSUB -q regular                  # queue
#BSUB -N                            # sends report to you by e-mail when the job finishes

ncl bin2nc_merra2_forcing_v10m_1980_2015.ncl >&! ncl_bsub_6.log

exit 0
