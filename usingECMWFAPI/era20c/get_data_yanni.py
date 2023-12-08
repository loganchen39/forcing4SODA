#!/usr/bin/python
##!/usr/bin/env python

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

for i_yr in range(1905, 1906):
    str_date   = str(i_yr) + "0101/to/" + str(i_yr) + "1231"
    str_target = "/glade/scratch/lgchen/data/era20c/360by181/" + str(i_yr) + ".grb" 

    server.retrieve({
        'dataset' : "era20c",
        'levtype' : "pl",
        'levelist' : "500",
        'date'    : str_date,
        'time'    : "00/12",
        'type'    : "an",
        'param'   : "129.128",
        'target'  : str_target
    })
