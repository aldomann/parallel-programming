#!/bin/bash
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

perfbin=do-perf.sh; executable=run;
source=$1; perfoutfile=$2;

chmod +x $perfbin

echo "Looping with floats..."
if [ -f ${perfoutfile}-base-float.csv ]; then
	rm ${perfoutfile}-base-float.csv
	echo "Removed previous results."
fi

gcc -lm ${source}-base.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-base-float.csv
done

echo
echo "Looping with doubles..."
if [ -f ${perfoutfile}-base-double.csv ]; then
	rm ${perfoutfile}-base-double.csv
	echo "Removed previous results."
fi

gcc -lm ${source}-base-double.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-base-double.csv
done
