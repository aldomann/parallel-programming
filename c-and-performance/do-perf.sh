#!/bin/bash
NX=$1; NY=$2; NZ=$3; executable=$4; perfoutfile=$5
outfile=out.txt

if [ ! -f $perfoutfile ]; then
	echo "iter,init,acc,nx,ny,nz,cycl,inst,time,br,brmiss" > $perfoutfile
fi

perf stat -o $outfile -e cycles,instructions,branches,branch-miss ./$executable $NX $NY $NZ | awk '/Running/ { print $8; print $10} /Accuracy/ { printf("%e,", $3) }' ORS="," >> $perfoutfile
awk '/stats/ { printf ("%d,%d,%d,", $6, $7, $8) }' $outfile >> $perfoutfile
awk '/cycles/ { gsub(/\,/,""); print $1 }' ORS="," $outfile >> $perfoutfile
awk '/instructions/ { gsub(/\,/,""); print $1 }' ORS="," $outfile >> $perfoutfile
awk '/elapsed/ { print $1 }' ORS="," $outfile >> $perfoutfile
awk '/branches/ { gsub(/\,/,""); print $1 }' ORS="," $outfile >> $perfoutfile
awk '/branch-miss/ { gsub(/\,/,""); print $1 }' $outfile >> $perfoutfile

rm $outfile
