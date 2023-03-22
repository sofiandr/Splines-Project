% Plot of specific sleep stage ( eg REM) as points y axis the stage's
% duration, x axis the start time of the stage on a REAL time scale which
% means it also concludes the actual start times of the recording and plots
% on lights-on/ lights off real time 


% Set Mouse and Project information
clc
clear
Mo = 'Mo-0313' % 'Mo-0341
Project = 'Splines5xFAD';


hypses0313();% LOAD THE HYP FILE!!!


%%
% Loop over all session data and create a list for all sleep state values

%we don't want all the sessions but just the ones between 15-30 after
%injection days (the ones that are not needed have been commended out in the
%session files
%so i will set it as a variable sesnum

sesnum=6
sesToAnalyze = 1:sesnum  %length(sesInfo) 
numSes = length(sesToAnalyze);
for id = sesToAnalyze
    STA=[];
    duration=[];

    hypDir = ['/nfs/turbo/lsa-ojahmed/Projects/' Project '/processedData/' Mo '/' sesInfo(id).ses '/Hypnograms/']
    addpath (hypDir)
    hypData = [hypDir sesInfo(id).hyp]; % .mat file containing variables hypTimeAxis and hypnogram
    load(hypData);


    %%        Plot duration of specific sleep stage during recording and plot on top of lights on-lights off

    hypnogram = load(sesInfo(id).hyp)
    x= hypnogram.hypnogram; % an array of stages like [111000222333000111444222 ...]
    t= hypTimeAxis  ;
    start_times=[]
    
% get real start time of recording from file's name
    i=string(sesInfo(id).ses)
 
    spl= strsplit(i,'_');
    
    t1=spl(end);
    start_times=[start_times, t1];

%convert the time format HH:MMM:SS to sec

    start_times_sec=[];
    
    for i = start_times
        s= i
        s= strrep(s,'-',':');
        s=sum(sscanf(s,'%f:%f:%f').*[3600;60;1]);
        
        start_times_sec= [start_times_sec, s];
        
    end
    

% Get the sleep stages you want to analyse

    start=[];
    endt=[];

% Specify the sleep stage 
    stage=3;


%Get start and end points of specific sleep stage:
    for i = 2:length(x)-1
        

            if x(i)==stage && x(i-1)~=stage %for example 22222 3 <--- that's the start point for stage 3

                j= t(i); % get the time in seconds of the point

                start=[start,j];
                STA=[STA,j];
                
            

            end
          
        if x(i)==stage && x(i+1)~=stage   %for example 3333333 0 ,the last 3 is the end point for stage 3
            k= t(i);
            endt=[endt,k];
        end

    end


     STA = STA +start_times_sec;
            

%  Get duration

    
    for i = 1:length(start)
        d=endt(i)-start(i);
        %d=d/60   % in minutes
        duration=[duration,d];

    end

% Plot the duration of the specific sleep stages as points through time
scatter(STA/3600,duration/60, '*')
hold on;


end

% Make the plot more beautiful, add zt time, lines for the hours insted of
% sec or hours, labels of sessions


legend('session 1' ,'ses 2', 'ses 3','ses 4', 'ses 5', 'ses 6', 'AutoUpdate', 'off')
hold on

limit=300;
ylim([0 limit])    % set limits for y axis for the plot for better viualisation

xlim([0 40])
hold on;
    
title(['Duration of each REM stage for all ' int2str(sesnum) ' sessions (different colours) of Mouse ' Mo ])
xlabel('REAL Time (hours) -from actual start recording times-')
ylabel('Duration (min)')

set(gca, 'xtick', [0:1:40]);
    for i=1:40

        xline(i) %for every hour

 %                          PARAMETERS HERE  *zt_time, tik*
    
    zt_time= 18;   %start time of zt time in hours for example 1 for 1 am or 13 for 1 pm
    tik= 12  %change zt time every 12 hours
    
    z=0;
    
    a=area([(zt_time+z) (zt_time+z)+tik], [limit limit]); %thats the top of the y axis limit for the yellow background to reach
    hold on;
    a.FaceAlpha = 0.03;
    a.FaceColor= 'y';
    
    for i = 1:2*length(hypnogram)
    
    
        hold on;
        z=tik*i;
        if mod(i,2)==0
            disp(i)
    
            a=area([(zt_time+z) (zt_time+z)+tik], [limit limit])
    
    
            a.FaceAlpha = 0.03;
            a.FaceColor= 'y';
            hold on;
        end
        hold on;
    
    end
end
    hold off