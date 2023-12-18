#!/usr/bin/python
##!/usr/bin/env python

#BSUB -P UMCP0006                            # project code
#BSUB -W 12:00                               # wall-clock time (hrs:mins)
#BSUB -n 1                                   # number of tasks in job         
# #BSUB -R "span[ptile=16]"                  # run 16 MPI tasks per node
#BSUB -J download_ntss         # job name
#BSUB -o download_ntss.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e download_ntss.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                             # queue: small, premium, regular, etc.
#BSUB -N                                     # sends report to you by e-mail when the job finishes

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(2009, 2016):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade/scratch/lgchen/data/eri_stress/" + str(i_yr) + "_ntss.grb" 

    server.retrieve({
        'class'   : "ei",
        'dataset' : "interim",
        'date'    : str_date,
        'expver'  : "1",
        'grid'    : "1/1",
        'levtype' : "sfc",
        'param'   : "181.128",
        'step'    : "3/6/9/12",
        'stream'  : "oper",
        'time'    : "00:00:00/12:00:00",
        'type'    : "fc",
        'target'  : str_target
    })
