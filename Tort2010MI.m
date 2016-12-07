function [MI, binAmp, lfPhase, hfAmp]=Tort2010MI(LFsignal, HFsignal, numPhaseBins)
%{ 
    Tort et al. 2010 phase-amplitude modulation index (MI) pseudocode

    Modulation distribution:
    1. Filter signal for both frequency ranges interested in (LF/phase and
    HF/amplitude).
    2. Use the Hilbert transform to extract phase of LF and time series of
    amplitude envelope of HF. Then have composite N x 2 matrix with 
        [ LF phase , HF amplitude ]
    3. Bin phases and mean of HF amplitude over each phase bin. 
    4. Normalize mean amplidue by dividing each bin value by the sum over
    the bins.

    KL distance:
    1. Where P and Q are different distributions, 
        Dkl(P, Q) = sum(j:N)*P(j)*log[P(j)/Q(j)]
    
    2. Can also b calculated using Shannon entropy, where U is the uniform,
        Shannon H(P) = -sum(j:N)*P(j)*log[P(j)]
        then
        Dkl(P, U) = log(N)-H(P)
    
    Modulation index:
    1. MI = Dkl(P, U) / log(N)
%}

%{ 
    coherence between the amplitude envelope AfA and the phase-modulating rhythm fp
    "It should also be noted that the MI loses time information and it cannot 
    tell us whether the coupling occurred during the whole epoch being 
    analyzed or whether there occurred bursts of coupling inside the
    epoch." 
        So maybe we can try binning signal into chunks to see how this
        measure falls apart? 
    Figure 3: probably need about 30 seconds of data to be confident in
    spite of noise in signal

    Variance/confidence of results?
%}

if ~exist('numPhaseBins','var')    
    numPhaseBins=18;
end

%LF phase
LFhilbert = hilbert(LFsignal);
lfPhase=angle(LFhilbert); %This comes out shifted 90degrees
lfPhase=lfPhase+pi/2;
lfPhase(lfPhase<0)=lfPhase(lfPhase<0)+2*pi;
%freq = diff(unwrap(angle(hilbert(x)))); ?????

%HF amplitude
HFhilbert = hilbert(HFsignal);
hfAmp=HFhilbert.*conj(HFhilbert);

%Phase Bins
binWidthDeg=360/numPhaseBins;
binEdgesDeg=0:binWidthDeg:360;
binEdgesRad=deg2rad(binEdgesDeg);

%Bin amp by phase, then normalize
for bin=1:numPhaseBins
    isThisPhaseBin=lfPhase > binEdgesRad(bin)...
        & lfPhase <= binEdgesRad(bin+1);
    phaseBinOnly=hfAmp.*isThisPhaseBin;
    binAmp(bin)=sum(phaseBinOnly)/sum(isThisPhaseBin);
end
binAmp=binAmp/sum(binAmp);%normalized 

%KL distance
logAmp=log2(binAmp);
ShannonH =-sum(binAmp(logAmp~=-Inf).*logAmp(logAmp~=-Inf)); 
Dkl = log2(numPhaseBins)-ShannonH;

MI=Dkl/log2(numPhaseBins);

%p value?     
%Create small chunks of the input signals, all same length, taken from
%random sections of the signal. Then can association of amplitude (while
%preserving many of it's features) with phase, average and sd those values 

%Here plot bar graph with sinewave overlay, xlabels phasebin edges
%{
if asked for...
figure;
bar(binAmp,'g','BarWidth',1)
ylim([0 1])
xlim([0.5 18.5])
xlabel('Phase')
ylabel('Normalized HF amplitude')
title(['Narrow Distribution, MI = ' num2str(MI)])
time=[0.001:0.001:1];
LFdata=sin(2*pi*time);
LFscaled=LFdata*0.15;
LFscaled=LFscaled+0.25;
ax1=gca;
ax1_pos = ax1.Position;
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
ylim([0 0.5])
line(time,LFscaled,'Parent',ax2,'LineWidth',2.5,'Color','b')
axis off;
ax1.XTick=[0.5 5 9.5 14 18.5]; %scale for 18?
ax1.XTickLabel=[{'0', 'pi/2', 'pi', '3/2 pi', '2pi'}];
%}
%{
%Surrogate control
minLength = 50;
maxLength = 100;
vector =1:1000;
%numBins = 10;
%midLength=mean([maxLength minLength]);
%jitter = 


i = 1;
inds(i,1) = 1;
ends(i) = 1 + randi(maxLength - minLength) - 1 + minLength - 1;
endDiff = max(vector) - ends(i);
while endDiff >= minLength || ends(end) < max(vector)
    i=i+1;
    inds(i,1) = ends(i-1) + 1;
    ends(i) = inds(i,1) + randi(maxLength - minLength) - 1 + minLength - 1;
    endDiff = max(vector) - ends(i);
end
%Error conditions
if max(vector) - inds(end,1) <= maxLength
    ends(end) = max(vector);
end    
if inds(end,2) < maxLength
    %step back through until find one that isn't too long to add the
    %balance to
end    
if ends(end) > max(vector)
    ends(end) = max(vector);
end    
%}

end