# Splines-Project
Analysis and figures for splines related to sleep project
Description of every .m file here each one creating one or more figures.

There are comments inside each script about explaing how the computation method is being used and about parameters/ comments that need to be changed if you want to plot something else.

# Figure 1
## hypnograms.m

Just a simple subplot of the hypnograms to take a brief look for the sessions you want to run the analysis  for without having to nsearch and check each one of those manually.

![hypn](https://user-images.githubusercontent.com/117298723/226769320-cfb13694-6442-4ed1-8d21-cd90ae93f0ec.png)


_______________________________________________________________________________________________________________
# Analysis of the Specific Sleep Stage we are interested in
_______________________________________________________________________________________________________________


# Figure 2
## sleepstageDuronTimefromZero.m

Find the epochs of the specific sleep stage (for example stage=3, REM) and finds how long they lasted.
It plots the duration on time that start from zero for all sessions as a scatter plot. (starting from zero means that the first element of each recording is considered to be time zero without concidering the actual recording times).

![durfromzero](https://user-images.githubusercontent.com/117298723/226769317-cd93b364-e726-4b05-8b2b-eba2cb8d1a73.png)

# Figure 3
## sleepstageDuronRealTime.m

As the Figure 2 but in this case the points are being plotted on their actual start of sleep stage time.
Also, lights on background is being added using the variable 'zt_time' for the start of the yellow background and the variable 'tick' for the duration the lights are on.

![durztrealtime](https://user-images.githubusercontent.com/117298723/226769318-aeed9ce0-0400-4e8d-9a86-585ae978390d.png)

# Figure 4
## histograms.m

Simple Histogram to check the rate of the sleep stage duration for each Mouce.
For filling the arrays with ALL the duration of ALL sessions you can find it in the array "allDurations" in most of the scripts here (it should be somewhere on the top of the script).

![histograms](https://user-images.githubusercontent.com/117298723/226769319-48cdf2fe-b99d-4d3b-935f-55c140e8be42.png)

# Figure 5
## totaldurationallsessions.m

This one plots the total duration on each Hour (we get the total duration of the specific sleep stage for each bin for time
1-2/ 3-4 / 4-5 etc not 1.25-2.25 )

![totalremduration_Hour](https://user-images.githubusercontent.com/117298723/226769324-e5579a67-e401-437c-ae47-6f88702523f7.png)

# Figure 6 & Figure 7
## average_of_spec_stageNEW.m

We will have 2 plots out of this figure.
--> The first one is the average TOTAL duration of the specific sleep stage for every Hour (so imagine the bins in Figure 1 averaged ) so 0-24 ACTUAL hour.
Note 1: the bins for each hour is hours 0-1, 1-2 etc and as time zero is set as the beggining for every recording (Figure 1) !!! it is not + actual_start_times as in 

--> The second one is set on zt_time from zt1 to zt 24 (where zt time 1-12 is lights on) by pivoting all the bins depending on the zt_time variable set. More information on that can be found in the comments of the script.

!!! Important Note (also in the comments of the code) : if you have a recording of more than 24 hours the pivoting of all bins should happen before the averaging so for example the hour 25 points should be averaged with the 1 hour ones.

![averagetotaldurationHour](https://user-images.githubusercontent.com/117298723/226769314-1c574fd1-14cc-4052-b71a-574a334e1cd3.png)



____________________________________________________________________________________________
#                    SPLINES join the Analysis :)
____________________________________________________________________________________________



# Figure 8
## splinesPower_allDur.m

After finding the splines power for every (for example REM) stage of all sessions, it find its average and plots that on its duration as a scatter plot for each session on top of the other.
For that we used the spectrogram to find the power and then used the indexes of frequencies between 110-160 Hz.

![powersplines_remdur_all sessions](https://user-images.githubusercontent.com/117298723/226769322-059c717c-bd1e-456c-aa05-06231ed224a7.png)

# Figure 9
## saveseperatesessions.m

Simply save png files of the Splines Power on Duration for each session (for further investigation on single sessions because the other scripts run in a for loop so you could have to change this loop to get eac one of them seperately) we save them because it is easier that taking screenshots for let's say 12 sessions (Mo 413)

![saveeachsession](https://user-images.githubusercontent.com/117298723/226769323-d16daefc-c003-4600-8590-790b7d759bce.png)

# FIgure 10
## averageforspecificbins.m

This on is the Figure 8 but also plots the average for the following specific bins of duration: 10-20 20-30 30-40 40-50 50-60 60-80 80-100 100-120 120-140 140-180 180-220 220-260 260-300 with error bars 
(it can plot just the average or the average on top of the single points - it can be commented in or out)

![averagesplinePower_forspecifcDurationBins](https://user-images.githubusercontent.com/117298723/226769313-ca7d8866-1b77-4307-9344-93b9809f603d.png)

# Figure 11
## splinesPower_all_onTIME.m

As Figure 8 but plots the Average Spline Power on time -not on duration- for all sessions. Lights on on actual time in the background.

![powersplines_realtime_all sessions](https://user-images.githubusercontent.com/117298723/226769321-9687d3a5-b288-4f7f-9a40-f75c66726d42.png)

It can be also plotted with lines not scatter:

Note: all the scatter plots above can be plottes as a single line by just changing the '*' to '-*' on the final plot at the end of the code insite the for loop or at the very end of the script.

# Figure 12 & Figure 13
## averageSplinePowerNEW.m

Plots the Average Spline Power per Hour for ALL sessions wth error bars for actual times 0-24 or zt time in the same way it was explained in Figures 6 & 7

![averagesplnepower](https://user-images.githubusercontent.com/117298723/226800092-01f598a4-2701-4d0b-8410-d0166217c182.png)




# Some Notes about the previous figures

Apart from forgetting the first point on plotting the average (23 not 24) the most important thing to highlight here is the fact that there is a difference on the selection of the bins for averaging in the recording times as they are and when the actual start times (that we get from the session's folder name and then it converts the HH:MM:SS to seoconds) is being added.
This can be better understood by looking at the Figures 1,2 and for example for the last points that goes beyond hour 37 for last sessions. That is because this session started the last combaring to the other ones and that can mess a lot of thing on averaging.
We can average in specific bins, in 0-1-2-3 hour bins or real starting times. Depends on what actually needs to be observed.

Regarding the 2 averaging scripts before, also being concluded in this Repository ( , ) the main difference is that for the averaging of all sessions in those I had creatinng a 2-D STRUCTURE array  of 40 elements (to apply analysis from time 0 to time 40) where every element contained every line for the durations -for example- for each sessions and tried to apply the analysis by line and column.

In those new average figures I store all the events in just one 1-D array and with the help of 'find' I create the bins. for example find (times>0 & times<3600) so I get all the INDEXES of the times of the 1st hour and I apply this indexes in the array that containt the durations and then find average, std, error and plotting.

This is what the old scripts produced:

## average_AND_all.m
![oldaverage](https://user-images.githubusercontent.com/117298723/226801087-82b2d708-46cc-4292-b534-8a35e2217d6a.png)

## average_of_spec_stage.m
![oldaveragetotaldur](https://user-images.githubusercontent.com/117298723/226801088-e699c8ea-01f0-4934-a0e6-1513d187b5b4.png)

As mentioned above, the averaging differentiates based on the real time or actual hours bins but in general stays the same
