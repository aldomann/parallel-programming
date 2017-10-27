#!/bin/bash
NX=$1
NY=$2
NZ=$3
binary=$4

if [ ! -f perf-res-diff.csv ]; then
	touch perf-res-diff.csv
	echo "iter,nx,ny,nz,cycl,inst,time" >> perf-res-diff.csv
fi

echo -n $(perf stat -o perf-out.txt -e cycles,instructions ./$binary $NX $NY $NZ | cut -d ' ' -f8) >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "stats" perf-out.txt | awk '{print substr($0,32) }' | grep -o -E '[0-9]+' | sed ':a;N;$!ba;s/\n/,/g') >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "cycles" perf-out.txt | awk '{print substr($1,0,19) }' | sed 's/,//g') >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "instructions" perf-out.txt | awk '{print substr($1,0,19) }' | sed 's/,//g') >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "time elapsed" perf-out.txt | awk '{print substr($1,0,19) }') >> perf-res-diff.csv
echo >> perf-res-diff.csv

rm perf-out.txt
