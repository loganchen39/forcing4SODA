#!/usr/bin/python

##!/usr/bin/env python

#PBS  -A UMCP0009
#PBS  -l walltime=12:00:00
#PBS  -l select=1:ncpus=1:mpiprocs=1 
#PBS  -N d2m
#PBS  -j oe
# #PBS  -q regular
#PBS  -q economy

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(2016, 2018):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade/scratch/lgchen/data/eri_2016to2017/tp_" + str(i_yr) + ".grb" 

    server.retrieve({
        'class'   : "ei",
        'dataset' : "interim",
        'date'    : str_date,
        'expver'  : "1",
        'grid'    : "1/1",
        'levtype' : "sfc",
        'param'   : "228.128",
        'step'    : "3/6/9/12",
        'stream'  : "oper",
        'time'    : "00:00:00/12:00:00",
        'type'    : "fc",
        'target'  : str_target
    })


# str_date   =  "20170101/to/20170831"
# str_target = "/glade/scratch/lgchen/data/eri_2016to2017/tp_20170831.grb"
# 
# server.retrieve({
#     'class'   : "ei",
#     'dataset' : "interim",
#     'date'    : str_date,
#     'expver'  : "1",
#     'grid'    : "1/1",
#     'levtype' : "sfc",
#     'param'   : "228.128",
#     'step'    : "3/6/9/12",
#     'stream'  : "oper",
#     'time'    : "00:00:00/12:00:00",
#     'type'    : "fc",
#     'target'  : str_target
# })
