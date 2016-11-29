function [time, y, HFsignal, LFdata]=CFCfakeData1(numSeconds, LF, HF, phaseLock, whiteNoiseFlag) 


%% Set things up
resol=0.001;%1 ms
if ~exist('LF','var')
    LF = 5;
elseif ~exist('HF','var')
    HF = 40;
elseif ~exist('numSeconds','var')
    numSeconds=30;
end    
HFamp=0.25;

%% The actual simulated data
time=resol:resol:numSeconds;
LFdata = sin(LF*2*pi*time);
HFdata = HFamp*sin(2*HF*pi*time);

cyclePts=1/LF/resol;
half=floor(cyclePts/2);

%% Phase restricting
binTrimming=0.05;%0.1;
binTrim=floor(cyclePts*binTrimming);
multiplier=zeros(1, length(time));

partPoints=numSeconds*LF;
switch phaseLock
    case 'peaks'
        for aa=1:partPoints; multiplier( ((1+binTrim):half-(binTrim))+cyclePts*(aa-1) ) = 1; end
    case 'troughs'
        for aa=1:partPoints; multiplier( ((half+1+binTrim):(cyclePts-(binTrim)))+cyclePts*(aa-1) ) = 1; end
    case 'descPhase'
        for aa=1:partPoints; multiplier( ((half/2+binTrim+1):floor((half*1.5)-(binTrim)))+cyclePts*(aa-1) ) = 1; end
    case 'ascPhase'
        %first part 
        for aa=1:partPoints; multiplier( ((binTrim+1):floor((cyclePts/4)-binTrim))+cyclePts*(aa-1) )= 1; end
        %last part
        for aa=1:partPoints; multiplier( (floor((cyclePts*0.75+1+binTrim)):(cyclePts-(binTrim)))+cyclePts*(aa-1) ) = 1; end
end        

%% Get some outputs
HFsignal=HFdata.*multuplier;
y=LFdata+HFsignal;
if whiteNoiseFlag==1
    %add some white noise here
end    

figure;
plot(time, y)

end