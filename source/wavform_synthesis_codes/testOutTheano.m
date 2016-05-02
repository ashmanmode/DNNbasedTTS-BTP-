clear all;
close all;
clc;

%load the output feature file
OUTDIR = 'G:\TTSAshish\asd\';
savename = 'wav18';
fileName = 'wavfile18Epoch800.mat'; 
load(strcat(OUTDIR,fileName));
outputs = resultOut;
% outputs = importdata(strcat(OUTDIR,fileName)); 

output = outputs(:,1:40);
f0_target = outputs(:,41);

fs=16000;
addpath('G:\TTSAshish\Straight\TandemSTRAIGHTmonolithicPackage010\');
[testfeature,weightMatrix,q,f]=mfcc_straight('G:/TTSAshish/wav/cmu_us_arctic_slt_a0018.wav');
[inpWav,~] = audioread('G:/TTSAshish/wav/cmu_us_arctic_slt_a0018.wav');

%comapring input mfcc with original
for num=1:40
    testfeaturenorm = testfeature(:,num);
    outfeaturenorm = outputs(:,num);
    testfeaturenorm = (testfeaturenorm - min(testfeaturenorm)) / ( max(testfeaturenorm) - min(testfeaturenorm) );  
    outfeaturenorm = (outfeaturenorm - min(outfeaturenorm)) / ( max(outfeaturenorm) - min(outfeaturenorm) );  
    fig3 = figure;
    plot(1:size(testfeaturenorm,1),testfeaturenorm,1:size(outfeaturenorm,1),outfeaturenorm);
    xlabel('frame');
    ylabel([num2str(num),'th Mel-cepstrum']);
    legend('Natural Speech','DNN');
    saveas(fig3,[OUTDIR,savename,'mfcc',num2str(num),'.jpg']);
end
fig4 = figure;
plot(testfeature);
xlabel('frame');
ylabel('40 Mel-cepstrums');
saveas(fig4,[OUTDIR,savename,'mfccORI.jpg']);
fig5 = figure;
plot(outputs);
xlabel('frame');
ylabel('40 Mel-cepstrums');
saveas(fig5,[OUTDIR,savename,'mfccSYN.jpg']);

%log f0 comparison
fig6 = figure;
plot(1:size(q.f0,1),log(q.f0),1:size(f0_target,1),log(f0_target));
xlabel('frame');
ylabel('F0');
legend('Natural Speech','DNN');
saveas(fig6,[OUTDIR,savename,'logf0.jpg']);

%saving the original spectrogram
sgramSTRAIGHT = 10*log10(f.spectrogramSTRAIGHT);
maxLevel = max(max(sgramSTRAIGHT));
fig1 = figure;
imagesc([0 f.temporalPositions(end)],[0 fs/2],max(maxLevel-80,sgramSTRAIGHT));
axis('xy');
set(gca,'fontsize',14);
xlabel('time (s)');
ylabel('frequency (Hz)');
title('Reconstructed spectrogram');
saveas(fig1,strcat(OUTDIR,strcat(savename,'ORISpectrogram.jpg')));

% Using the output 
q.f0 = f0_target;
nCoefficients = size(weightMatrix,1);
cosTable=dctmtx(nCoefficients)';
n3sgram=(pinv(weightMatrix)*(sqrt(exp(cosTable\output')))).^2;
f.spectrogramSTRAIGHT=n3sgram;

%generating the spectrogram
sgramSTRAIGHT = 10*log10(n3sgram);
maxLevel = max(max(sgramSTRAIGHT));
fig2 = figure;
imagesc([0 f.temporalPositions(end)],[0 fs/2],max(maxLevel-80,sgramSTRAIGHT));
axis('xy');
set(gca,'fontsize',14);
xlabel('time (s)');
ylabel('frequency (Hz)');
title('Reconstructed spectrogram');
saveas(fig2,strcat(OUTDIR,strcat(savename,'SYNSpectrogram.jpg')));

%synthesizing the waveform
s2 = exGeneralSTRAIGHTsynthesisR2(q,f);
sound(s2.synthesisOut,fs);
wavwrite(s2.synthesisOut,fs,strcat(OUTDIR,strcat(savename,'.wav')));

%saving wav comparison in time domain
fig7 = figure;
plot(1:size(inpWav,1),inpWav,1:size(s2.synthesisOut,1),s2.synthesisOut);
xlabel('time');
ylabel('Amplitude');
legend('Natural Speech','Synthesized speech');
saveas(fig7,strcat(OUTDIR,strcat(savename,'timeWav.jpg')));
close all;