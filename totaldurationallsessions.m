% Get TOTAL duration of specific sleep stage for EACH session 


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
    duration=[]
    total=[]
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
               
            end
          
        if x(i)==stage && x(i+1)~=stage   %for example 3333333 0 ,the last 3 is the end point for stage 3
            k= t(i);
            endt=[endt,k];
        end

    end


%  Get duration

    
    for i = 1:length(start)
        d=endt(i)-start(i);
        %d=d/60   % in minutes
        duration=[duration,d];

    end


% Get the total duration of the specific sleep stage for each bin for time
% 1-2/ 3-4 / 4-5 etc not 1.25-2.25 

    j=1;
    total=[]
    en=1;
    times=[]


    for i=1:length(start)

        

        if start(i)<3600*j 

            continue
           
        else

            if i==1    %that is needed because it used to leave behind the first element
                        %if it was alone  by itself during the first hour
                v=1;
            else
                v=i-1;
            end

        
            %av=mean(duration(en:i-1));   % if you want the average of the
            %duration of each bin and not the total uncomment this and
            %comment the following line:

            tot=sum(duration(en:v)); %when a point passes a specifci hour bin the total duration is calculated from where it was stopped before (en) 
            %to v=i-1 so the point before the hour changed
            
            
            ti=start(en);  % the start time of the plot would be the time of the first sleep stage of the bin
            total=[total,tot];
            times=[times,ti];

            en=i;
            j=j+1;
        end
        
    end

    %add to the times the actual start time of each recording
tot=sum(duration(en:length(start)));   % this one is for the last hour because there will be no ther further point that indicates the revious one ended

ti=start(en);  % the start time of the plot would be the time of the first sleep stage of the bin
total=[total,tot];
times=[times,ti];


    times=times + start_times_sec;
   

% Plot

    plot( times/3600, total/60, '-*')   %start time in hours duration in minutes: change if you want
    

    ylim([0 20])    % set limits for y axis for the plot for better view
    xlim([0 40])
    hold on;
    
    title(['Total Duration for each Hour of *Sleep Stage* during  ' int2str(sesnum) ' Recording Sessions of Mouse ' Mo])
    xlabel('Time (hours)')
    ylabel('Total Duration (min)')
    
    set(gca, 'xtick', [0:1:40]);
end
legend('session 1' ,'ses 2', 'ses 3','ses 4', 'ses 5', 'ses 6', 'AutoUpdate', 'off')

    %%                           PARAMETERS HERE  *zt_time, tik*
    
    zt_time= 18;   %start time of zt time in hours for example 1 for 1 am or 13 for 1 pm
    tik= 12  %change zt time every 12 hours
    
    z=0;
    a=area([(zt_time+z) (zt_time+z)+tik], [40 40]);
    hold on;
    a.FaceAlpha = 0.1;
    a.FaceColor= 'y';
    
    for i = 1:2*length(hypnogram)
    
    
        hold on;
        z=tik*i;
        if mod(i,2)==0
            disp(i)
    
            a=area([(zt_time+z) (zt_time+z)+tik], [40 40])
    
    
            a.FaceAlpha = 0.03;
            a.FaceColor= 'y';
            hold on;
        end
        hold on;
    
    end


    hold off