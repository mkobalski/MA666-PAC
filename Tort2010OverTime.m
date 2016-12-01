function [binAmpTime,MItime]Tort2010OverTime(LFsignal,HFsignal,t,numPhaseBins,timeBinWidth,overlap)
%Runs Tort2010 over time 
binCheat=timeBinWidth-overlap+1;
numTimeBins=t/binCheat;

for timeBin=1:numTimeBins
    %pull data, maybe pre-bin by this bin number
    %run tort
    %put bin amp results into 2d matrix, rows are phase bin, columns time
    %plot MI value overtime, maybe superimposed over it
end    
    
end