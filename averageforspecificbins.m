
%             PARAMETERS

%    Mo : mouse name
%    ! LOAD session names for example hypnses0341()
%    sesum: how many sessions
%    change channel name manually on the lfp line nme of file
%    for plotting axis limits, or if you want average by itself or with
%    point on top check end of script, plotting



% Plots the AVERAGE of the following bins of duration seconds: 10-20 20-30 30-40 40-50 50-60 60-80 80-100 100-120 120-140 140-180 180-220 220-260 260-300 
% with error bars 
% ---> [+ it can also plot that average on top of all the point, if you
% want to plot the average on top of all the duration points go to line 245



clc
clear all


Mo = 'Mo-0313'; % 'Mo-0341
sesnum=6;
hypses0313();% session and hypnogram data structures


Project = 'Splines5xFAD';
fs=2000;
%%

durationall=[]
POWER_SP_AV_all=[]
su=0;
allerrors=[];

%%
% Loop over all session data and create a list for all sleep state values

%we don't want all the session but just the ones between 15-30 after
%injection days (the ones that are not needed have been commended out i the
%session files
%so i will set it as a variable sesnum



sesToAnalyze = 1:sesnum
numSes = length(sesToAnalyze);
for id = sesToAnalyze
    su=su+1;
    POWER_SP_AV=[];
    hypDir = ['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/Hypnograms/'];
    lfp=load(['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/downsampled/resampled_csc44.mat'])
    lfp=lfp.LFP;
    addpath (hypDir)
    hypData = [hypDir sesInfo(id).hyp] % .mat file containing variables hypTimeAxis and hypnogram
    load(hypData);


    %%        Plot duration of specific sleep stage during recording and plot on top of lights on-lights off

    hypnogram = load(sesInfo(id).hyp);
    x= hypnogram.hypnogram; % an array of stages like [111000222333000111444222 ...]
    t= hypTimeAxis  ;
    start_times=[];
    
    i=string(sesInfo(id).ses)
    disp(i)
    spl= strsplit(i,'_');
    
    t1=spl(end);
    start_times=[start_times, t1]




%time to sec

    start_times_sec=[];
    %previous=0;
    for i = start_times
        s= i;
        s= strrep(s,'-',':');
        s=sum(sscanf(s,'%f:%f:%f').*[3600;60;1]);
        
        start_times_sec= [start_times_sec, s]
        
    end
    


    start=[];
    endt=[];

    % Specify the sleep stage you want to analyse
    stage=3;


    %Get start and end points of specific sleep stage:
    for i = 1:length(x)-1
        try

            if x(i)==stage && x(i-1)~=stage %for example nrem2

                j= t(i); % get the time in seconds of the point
                start=[start,j];
            end

        catch
            j=t(1);
            start=[start,j];
        end
        if x(i)==stage && x(i+1)~=stage
            k= t(i);
            endt=[endt,k];
        end

    end
%  Get duration

    duration=[];
    for i = 1:length(start)
        d=endt(i)-start(i);
        %d=d/60  ; % in minutes
        duration=[duration,d];

    end



    
    
    %add to the times the actual start time of each recording
    actual_start=start +start_times_sec;
    actual_endt=endt + start_times_sec;
    

    Fs = 2000;
 
    minFreqForSpectrum = 1;
    maxFreqForSpectrum = 220;
    
    % setup params 
    params.Fs = Fs;
    params.trialave = 1;
    params.pad = 0;
    params.tapers = [1 1];
    
    %% CALCULATE SPECTRUM
    %Commenting this out and implementing below instead: [S f] = spectrumWholeSimple(data, Fs, minFreqForSpectrum, maxFreqForSpectrum, params);
    
    
    
    for i=1:length(start)


        data=lfp(start(i)*fs:endt(i)*fs); % REM of lpf

        divTime = 10; % divide into segments, each of 10 seconds - note that any REM epoch less than 10 seconds will not be processed
        divBins = divTime * Fs;
        numTotalBins = length(data);
        divStartBins = [1:divBins:numTotalBins-divBins];
        numDivs = length(divStartBins);
        startTime = 0; endTime = divTime;
        
        params.avg = 1;
        params.fpass = [minFreqForSpectrum maxFreqForSpectrum];


        [S f] = spectrumEventsSimple(data, Fs, divStartBins, startTime, endTime, params);
        sam=find(f>110 & f<160);
        powersplines=S(sam);
        power_splines_aver=mean(powersplines);

        POWER_SP_AV=[POWER_SP_AV,power_splines_aver];


        
    end

    durationall=[durationall,duration];
    POWER_SP_AV_all=[POWER_SP_AV_all, POWER_SP_AV];

    
end


%    Getting the average of the power for each bin and the errors

BINS=[10,20,30,40,50,60,80,100,120,140,180,220,260];

    %average for bins 10-20 , 20-30 , 30-40, 50-60
    DAV=[]
for i =10:10:50
    
    ind=find(durationall>i & durationall<i+10); %find where the duration is between the bins that I want and get all the powers of these indexes and then get the mean and the std, error
    q=POWER_SP_AV_all(ind);

    sta= std(q);
    erst= sta/ sqrt ( length (q ));
    allerrors=[allerrors,erst];
    

    q=mean(q)
    DAV=[DAV, q];  %save it in an array for the final plot
    
end

%average for bins 60-80, 80-100, 100-120, 120-140
for i =60:20:120

    ind=find(durationall>i & durationall<i+20);
    q=POWER_SP_AV_all(ind);

    sta= std(q);
    erst= sta/ sqrt ( length (q ));
    allerrors=[allerrors,erst];

    q=mean(q)
    DAV=[DAV, q];
end

%average for bins 140-180, 180-220, 220-260, 260-300
for i =120:40:260

    ind=find(durationall>i &  durationall<i+40);
    q=POWER_SP_AV_all(ind);

    sta= std(q);
    erst= sta/ sqrt ( length (q ));
    allerrors=[allerrors,erst];
    

    q=mean(q)
    DAV=[DAV, q];
end
    
 
    %     PLOTTING


    hold on;
    errorbar(BINS,DAV,allerrors,'-*')
    plot(durationall,POWER_SP_AV_all,'*')    %if you want to plot the average on top of all the duration points
    %xlim([])
    %ylim([])


    xlabel('Duration(seconds)')
    ylabel('Average Splines Power/ bin')
    title('Rem Stages of 6 Sessions, Mouse 313, used channel 44:')%', num2str(su))
    



