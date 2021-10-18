#!/bin/bash

for i in ../tests/*.txt
do
    echo "Executing $i:"
    time python3 qssort.py ../tests/$i
    echo "-------------------------------------------------"
    echo
done
