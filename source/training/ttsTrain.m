clc
clear all;
close all;
data_stored = 0;
%fid = fopen('smb://10.7.34.76/usefulstuff/Speech%20Group/Ashish/log.txt', 'wt');

if data_stored == 0
	% fprintf(fid,'data was not ready.\n Loading data.\n');
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
        i = 3 ; %remove this line if you dont want repition
		if(strcmp( regexp(inFiles(i).name,'feat','match'),'feat'))
		    count = count + 1 ;
		    infileName = inFiles(i).name; 
		    outfileName = outFiles(i).name; 
            disp(['Reading file ',num2str(count), ': ',infileName, ' : ' ,outfileName]);
		    a = importdata(strcat(INDIR,infileName)); 
		    load(strcat(OUTDIR,outfileName),'-mat');
		    %sampleSize = min(size(featsAll,1),size(a,1));
		    sampleSize = 5;
		    
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
	%save(['/home/user/Documents/Ashish/dataStores/dataREP' num2str(numUttsToWork) '.mat']);
	%return;
end

% If we already have data stored then
%load('/home/user/Documents/Ashish/data_storev2.mat');
disp('Data Loaded from file.');
system(strcat('ps -p ',strcat(num2str(feature('getpid')),' -o %cpu,%mem')));
%fprintf(fid, '\nData was already stored in file.\n Loading data.');

% Create a Fitting Network
hiddenLayerSize = [256];
net = fitnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% For help on training function 'trainlm' type: help trainlm
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainlm';  % Levenberg-Marquardt

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean squared error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};

disp('Starting to train the neural network.');
%fprintf(fid,'\nStarting to train the neural network.');
system(strcat('ps -p ',strcat(num2str(feature('getpid')),' -o %cpu,%mem')));

% Train the Network
N = 500000 ;
[net,tr] = train(net,inputs,targets,'useParallel','yes','useGPU','yes','showResources','yes');
system(strcat('ps -p ',strcat(num2str(feature('getpid')),' -o %cpu,%mem')));

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs)

% Recalculate Training, Validation and Test Performance
trainTargets = targets .* tr.trainMask{1};
valTargets = targets  .* tr.valMask{1};
testTargets = targets  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,outputs)
valPerformance = perform(net,valTargets,outputs)
testPerformance = perform(net,testTargets,outputs)

% View the Network
view(net)
save('ttsModelF5L4.mat');
disp(['Training completed sucessfully on ',num2str(numUttsToWork),' files']);
%fprintf(fid,['\nTraining completed sucessfully on ',num2str(numUttsToWork),' files']);

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotfit(net,inputs,targets)
%figure, plotregression(targets,outputs)
%figure, ploterrhist(errors)
