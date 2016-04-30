clc
clear all
close all
%%

modelPath = '/home/user/Documents/Ashish/models/Files1100/nnDataEpoch900.mat';
testPath  = '/home/user/Documents/Ashish/dataStores/datafile1132.mat';
minMaxPath = '/home/user/Documents/Ashish/models/Files1100/min_max.mat';

%%Load all the data
load(testPath);
load(modelPath);
load(minMaxPath);

%Get the testing data
test_y = targets';
test_x = inputs';

%Normalise the input data to 0 mean and unit variance
[test_x,inpSettings] = mapstd(test_x);

%Using the trained model
nn.testing = 1;
nn = nnff(nn,test_x, zeros(size(test_x,1), nn.size(end)));
resultOut1 = nn.a{end} ;
resultOut = reconstructOutFeats(resultOut1,min_max_store);
utts = 900;
str1 = ['/home/user/Documents/Ashish/models/Files1100/wavfile1132Epoch' num2str(utts) '.wavdata'];
save(str1,'resultOut');