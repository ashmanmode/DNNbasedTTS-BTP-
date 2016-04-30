#!/bin/bash
DIRECTORY='/home/ashish/Documents/HTS-demo_CMU-ARCTIC-SLT/data/'
OUT=$DIRECTORY'wavASH'
IN=$DIRECTORY'raw/*.raw'
for i in $IN; do
    echo "Working on File $i"
    sox -r 48000 -e signed -b 16 -c 1 --endian little "$i" "$OUT/`basename "$i" .raw`.wav"
    if [ $? -eq 0 ]
    then
    echo "Successfully converted File: $i"
    else
    echo "File \"$i\" could not be converted. Aborting!"
    exit 1
    fi
done
exit 0


			
