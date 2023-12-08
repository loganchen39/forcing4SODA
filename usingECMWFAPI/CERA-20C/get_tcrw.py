#!/usr/bin/python

##!/usr/bin/env python

#PBS  -A UMCP0009
#PBS  -l walltime=12:00:00
#PBS  -l select=1:ncpus=1:mpiprocs=1 
#PBS  -N d2m
#PBS  -j oe
# #PBS  -q regular
#PBS  -q economy

# to download Total column rain water

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(1941, 2010):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade2/scratch2/lgchen/data/CERA-20C/tcrw/tcrw_" + str(i_yr) + ".grb" 

    server.retrieve({
        'class'   : "ep",
        'dataset' : "cera20c",
        'date'    : str_date,
        'expver'  : "1",
        'grid'    : "1/1",
        'levtype' : "sfc",
        'param'   : "89.228",
        'step'    : "0",
        'stream'  : "enda",
        'time'    : "00:00:00/03:00:00/06:00:00/09:00:00/12:00:00/15:00:00/18:00:00/21:00:00",
        'type'    : "em",
        'target'  : str_target
    })


# str_date   =  "20170101/to/20170831"
# str_target = "/glade/scratch/lgchen/data/eri_2016to2017/t2m_20170831.grb"
# 
# server.retrieve({
#     'class'   : "ei",
#     'dataset' : "interim",
#     'date'    : str_date,
#     'expver'  : "1",
#     'grid'    : "1/1",
#     'levtype' : "sfc",
#     'param'   : "167.128",
#     'step'    : "0",
#     'stream'  : "oper",
#     'time'    : "00:00:00/06:00:00/12:00:00/18:00:00",
#     'type'    : "an",
#     'target'  : str_target
# })
