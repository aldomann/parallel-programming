#!/bin/bash
NX=$1; NY=$2; NZ=$3; binary=$4

if [ ! -f perf-res-diff.csv ]; then
	echo "iter,nx,ny,nz,cycl,inst,time" > perf-res-diff.csv
fi

perf stat -o perf-out.txt -e cycles,instructions ./$binary $NX $NY $NZ | awk '{ print $8 }' ORS="," >> perf-res-diff.csv
awk '/stats/ { printf ("%d,%d,%d,", $6, $7, $8) }' perf-out.txt >> perf-res-diff.csv
awk '/cycles/ { gsub(/,/,"",$1); print $1 }' ORS="," perf-out.txt >> perf-res-diff.csv
awk '/instructions/ { gsub(/,/,"",$1); print $1 }' ORS="," perf-out.txt >> perf-res-diff.csv
awk '/elapsed/ { print $1 }' perf-out.txt >> perf-res-diff.csv

rm perf-out.txt
