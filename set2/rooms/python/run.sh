#!/bin/bash

for i in ../tests/*.txt
do
    echo "Executing $i:"
    time python3 loop_rooms.py ../tests/$i
    echo "-------------------------------------------------"
    echo
done