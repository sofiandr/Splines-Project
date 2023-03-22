%   saves plots of each session, nothing difficult here... stores them to
%   the folder where the cript is...

% You can plot either:
%         --->in time 
%         --->in duration lines 167-174
% 
%      ----> or SUBPLOTS OF THEM , line 167



clc
clear all
Mo = 'Mo-0413'; % 'Mo-0341
Project = 'Splines5xFAD';
fs=2000;
%%
hypses0413();% session and hypnogram data structures

su=0;

%%
% Loop over all session data and create a list for all sleep state values

%we don't want all the session but just the ones between 15-30 after
%injection days (the ones that are not needed have been commended out i the
%session files
%so i will set it as a variable sesnum

sesnum=12


channel_num=44 % please put the number of channel for the specific Mouse that after the analysis you know is ptimal for the splines

sesToAnalyze = 1:sesnum
numSes = length(sesToAnalyze);
for id = sesToAnalyze
    su=su+1;
    POWER_SP_AV=[];
    hypDir = ['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/Hypnograms/'];
    lfp=load(['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/downsampled/resampled_csc' int2str(channel_num) '.mat'])
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
    
    %S=fft(lfp)



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


        data=lfp(start(i)*fs:endt(i)*fs); % REM of lpf

        divTime = 10; % divide into segments, each of 10 seconds - note that any REM epoch less than 10 seconds will not be processed
        divBins = divTime * Fs;
        numTotalBins = length(data);
        divStartBins = [1:divBins:numTotalBins-divBins];
        numDivs = length(divStartBins);
        startTime = 0; endTime = divTime;
        
        params.avg = 1;
        params.fpass = [minFreqForSpectrum maxFreqForSpectrum];

        
       %[S,f] = pspectrum(data,Fs) ;

        [S f] = spectrumEventsSimple(data, Fs, divStartBins, startTime, endTime, params);
        sam=find(f>110 & f<160);
        powersplines=S(sam);
        power_splines_aver=mean(powersplines);

        POWER_SP_AV=[POWER_SP_AV,power_splines_aver];


        
    end
 
    %subplot(sesnum,1,su)
    %plot(actual_start/3600,POWER_SP_AV,'*')   %if you want to plot on time
    %ylim([0 10])
    %hold on;
    figure;
    
    plot(duration,POWER_SP_AV,'*')    % if you want to plot on duration
    
    
    title(strcat('Rem Stages of Session:',num2str(su), 'for Mouse: ' Mo ' used channel'  int2str(channel_num) ':'])%', num2str(su))
    ylabel('Average Power of Splines ')
    xlabel('Duration(Seconds)')
    saveas(gcf,strcat('splines_rem_dur_413_ch25_session',num2str(su),'.png'))
    
end


zt_time= 18;   %start time of zt time in hours for example 1 for 1 am or 13 for 1 pm
tik= 12  %change zt time every 12 hours
    
limit=120;
xlabel('Time(Hours)')
%xlabel('Duration(Seconds)')
ylabel('Average Power of Splines ')

