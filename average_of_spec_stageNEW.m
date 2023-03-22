% Script to get sleep data for a Mouse over multiple sessions
% Set Mouse and Project data
clc
clear all
Mo = 'Mo-0313' ;% 'Mo-0341
Project = 'Splines5xFAD';

%%
hypses0313();% session and hypnogram data structures

totalav=[];
totaltimes=[];

finalbins=[];
finaltimeticks=[];

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
    hypDir = ['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/Hypnograms/'];
    addpath (hypDir);
    hypData = [hypDir sesInfo(id).hyp]; % .mat file containing variables hypTimeAxis and hypnogram
    load(hypData);


    %%        Plot duration of specific sleep stage during recording and plot on top of lights on-lights off

    hypnogram = load(sesInfo(id).hyp);
    x= hypnogram.hypnogram; % an array of stages like [111000222333000111444222 ...]
    t= hypTimeAxis  ;
    start_times=[];
    
    i=string(sesInfo(id).ses);
    
    spl= strsplit(i,'_');
    
    t1=spl(end);
    start_times=[start_times, t1];




%time to sec

    start_times_sec=[];
    %previous=0;
    for i = start_times
        s= i;
        s= strrep(s,'-',':');
        s=sum(sscanf(s,'%f:%f:%f').*[3600;60;1]);
        
        start_times_sec= [start_times_sec, s];
        
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
        d=d/60 ;  % in minutes
        duration=[duration,d];

    end


%find the total duration for each hour
    j=1;
    aver=[];
    en=1;
    times=[];

    for i=1:length(start)
        if start(i)<3600*j
            %so when the hour changes then I count the duration from where
            %I left it before until i-1
            continue
        else



            if i==1    %that is needed because it used to leave behind the first element
                        %if it was alone during first hour
                v=1;
                ti=start(1)
            else          
                v=i-1;
                ti=start(en); %otherwise for the first hour we had ti=start(1)
               
            end

            %av=mean(duration(en:i-1));
            total=sum(duration(en:v));
            
            en=i;
            
            
            aver=[aver,total];
            times=[times,ti];
            j=j+1;
        end
    end

total=sum(duration(en:length(start)));   % this one is for the last hour


ti=start(i);  
aver=[aver,total];
times=[times,ti];



%add to the times the actual start time of each recording

% NO REAL TIME FOR NOW because it would not be possible to create the bins

%times=times + start_times_sec;

%Store evrything (for all sessions) in ONE array

totalav= [totalav, aver];
totaltimes=[totaltimes, times];
    
end



% Code to take every point of every session that is concluded in every hour
% real time so we could find the average... also calculates the standard
% deviation of those point within each hour

% this code is new and easier than the previous one as it using only one 1
% dimenstional array and not 2 dimentional for each sessions as it used to.

%for i in length(totaltimes):
   % if 

   errors=[];





for i =0:23 %change this number if you have recordings for more than 24 hours

    ind=find(totaltimes>3600*i & totaltimes<3600*(i+1)); % get the indexes of the times between 0-1 hour (0-3600 sec, 3600-7200 etc...)
    start_xaxis=totaltimes(ind(1)) ;%the first time of those averages that belong to this hour (each one would be fine though, also we can eventually plot zt0-zt24)
    package=totalav(ind);  %find which durations corespond to these times
    packageAV=mean(package); %find the mean of those duration in this hour
    

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
title(['Average Total Duration of REM Stage out of all sessions for each hour | NORMAL TIME:' Mo ])
xlabel('REAL HOURS 0-24')
ylabel('Average Total Duration (min/hour)')


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
title(['Average Total Duration of REM Stage out of all sessions for each hour | ZT-TIME:' Mo ])
xlabel('ZT-TIME 0-24')
ylabel('Average Total Duration (min/hour)')
hold on;

%add background for lights on/ lights off
limit=12
tik= 12 ; %change zt time every 12 hours

a=area([0 12], [limit limit]);
hold on;
a.FaceAlpha = 0.2;
a.FaceColor= 'y';
hold off;








