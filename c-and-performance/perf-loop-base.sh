#!/bin/bash
chmod +x do-perf-server.sh

executable=run-base
perfoutfile=perf-base.csv

if [ -f $perfoutfile ]; then
	rm $perfoutfile
	echo "Removed previous results."
fi

for (( i = 25; i <= 150; i +=25 )); do
	gcc -Ofast -lm diff-base.c -o $executable
	bash do-perf-server.sh $i $i $i $executable $perfoutfile
done
