clc
clear all;
close all;

% creating input and output feature matrix
INDIR = '/home/user/Documents/Ashish/inpFeats/';
OUTDIR = '/home/user/Documents/Ashish/outFeats/';
inFiles = dir(INDIR);
outFiles = dir(OUTDIR);
numUttsToWork = 1;
inputs = [];
targets = [];

% Printing the current system resource usage
system(strcat('ps -p ',strcat(num2str(feature('getpid')),' -o %cpu,%mem')));

count = 0 ;
for i = 1:size(inFiles,1)
    if(strcmp( regexp(inFiles(i).name,'feat','match'),'feat'))
        count = count + 1 ;
        infileName ='cmu_us_arctic_slt_b0539.feat'; %inFiles(i).name; 
        outfileName ='cmu_us_arctic_slt_b0539.ofeat'; %outFiles(i).name; 
        disp(['Reading file ',num2str(count), ': ',infileName, ' : ' ,outfileName]);
        a = importdata(strcat(INDIR,infileName)); 
        load(strcat(OUTDIR,outfileName),'-mat');
        sampleSize = min(size(featsAll,1),size(a,1));
        %sampleSize = 100;

        a = a(1:sampleSize,:)'; 
        featsAll = featsAll(1:sampleSize,:)';
        inputs = [inputs,a];
        targets = [targets,featsAll];
        if(count==numUttsToWork)
            break;
        end
    end
end

clearvars -except inputs targets numUttsToWork
%Making inputs 0 mean and unit variance
%[inputs,inpSettings] = mapstd(inputs);
%[targets,tarSettings] = mapstd(targets);

disp('All data loaded and saved into a file.');
save(['/home/user/Documents/Ashish/dataStores/datafile1132' num2str(numUttsToWork) '.mat']);
return;