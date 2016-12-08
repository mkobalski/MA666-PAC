function [pacmatrix,pacvalues,times] = CERPAC(data, srate, lo_freq_phase, hi_freq_phase, lo_freq_amp, hi_freq_amp, surrogate_runs, events, tbefore, tafter, numchunks);
%%This code uses the function pac from the Voytek lab, and its
%%dependencies. It has been modified to calculate the average PAC for event
%%locked epochs within a trial

% data: a single channel of continuous time-series data
% srate: sampling rate of the input data
% timeWindow: two numbers indicating the onset and offsets (in ms) of the time window of interet around the events
% lo_freq_phase: lower frequency bound for the phase bandpass
% hi_freq_phase: upper frequency bound for the phase bandpass
% lo_freq_amp: lower frequency bound for the amplitude bandpass
% hi_freq_amp: upper frequency bound for the amplitude bandpass
% surrogate_runs: the number of surrogate runs used to calculate statistical significance of the PAC value
% events: a vector of event onset times where each number is the datapoint in data when the event of interest occured
%tbefore: time before the event that PAC will begin being calculated
%tafter: time after the event the PAC will be caclulated until
%nchunks: the number of epochs the sampling window (tbefore:tafter) will be
%          broken into

pacmatrix=zeros(numevents,numchunks); %initialize
times=[]; %initialize

numevents=length(events); %determine number of events
tchunk=floor((tbefore+tafter)/numchunks); %determine the amount of time that will be in each segment


for eventn=1:numevents %for each event
    tbegin=events(eventn)-1;
    for chunkn=1:numchunks
        time1=tbegin-tbefore+(chunkn-1)*tchunk; %find the start 
        time2=tbegin-tbefore+chunkn*tchunk; %and end times of the segment
        times=[times;time1,time2,chunkn];
        if time2<=length(data) && time1>0 %if the whole segment is in the dataset
       %determine the PAC of the segment
        datapart=data(time1:time2);
        [pac_value] = pac(datapart, srate, lo_freq_phase, hi_freq_phase, lo_freq_amp, hi_freq_amp, surrogate_runs);
        pacmatrix(eventn, chunkn)=pac_value; %input this value into a matrix of all the values
        clear pac_value
        end
    end
end
%average each segment across trials
pacvalues=zeros(1,numchunks);
for chunk=1:numchunks
    pacvalues(1,chunk)=mean(pacmatrix(:,chunk));
end