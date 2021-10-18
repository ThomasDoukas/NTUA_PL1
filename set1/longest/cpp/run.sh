#!/bin/bash

for i in ../tests/*.txt
do
    echo "Executing $i:"
    ./longest ../tests/$i
    echo "-------------------------------------------------"
    echo
done
