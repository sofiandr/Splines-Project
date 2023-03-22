% Script to get sleep data for a Mouse over multiple sessions
% Set Mouse and Project data
clc
clear all
Mo = 'Mo-0313' ;% 'Mo-0341
Project = 'Splines5xFAD';

%%
hypses0313();% session and hypnogram data structures

totalav={};
totaltimes={};

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
    times=[start(1)];

    for i=1:length(start)
        if start(i)<3600*j
            %so when the hour changes then I count the duration from where
            %I left it before until i-1
            continue
        else



            if i==1    %that is needed because it used to leave behind the first element
                        %if it was alone during first hour
                v=1;
            else          
                v=i-1;
               
            end

            %av=mean(duration(en:i-1));
            total=sum(duration(en:v));
            
            en=i;
            
            ti=start(en);
            aver=[aver,total];
            times=[times,ti];
            j=j+1;
        end
    end

total=sum(duration(en:length(start)));    % this one is for the last hour because there will be no ther further point that indicates the revious one ended


aver=[aver,total];


    %
    %add to the times the actual start time of each recording

    times=times + start_times_sec;
    
    totalav= [totalav;aver];
    totaltimes=[totaltimes;times];
    
end



% Code to take every point of every session that is concluded in every hour
% real time so we could find the average... also calculates the standard
% deviation of those point within each hour

lim=0;
fi=[];
final=[];
st=[];
stdc={};
p=0;
for k=1:sesnum % = number of sessions
    for i =1:40
        
        w=i*3600 ; %indicate each hour
        
        r=cell2mat(totaltimes(k));
        for j=1:length(r)
            
            
            y2=cell2mat(totalav(k));
            y=r(j);  %time
            
            if lim<=y && y<=w
                pr=y2(j);
                
                st=[st, pr];
                p=p+pr;
            end
        
        
        end
       
        fi=[fi,p];
        p=0;
        lim=w;
    
    
        %stdc = horzcat(i,stdc);
    stdc{end+1}=st;    
    %stdc=[stdc,'o'];
    st=[];
   
    end
    final=[final;fi];
    fi=[];
end


stdcall=stdc(1:40);

for i=1:sesnum-1
    helparray=stdc(40*i:40*i+40-1) ;
    stdcall=[stdcall; helparray];
end


%Calculte the errors

errors=[];
allerrors=[];
for i=1:40
    errors=[];
    for j=1:sesnum
        e=cell2mat(stdcall(j,i));
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
for i=1:length(stdc)
    e=std(cell2mat(stdc(i)));
    e=e / sqrt( length(cell2mat(stdc(i))) );
    errors=[errors,e];
end


limit=20 ;  % for the y axis

averofall=mean(final);
averofall(averofall==0)= NaN;
twodaytimes=uint32(1):uint32(40);

errorbar(twodaytimes,averofall,allerrors,'-*')
hold on
ylim([0 limit])    % set limits for y axis for the plot for better viualisation
hold on;

title('Average Total Duration of REM Stage out of all sessions for each hour: Mouse 0413')
xlabel('Time (hours)')
ylabel('Average Total Duration (min/hour)')
xlim([0 40])
set(gca, 'xtick', [0:1:40]);
%%                           PARAMETERS HERE  *zt_time, tik*

zt_time= 18;   %start time of zt time in hours for example 1 for 1 am or 13 for 1 pm
tik= 12 ; %change zt time every 12 hours

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
