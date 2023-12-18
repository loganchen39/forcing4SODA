#!/bin/tcsh -f

set time =  '1999-2008.nc'
set par  =  'q_1x1_'

set namein  = ORIGINAL/era_interim_$par$time
set nameout = 4MOM5/era_i_$par$time

echo $namein
echo $nameout
echo ''

ncap2 -s 'q=float((0.622*611.21*exp(17.502*(d2m-273.16)/(d2m+32.19)))/(msl-(1-0.622)*611.21*exp(17.502*(d2m-273.16)/(d2m+32.19))))' -o pr.nc $namein
echo 'specific humidity is calculated'

ncks -x -v d2m,msl -o dum.nc pr.nc
echo 'specific humidity extracted'

ncatted -a long_name,q,m,c,"2m specific humidity" -a units,q,m,c,"kg/kg" dum.nc
echo 'specific humidity attributes are edited'

rm -f pr.nc
ncatted -a modulo,longitude,c,d,360.0 -a axis,longitude,c,c,X -a axis,latitude,c,c,Y -o pr.nc dum.nc
echo 'space atributes are edited'

ncpdq -O -a -latitude -o dum.nc pr.nc
echo 'latitude is reodered to S -> N'

rm -f pr.nc
ncap2 -s 'time=float(time/24)' -o pr.nc dum.nc
echo 'time axis is converted from hours to days'

rm -f dum.nc
ncatted -a units,time,m,c,"days since 1900-01-01 00:00:00" -a calendar,time,c,c,"julian" -o dum.nc pr.nc
echo 'time attributes are edited'

rm -f pr.nc
ncks -q --mk_rec_dmn time -o $nameout dum.nc
echo 'time dimensions is unlimitted now'
rm -f dum.nc
