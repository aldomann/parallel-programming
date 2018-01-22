#!/bin/bash
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

perfbin=do-perf.sh; executable=run;
source=$1; perfoutfile=$2;

chmod +x $perfbin

echo "Looping with no flags..."
if [ -f ${perfoutfile}-flags-no.csv ]; then
	rm ${perfoutfile}-flags-no.csv
	echo "Removed previous results."
fi

gcc -lm ${source}.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-flags-no.csv
done

echo
echo "Looping with -O2 flag..."
if [ -f ${perfoutfile}-flags-o2.csv ]; then
	rm ${perfoutfile}-flags-o2.csv
	echo "Removed previous results."
fi

gcc -lm -O2 ${source}.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-flags-o2.csv
done

echo
echo "Looping with -O3 flag..."
if [ -f ${perfoutfile}-flags-o3.csv ]; then
	rm ${perfoutfile}-flags-o3.csv
	echo "Removed previous results."
fi

gcc -lm -O3 ${source}.c -o $executable
for (( i = 25; i <= 125; i +=25 )); do
	bash $perfbin $i $i $i $executable ${perfoutfile}-flags-o3.csv
done
