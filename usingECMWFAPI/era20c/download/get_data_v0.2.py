#!/usr/bin/python
##!/usr/bin/env python

#BSUB -P UMCP0006            # project code
#BSUB -W 02:00               # wall-clock time (hrs:mins)
#BSUB -n 1                   # number of tasks in job         
# #BSUB -R "span[ptile=16]"  # run 16 MPI tasks per node
#BSUB -J download_era20c     # job name
#BSUB -o download_era20c.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e download_era20c.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium             # queue: small, premium, regular, etc.
#BSUB -N                     # sends report to you by e-mail when the job finishes

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(1905, 1906):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade/scratch/lgchen/data/era20c/360by181/" + str(i_yr) + ".grb" 

    server.retrieve({
        'dataset' : "era20c",
        'levtype' : "sfc",
        'grid'    : "1/1",
        'date'    : str_date,
        'time'    : "00/12",
        'type'    : "an",
        'param'   : "165.128/166.128/167.128",
        'target'  : str_target
    })
