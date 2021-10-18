#!/bin/bash

for i in ../tests/*.txt
do
    echo "Executing $i:"
    ./loop_rooms ../tests/$i
    echo "-------------------------------------------------"
    echo
done
