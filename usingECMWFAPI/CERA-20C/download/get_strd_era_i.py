#!/usr/bin/python

##!/usr/bin/env python

#PBS  -A UMCP0009
#PBS  -l walltime=12:00:00
#PBS  -l select=1:ncpus=1:mpiprocs=1 
#PBS  -N strd_era_i
#PBS  -j oe
# #PBS  -q regular
#PBS  -q economy

# to download Surface thermal radiation downwards

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

# for i_yr in range(1928, 1941):
#     str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
#     str_target = "/glade2/scratch2/lgchen/data/CERA-20C/strd/strd_" + str(i_yr) + ".grb" 
# 
#     server.retrieve({
#         'class'   : "ep",
#         'dataset' : "cera20c",
#         'date'    : str_date,
#         'expver'  : "1",
#         'grid'    : "1/1",
#         'levtype' : "sfc",
#         'param'   : "175.128",
#         'step'    : "3/6/9/12/15/18/21/24/27",
#         'stream'  : "enda",
#         'time'    : "18:00:00",
#         'type'    : "em",
#         'target'  : str_target
#     })


str_date   =  "2006-01-01/to/2006-01-31"
str_target = "./strd_era_i_200601.grb"

server.retrieve({
    'class'   : "ei",
    'dataset' : "interim",
    'date'    : str_date,
    'expver'  : "1",
    'grid'    : "1/1",
    'levtype' : "sfc",
    'param'   : "175.128",
    'step'    : "3/6/9/12",
    'stream'  : "oper",
    'time'    : "00:00:00/12:00:00",
    'type'    : "fc",
    'target'  : str_target
})
