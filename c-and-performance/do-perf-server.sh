#!/bin/bash
NX=$1
NY=$2
NZ=$3

perf stat -o test.txt -e cycles,instructions ./diffrun $NX $NY $NZ

if [ ! -f perf-res-diff.csv ]; then
	touch perf-res-diff.csv
	echo "NX,NY,NZ,cycles,instructions,time" >> perf-res-diff.csv
fi

echo -n $(grep "stats" test.txt | awk '{print substr($0,32) }' | grep -o -E '[0-9]+'| sed ':a;N;$!ba;s/\n/,/g') >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "cycles" test.txt | awk '{print substr($1,0,19) }' | sed 's/\.$//' | sed 's/\.//g') >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "instructions" test.txt | awk '{print substr($1,0,19) }' | sed 's/\.//g') >> perf-res-diff.csv
echo -n "," >> perf-res-diff.csv
echo -n $(grep "time elapsed" test.txt | awk '{print substr($1,0,19) }' | sed 's/,/\./g') >> perf-res-diff.csv
echo >> perf-res-diff.csv
