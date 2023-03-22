
% Simply plotting the hypnograms for selected sessions of selected Mouse
% there are already somewhere else much more beautiful but here to take a
% quick look for checking...


clc
clear all

% Choose Mouse, how many sessions AND LOAD THE HYPN FILE
Mo = 'Mo-0313'; % 'Mo-0341
sesnum=6;
hypses0313();% session and hypnogram data structures


Project = 'Splines5xFAD';
fs=2000;

sesToAnalyze = 1:sesnum
numSes = length(sesToAnalyze);
su=0;
figure()

for id = sesToAnalyze
    su=su+1;
    POWER_SP_AV=[];
    hypDir = ['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/Hypnograms/']; %load the hypnogram
    
    addpath (hypDir);
    hypData = [hypDir sesInfo(id).hyp]; % .mat file containing variables hypTimeAxis and hypnogram
    
    load(hypData);


    %%        Plot duration of specific sleep stage during recording and plot on top of lights on-lights off

    hypnogram = load(sesInfo(id).hyp);
    x= hypnogram.hypnogram; % an array of stages like [111000222333000111444222 ...]
    t= hypTimeAxis  ; %the time contained in the hypnogram


    subplot(7,1,su);
    
    plot(t,x)


    ylim([0 4]);
    xlim([0 90000])
    title(['Session' num2str(id)] );
    hold on;
end

sgtitle(['Hypnogram for all  ' num2str(sesnum) ' sessions for Mouse ' Mo]) 
ylabel('Stage')
xlabel('Time in seconds')
