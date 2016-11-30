function [time, y, HFsignal, LFdata]=CFCfakeData1(numSeconds, LF, HF, phaseLock, whiteNoiseAmp,binTrimming) 


%% Set things up
resol=0.001;%1 ms
if ~exist('LF','var')
    LF = 5;
elseif ~exist('HF','var')
    HF = 40;
elseif ~exist('numSeconds','var')
    numSeconds=30;
elseif ~exist('binTrimming','var')
    binTrimming=0.1; %Fraction of each edge to trim off of HF signal around this phase
end    
HFamp=0.25;

%% The actual simulated data
time=resol:resol:numSeconds;
LFdata = sin(LF*2*pi*time);
HFdata = HFamp*sin(2*HF*pi*time);

cyclePts=1/LF/resol;
half=floor(cyclePts/2);

%% Phase restricting
binTrim=floor(cyclePts*binTrimming);
multiplier=zeros(1, length(time));

partPoints=numSeconds*LF;
switch phaseLock
    case 'peaks'
        titlePhase='Peak';
        for aa=1:partPoints; multiplier( ((1+binTrim):half-(binTrim))+cyclePts*(aa-1) ) = 1; end
    case 'troughs'
        titlePhase='Trough';
        for aa=1:partPoints; multiplier( ((half+1+binTrim):(cyclePts-(binTrim)))+cyclePts*(aa-1) ) = 1; end
    case 'descPhase'
        titlePhase='Descending Phase';
        for aa=1:partPoints; multiplier( ((half/2+binTrim+1):floor((half*1.5)-(binTrim)))+cyclePts*(aa-1) ) = 1; end
    case 'ascPhase'
        titlePhase='Ascending Phase';
        %first part 
        for aa=1:partPoints; multiplier( ((binTrim+1):floor((cyclePts/4)-binTrim))+cyclePts*(aa-1) )= 1; end
        %last part
        for aa=1:partPoints; multiplier( (floor((cyclePts*0.75+1+binTrim)):(cyclePts-(binTrim)))+cyclePts*(aa-1) ) = 1; end
end        

%%
whiteNoise=whiteNoiseAmp.*rand(1,length(time));
whiteNoise=whiteNoise-whiteNoiseAmp/2;

%% Get some outputs
HFsignal=HFdata.*multiplier;
y=LFdata+HFsignal+whiteNoise;

figure;
plot(time, y)
xlabel('time (ms)')
title([num2str(numSeconds) 's of ' num2str(HF) 'Hz locked to the ' titlePhase ' of ' num2str(LF) 'Hz'])

end