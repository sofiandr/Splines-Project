clc
clear all
Mo = 'Mo-0313'; % 'Mo-0341
Project = 'Splines5xFAD';
fs=2000;
%%
hypses0313();% session and hypnogram data structures
final=[];
totaltimes=[];
su=0;

%%
% Loop over all session data and create a list for all sleep state values

%we don't want all the session but just the ones between 15-30 after
%injection days (the ones that are not needed have been commended out i the
%session files
%so i will set it as a variable sesnum

sesnum=6

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
    %actual_start=start +start_times_sec;
    %actual_endt=endt + start_times_sec;
 
    Fs = 2000;
 
    minFreqForSpectrum = 1;
    maxFreqForSpectrum = 220;
    
    % setup params - leave as is
    params.Fs = Fs;
    params.trialave = 1;
    params.pad = 0;
    params.tapers = [1 1];
    
    %% CALCULATE SPECTRUM
    %Commenting this out and implementing below instead: [S f] = spectrumWholeSimple(data, Fs, minFreqForSpectrum, maxFreqForSpectrum, params);
    
    
    
    for i=1:length(start)


        data=lfp(start(i)*fs:endt(i)*fs); % each REM of lpf

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
        powersplines(isnan(powersplines))= 0;  %this is really important because in matlab mean of nan is nan if there is at least one nan in the array
        % which is really possible for example duration < 10 sec (check
        % line 133 )
        power_splines_aver=mean(powersplines);

        POWER_SP_AV=[POWER_SP_AV,power_splines_aver];


        
    end
 
    final=[final, POWER_SP_AV];
    totaltimes=[totaltimes, start]

end


   errors=[];




finalbins=[];
finaltimeticks=[];

for i =0:23 %change this number if you have recordings for more than 24 hours

    ind=find(totaltimes>3600*i & totaltimes<3600*(i+1)); % get the indexes of the times between 0-1 hour (0-3600 sec, 3600-7200 etc...)
    start_xaxis=totaltimes(ind(1)) ;%the first time of those averages that belong to this hour (each one would be fine though, also we can eventually plot zt0-zt24)
    package=final(ind);  %find which POWERS corespond to these times
    packageAV=mean(package); %find the mean of those SPLINE POWERS in this hour
    

    %calculate the errors
    sta= std(package)  ;         
    erst= sta/ sqrt ( length (package));
    errors=[errors, erst];
    
    finalbins=[finalbins, packageAV];
    finaltimeticks=[finaltimeticks, start_xaxis] % if you want the first appear times in seconds


end

daybins=uint32(1):uint32(24);
figure()
errorbar(daybins,finalbins,errors,'-*')
ylim([0 5])
title(['Average Power of Splines  out of all sessions for each hour | NORMAL TIME:' Mo ])
xlabel('REAL HOURS 0-24')
ylabel('Average Spline Power (dB?)')


% those above are the averages for hours 1-24 but bellow we are going to
% make it to zt time so cut parts before it and add to the end

%now let's set everything on zt time 1-24
zt_time=18; 

%we want the first point to plot to be time 1 as hour 1 as zt_time so:

left=finalbins(zt_time:end)
e1=errors(zt_time:end)

right=finalbins(1:zt_time-1)
e2=errors(1:zt_time-1)

ZBINS=[left right]
zerrors=[e1 e2]

figure()
errorbar(daybins,ZBINS,zerrors,'-*')
ylim([0 5])
title(['Average Power of Splines out of all sessions for each hour | ZT-TIME:' Mo ])
xlabel('ZT-TIME 0-24')
ylabel('Average Spline Power (dB?)')
hold on;

%add background for lights on/ lights off
limit=12
tik= 12 ; %change zt time every 12 hours

a=area([0 12], [limit limit]);
hold on;
a.FaceAlpha = 0.2;
a.FaceColor= 'y';
hold off;










