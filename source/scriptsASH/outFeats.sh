#!/bin/bash
DIRECTORY='/home/ashish/Documents/HTS-demo_CMU-ARCTIC-SLT/data/'
outDir=$DIRECTORY'outFeatsASH16'
inDir=$DIRECTORY'wavASH16/*.wav'
for i in $inDir; do
    echo "Working on File $i"
    execM="matlab -nosplash -nodisplay -r "
    execM=$execM"addpath('/home/ashish/Straight/TandemSTRAIGHTmonolithicPackage010/');"
    execM=$execM"outFeats('$i','$outDir/`basename "$i" .wav`.ofeat');"
    execM=$execM"rmpath('/home/ashish/Straight/TandemSTRAIGHTmonolithicPackage010/');quit;"
    $execM
    if [ $? -ne 0 ]
    then
    echo "File \"$i\" could not be converted. Aborting!"
    exit 1
    fi
done
exit 0


			
