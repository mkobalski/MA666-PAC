function [binAmpTime,MItime]=Tort2010OverTime(LFsignal,HFsignal,t,numPhaseBins,LF)
%Runs Tort2010 over time 
%Does not handle when timeBinWidth and olverlap doesn't align to trial end
%Right now picks timebin size and overlap for you

dt = t(2)-t(1);
timeBinWidth = 1/dt/LF;
overlap = timeBinWidth/4;
binStep = timeBinWidth - overlap;
 
bins = [1:binStep:length(t)]';
bins(:,2) = bins(:,1)+timeBinWidth-1;
if bins(end,2) > length(t)
    %spacing doesn't align with end of signal
end    

binAmpTime = zeros(numPhaseBins,size(bins,1));
MItime = zeros(size(bins,1),1);
for timeBin=1:size(bins,1)
    LFthisBin = LFsignal(bins(timeBin,1):bins(timeBin,2));
    HFthisBin = HFsignal(bins(timeBin,1):bins(timeBin,2));
    [MI, binAmp, ~, ~] = Tort2010MI(LFthisBin, HFthisBin, numPhaseBins);
    MItime(tineBin) = MI;
    binAmpTime(:,timeBin) = binAmp';
end    
    
end