#!/bin/bash
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

perfbin=do-perf.sh; executable=run;
source=$1; perfoutfile=$2;

chmod +x $perfbin

echo "Looping for base code..."
if [ -f ${perfoutfile}-opts-base.csv ]; then
	rm ${perfoutfile}-opts-base.csv
	echo "Removed previous results."
fi

gcc -lm -O3 ${source}-base-double.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-opts-base.csv
done

echo
echo "Looping for notime improvement..."
if [ -f ${perfoutfile}-opts-notime.csv ]; then
	rm ${perfoutfile}-opts-notime.csv
	echo "Removed previous results."
fi

gcc -lm -O3 ${source}-notime.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-opts-notime.csv
done

echo
echo "Looping for notime + good loop improvement..."
if [ -f ${perfoutfile}-opts-notime-goodloop.csv ]; then
	rm ${perfoutfile}-opts-notime-goodloop.csv
	echo "Removed previous results."
fi

gcc -lm -O3 ${source}-notime-goodloop.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-opts-notime-goodloop.csv
done
