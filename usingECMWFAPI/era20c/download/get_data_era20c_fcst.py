#!/usr/bin/python
##!/usr/bin/env python

#BSUB -P UMCP0006            # project code
#BSUB -W 12:00               # wall-clock time (hrs:mins)
#BSUB -n 1                   # number of tasks in job         
# #BSUB -R "span[ptile=16]"  # run 16 MPI tasks per node
#BSUB -J download_era20c_fcst     # job name
#BSUB -o download_era20c_fcst.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e download_era20c_fcst.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium             # queue: small, premium, regular, etc.
#BSUB -N                     # sends report to you by e-mail when the job finishes

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(1980, 1981):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade/scratch/lgchen/data/era20c/fcst/" + str(i_yr) + ".grb" 

    server.retrieve({
        'dataset' : "era20c",
        'class'   : "e2",
        'levtype' : "sfc",
        'grid'    : "0.5/0.5",
        'date'    : str_date,
        'time'    : "0600",
        'step'    : "3/6/9/12/15/18/21/24/27",
        'type'    : "fc",
        'expver'  : "0001",
        'repres'  : "sh",
        'stream'  : "oper",
        'domain'  : "g",
        'padding' : "0",
        'expect'  : "any",
        'param'   : "169.128/175.128/228.128",
        'target'  : str_target
    })
