%% Runnning Instructions
% 1. Set batsize to be divisor of total no. of samples*
% 2. Set the train path - Set 
% 3. Change model storing path in nntrain - done 
%%


clc
clear all
close all
%%

trainPath = '/home/user/Documents/Ashish/dataStores/data1100.mat';
testPath  = '/home/user/Documents/Ashish/dataStores/data1.mat';

rand('state',0)
FirstLayer = 256;
SecondLayer = 512;
ThirdLayer = 1024;
FourthLayer = 2048;

actFun = 'sigm'; %'tanh_opt';%
learningRate = 0.01;
opts.numepochs =  100;
opts.batchsize = 974;

load(trainPath)
min_max_store = []; 

%%% AutoEncoder
train_y = targets';
train_x = inputs';

% normalize X
[train_x,inpSettings] = mapstd(train_x);

%bring y in range 0-1
for i = 1:size(train_y,2)
    a = min(train_y(:,i));
    b = max(train_y(:,i));
    train_y(:,i) = (train_y(:,i) - a) / ( b - a );
    min_max_store(i,:) = [a b];
end
save('/home/user/Documents/Ashish/models/Files1100/min_max.mat','min_max_store');

sz = size(train_x);
sea = [];
sae = saesetup([sz(2) FirstLayer SecondLayer ThirdLayer FourthLayer]);

% Layer1
sae.ae{1}.activation_function       = actFun;
sae.ae{1}.learningRate              = learningRate;
sae.ae{1}.inputZeroMaskedFraction   = 0;
%     sae.ae{1}.sparsityTarget            = 0.4; %introducing sparsity in 1st auto encoder
%     sae.ae{1}.nonSparsityPenalty        = 0.1;

% Layer2
sae.ae{2}.activation_function       = actFun;
sae.ae{2}.learningRate              = learningRate;
sae.ae{2}.inputZeroMaskedFraction   = 0;
%     sae.ae{2}.sparsityTarget            = 0.4; %introducing sparsity in 1st auto encoder
%     sae.ae{2}.nonSparsityPenalty        = 0.1;

% Layer3
sae.ae{3}.activation_function       = actFun;
sae.ae{3}.learningRate              = learningRate;
sae.ae{3}.inputZeroMaskedFraction   = 0;
%     sae.ae{3}.sparsityTarget            = 0.4; %introducing sparsity in 1st auto encoder
%     sae.ae{3}.nonSparsityPenalty        = 0.1;

 % Layer4
sae.ae{4}.activation_function       = actFun;
sae.ae{4}.learningRate              = learningRate;
sae.ae{4}.inputZeroMaskedFraction   = 0;
%     sae.ae{4}.sparsityTarget            = 0.4; %introducing sparsity in 1st auto encoder
%     sae.ae{4}.nonSparsityPenalty        = 0.1;

sae = saetrain(sae, train_x, opts);

%Creating the model
nn = [];
nn = nnsetup([sz(2) FirstLayer SecondLayer ThirdLayer FourthLayer 123]);
nn.activation_function              = actFun;
nn.learningRate                     = 0.01;
opts.numepochs =  1000;
nn.output = 'sigm';%'linear';%'softmax';
nn.W{1} = sae.ae{1}.W{1};
nn.W{2} = sae.ae{2}.W{1};
nn.W{3} = sae.ae{3}.W{1};
nn.W{4} = sae.ae{4}.W{1};

%    nnFWD = nnFeedForward(nn, train_x);
 nn = nntrain(nn, train_x, train_y, opts);
 [er, bad] = nntest(nn, train_x, train_y);

 %%Testing the network
 load(testPath);
 test_y = targets';
test_x = inputs';
 nn.testing = 1;
nn = nnff(nn,test_x, zeros(size(test_x,1), nn.size(end)));
resultOut1 = nn.a{end} ;
resultOut = reconstructOutFeats(resultOut1,min_max_store);
utts = 1100;
str1 = ['/home/user/Documents/Ashish/models/Files1100/wavEpoch' num2str(utts) '.wavdata'];
save(str1,'resultOut');