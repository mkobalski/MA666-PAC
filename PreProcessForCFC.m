function [LFsignal, HFsignal]=PreProcessForCFC(t,x,LF,HF)
%Single unified script to preprocess input and return output signals
%that can be run on any of our methods
%INPUT: t - time stamps, expected to start at dt not 0
%        x - unfiltered EEG/LFP signal
%        LF - low frequency (maybe band?)
%        HF - high frequency (maybe band?)
%        
%OUTPUT: timeStamps - same as t
%        LFsignal - filtered low frequency data
%        HFsignal - filtered high frequency data


dt=t(2)-t(1);
srate=1/dt;

%filter for LF signal
LFsignal = eegfilt(x,srate,LF-2,LF+2);

%filter for HF signal
HFsignal = eegfilt(x,srate,HF-2,HF+2);


end