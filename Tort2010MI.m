function [MI, binAmp, lfPhase, hfAmp]=Tort2010MI(LFsignal, HFsignal, varargin)
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
for j=1:2:length(varargin)/2
    if strcmpi(varargin{j},'numPhaseBins')
        numPhaseBins=varargin{j+1};
    end
end    

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
    isThisPhaseBin=lfPhase > binEdgesRad(bin) & lfPhase <= binEdgesRad(bin+1);
    phaseBinOnly=hfAmp.*isThisPhaseBin;
    binAmp(bin)=sum(phaseBinOnly)/sum(isThisPhaseBin);
end
binAmp=binAmp/sum(binAmp);%normalized     
        
%Here plot bar graph with sinewave overlay, xlabels phasebin edges

%KL distance
ShannonH =-sum(binAmp.*log(binAmp)); %should be log2(x)?
Dkl = log(numPhaseBins)-ShannonH;

MI=Dkl/log(numPhaseBins);
end