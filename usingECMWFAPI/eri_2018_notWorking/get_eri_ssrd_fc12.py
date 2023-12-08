#!/usr/bin/python

##!/usr/bin/env python

#PBS  -A UMCP0009
#PBS  -l walltime=12:00:00
#PBS  -l select=1:ncpus=1:mpiprocs=1 
#PBS  -N ssrd_fc12
#PBS  -j oe
# #PBS  -q regular
#PBS  -q economy

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(2018, 2019):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade/scratch/lgchen/data/eri_2018/ssrd_fc12_" + str(i_yr) + ".grb" 

    server.retrieve({
        'class'   : "ei",
        'dataset' : "interim",
        'date'    : str_date,
        'expver'  : "1",
        'grid'    : "1/1",
        'levtype' : "sfc",
        'param'   : "169.128",
        'step'    : "12",
        'stream'  : "oper",
        'time'    : "12:00:00",
        'type'    : "fc",
        'target'  : str_target
    })


# str_date   =  "20170101/to/20170831"
# str_target = "/glade/scratch/lgchen/data/eri_2016to2017/ssrd_fc12_20170831.grb"
# 
# server.retrieve({
#     'class'   : "ei",
#     'dataset' : "interim",
#     'date'    : str_date,
#     'expver'  : "1",
#     'grid'    : "1/1",
#     'levtype' : "sfc",
#     'param'   : "169.128",
#     'step'    : "12",
#     'stream'  : "oper",
#     'time'    : "12:00:00",
#     'type'    : "fc",
#     'target'  : str_target
# })
