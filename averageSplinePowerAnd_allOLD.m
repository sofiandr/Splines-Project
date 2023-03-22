clc
clear all
Mo = 'Mo-0313'; % 'Mo-0341
Project = 'Splines5xFAD';
fs=2000;
%%
hypses0313();% session and hypnogram data structures
final=[];
su=0;
stdall={}
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
 



    %Find the average and errors
    lim=0;
    fi=[];
   
    st=[];
    stdc={};
  
    p=0;
    for i=1:40
        vo=0;
        w=i*3600;
 
        for j=1:length(actual_start)
            a=actual_start(j)

            if a>lim && a<w
                pr= POWER_SP_AV(j)
               vo=vo+1;
                st=[st, pr];
                p=p+pr;
                
                end
        
        
        end
        
        lim=w;
        p=p/vo;
        fi=[fi,p];
        p=0;
        stdc{end+1}=st;    
  
        st=[];
        
    end

    
    

    
    %plot(actual_start/3600,POWER_SP_AV,'*')
    final=[final;fi]
    stdall{end+1}=stdc;
    

    
%Calculte the errors
    
    plot(actual_start/3600,POWER_SP_AV,'*')
    %ylim([0 10])
    hold on;

    
    title('Rem Stages of 6 Sessions, Mouse 313, used channel 26:')%', num2str(su))
    
    
end

errors=[];
    allerrors=[];
    for i=1:40
        errors=[];
        for j=1:sesnum
            e=stdall(j)
            %e=cell2mat(e);
            e=[e{:}]
            e=cell2mat(e(i))
            errors=[errors,e];
        end
        if size(errors)~=0
            for k=1:length(errors)
                sta= std(errors);
                erst= sta/ sqrt ( length (errors ));
            end
        end
        
        if size(errors)==0
            
            erst=0;
        end
    
        allerrors=[allerrors,erst];
    end



final(isnan(final))=0;
averofall=mean(final);
averofall(averofall==0)= NaN;
twodaytimes=uint32(1):uint32(40);
ylim=([0 10])
errorbar(twodaytimes,averofall,allerrors,'-*')
ylim=([0 10])
hold on;
zt_time= 18;   %start time of zt time in hours for example 1 for 1 am or 13 for 1 pm
tik= 12  %change zt time every 12 hours
    
limit=10;
xlabel('Time(Hours)')
%xlabel('Duration(Seconds)')
ylabel('Average Power of Splines ')

%change zt time every 12 hours

z=0;
a=area([(zt_time+z) (zt_time+z)+tik], [limit limit]);
hold on;
a.FaceAlpha = 0.2;
a.FaceColor= 'y';

for i = 1:2*length(hypnogram)


    hold on;
    z=tik*i;
    if mod(i,2)==0
        disp(i)

        a=area([(zt_time+z) (zt_time+z)+tik], [limit limit])


        a.FaceAlpha = 0.2;
        a.FaceColor= 'y';
        hold on;
    end
    hold on;

end
xlim([0 40])
hold off;