clc;
clear all;
close all;

DIRECTORY = 'G:\TTSAshish\';
outDir = strcat(DIRECTORY,'outFeatsASH16');
inDir = strcat(DIRECTORY,'wavASH16');
inFiles = dir(inDir);
count = 0 ;
for i = 398:size(inFiles,1)
    if(strcmp( regexp(inFiles(i).name,'wav','match'),'wav'))
        count = count + 1 ;
        file = strsplit(inFiles(i).name,'.');
        inFileName = strcat(inDir,'\',inFiles(i).name); 
        disp(inFileName);
        outFileName = char(strcat(outDir,'\',file(1),'.ofeat')); 
        disp(outFileName);
        outFeats(inFileName,outFileName);
    end
end