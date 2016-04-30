#!/bin/bash
DIRECTORY='/home/ashish/Documents/HTS-demo_CMU-ARCTIC-SLT/'
outDir=$DIRECTORY'data/inpFeatsASH'
fullDir=$DIRECTORY'data/labels/full/*.lab'
alignDir=$DIRECTORY'gv/qst001/ver1/fal'
exeDir='/home/ashish/Documents/featDNN/featExtract.py'
for i in $fullDir; do
    echo "Working on File $i"
    python "$exeDir" train "$i" "$alignDir/`basename "$i" .lab`.lab" "$outDir/`basename "$i" .lab`.feat"
    if [ $? -ne 0 ]
    then
    echo "File \"$i\" could not be converted. Aborting!"
    exit 1
    fi
done
exit 0


			
