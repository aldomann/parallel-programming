#!/bin/bash
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

chmod +x loop-perf-*.sh

echo "Testing var type influence on accuracy..."
./loop-perf-vars.sh diff perfstatstest

echo
echo "Testing influence of flags on performance..."
./loop-perf-flags.sh diff-base-double perfstatstest

echo
echo "Testing influence of optimisations on performance..."
./loop-perf-opts.sh diff perfstats
