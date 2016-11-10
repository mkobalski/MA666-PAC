%% Set things up
resol=0.001;%1 ms
LF = 5;
HF = 40;
numSeconds=3;
HFamp=0.25;

%% The actual simulated data
time=resol:resol:numSeconds;
LFdata = sin(LF*2*pi*time);
HFdata = HFamp*sin(2*HF*pi*time);

cyclePts=1/LF/resol;
half=floor(cyclePts/2);

%% Phase restricting
binTrimming=0.1;%0.1;
binTrim=floor(cyclePts*binTrimming);
multiplier=zeros(1, length(time));
peaks=multiplier;
partPoints=numSeconds*LF;

for aa=1:partPoints; peaks( ((1+binTrim):half-(binTrim))+cyclePts*(aa-1) ) = 1; end
troughs=multiplier;

for aa=1:partPoints; troughs( ((half+1+binTrim):(cyclePts-(binTrim)))+cyclePts*(aa-1) ) = 1; end
descPhase=multiplier;

for aa=1:partPoints; descPhase( ((half/2+binTrim+1):floor((half*1.5)-(binTrim)))+cyclePts*(aa-1) ) = 1; end
ascPhase=multiplier;
%first part 
for aa=1:partPoints; ascPhase( ((binTrim+1):floor((cyclePts/4)-binTrim))+cyclePts*(aa-1) )= 1; end
%last part
for aa=1:partPoints; ascPhase( (floor((cyclePts*0.75+1+binTrim)):(cyclePts-(binTrim)))+cyclePts*(aa-1) ) = 1; end

%% Get some outputs
y=LFdata+HFdata.*descPhase;

figure;
plot(time, y)