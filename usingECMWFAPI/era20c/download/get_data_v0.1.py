#!/usr/bin/env python

from ecmwfapi import ECMWFDataServer

server = ECMWFDataServer()

server.retrieve({
    'dataset' : "era20c",
    'step'    : "24/to/120/by/24",
    'number'  : "all",
    'levtype' : "sl",
    'date'    : "20071001/to/20071003",
    'time'    : "00/12",
    'origin'  : "all",
    'type'    : "pf",
    'param'   : "tp",
    'area'    : "70/-130/30/-60",
    'grid'    : "2/2",
    'target'  : "data.grib"
    })
