#!/bin/bash
NX=$1
NY=$2
NZ=$3
executable=$4
perfoutfile=$5

if [ ! -f $perfoutfile ]; then
	touch $perfoutfile
	echo "iter,nx,ny,nz,cycl,inst,time" >> $perfoutfile
fi

echo -n $(perf stat -o perf-out.txt -e cycles,instructions ./$executable $NX $NY $NZ | cut -d ' ' -f8) >> $perfoutfile
echo -n "," >> $perfoutfile
echo -n $(grep "stats" perf-out.txt | awk '{print substr($0,32) }' | grep -o -E '[0-9]+'| sed ':a;N;$!ba;s/\n/,/g') >> $perfoutfile
echo -n "," >> $perfoutfile
echo -n $(grep "cycles" perf-out.txt | awk '{print substr($1,0,19) }' | sed 's/\.//g') >> $perfoutfile
echo -n "," >> $perfoutfile
echo -n $(grep "instructions" perf-out.txt | awk '{print substr($1,0,19) }' | sed 's/\.//g') >> $perfoutfile
echo -n "," >> $perfoutfile
echo -n $(grep "time elapsed" perf-out.txt | awk '{print substr($1,0,19) }' | sed 's/,/\./g') >> $perfoutfile
echo >> $perfoutfile

rm perf-out.txt
