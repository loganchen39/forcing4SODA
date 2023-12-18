#!/bin/tcsh -f

#BSUB -P UMCP0006                # project code
#BSUB -W 12:00                    # wall-clock time (hrs:mins)
#BSUB -n 1                       # number of tasks in job         
##BSUB -R "span[ptile=16]"       # run 16 MPI tasks per node
#BSUB -J ERA20C_lat_flip         # job name
#BSUB -o ERA20C_lat_flip.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e ERA20C_lat_flip.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                 # queue
#BSUB -N                         # sends report to you by e-mail when the job finishes


ncap2 -s 'sf=sf*10.0/864.0' era20c_sf_1980_2010.nc era20c_sf_1980_2010_right_unit.nc


