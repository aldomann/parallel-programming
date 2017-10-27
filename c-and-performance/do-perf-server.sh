#!/bin/bash
NX=$1; NY=$2; NZ=$3; executable=$4; perfoutfile=$5

if [ ! -f $perfoutfile ]; then
	touch $perfoutfile
	echo "iter,nx,ny,nz,cycl,inst,time" >> $perfoutfile
fi

perf stat -o perf-out.txt -e cycles,instructions ./$executable $NX $NY $NZ | awk '{ print $8 }' ORS="," >> $perfoutfile
awk '/stats/ { printf ("%d,%d,%d,", $6, $7, $8) }' perf-out.txt >> $perfoutfile
awk '/cycles/ { gsub(/\./,"",$1); print $1 }' ORS="," perf-out.txt >> $perfoutfile
awk '/instructions/ { gsub(/\./,"",$1); print $1 }' ORS="," perf-out.txt >> $perfoutfile
awk '/elapsed/ { gsub(/,/,".",$1);print $1 }' perf-out.txt >> $perfoutfile

rm perf-out.txt
