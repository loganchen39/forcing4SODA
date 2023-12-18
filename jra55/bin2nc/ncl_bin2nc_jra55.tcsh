#!/bin/tcsh

#BSUB -P UMCP0006                   # project code
#BSUB -W 06:00                      # wall-clock time (hrs:mins)
#BSUB -n   1                        # number of tasks in job         
# #BSUB -n 768                      # number of tasks in job         
##BSUB -R "span[ptile=16]"          # run 16 MPI tasks per node
#BSUB -J jra55_bin2nc               # job name
#BSUB -o jra55_bin2nc.%J.out        # output file name in which %J is replaced by the job ID
#BSUB -e jra55_bin2nc.%J.err        # error file name in which %J is replaced by the job ID
#BSUB -q premium                    # queue
# #BSUB -q regular                  # queue
#BSUB -N                            # sends report to you by e-mail when the job finishes

ncl bin2nc_jra55_forcing_19800101to20131231.ncl >&! ncl_bsub_5.log

exit 0
