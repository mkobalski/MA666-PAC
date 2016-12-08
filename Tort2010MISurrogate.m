function [ShuffleMIs] = Tort2010MISurrogate(LFsignal, HFsignal, numShuffles, binSizes, numPhaseBins) 
%Surrogate control: shuffles hfAmp (already Hilbert'd) by breaking it into
%bins of user input size and re-ordering them, then computing the Tort 2010
%MI on that. Repeats it a bunch. Expects binSizing to be a 2 item input,
%of format [minLength maxLength] for bin sizes, in number of timestamps of
%input signals.
%is it ok to shuffle the signal it self, or do you have to shuffle the
%amplitude envelope? Maybe figure out how to check to be sure...

if length(binSizes)~=2
    disp('Error, binSizes must be 2, [min max]')
    return
end 

vector=HFsignal;
minLength = binSizes(1);
maxLength = binSizes(2);

% 1. Get bins
%{
minLength = 50;
maxLength = 100;
vector =1:1000;
%}
ShuffleMIs = zeros(numShuffles,1);
for shuffleNum=1:numShuffles
i = 1;
inds(i,1) = 1;
inds(i,2) = 1 + randi(maxLength - minLength) - 1 + minLength - 1;
endDiff = length(vector) - inds(i,2);
while endDiff >= minLength && inds(end,2) < length(vector)
    i=i+1;
    inds(i,1) = inds(i-1,2) + 1;
    inds(i,2) = inds(i,1) + randi(maxLength - minLength) - 1 + minLength - 1;
    endDiff = length(vector) - inds(i,2);
end

%Works, almost always results in a minLength bin at the end
if inds(end,2) < length(vector) %this probably always happens
    switch max(vector) - inds(end,1) <= maxLength
        case 1 %if we can just add it to the end and still be good
            inds(end,2) = length(vector);
        case 0    
            deficit = length(vector) - inds(end,2);
            lengths=inds(1:(end-1),2)-inds(1:(end-1),1) + 1;% +1 inclusive
            switch deficit > minLength/2
                case 1 %make a new bin, steal some from the last one
                    good = lengths - (minLength - deficit) >= minLength;
                    adjust = find(good,1,'last');
                    inds(adjust:end,2) = inds(adjust:end,2) - (minLength - deficit);
                    inds(size(inds,1)+1,:) = [inds(size(inds,1),2)+1 length(vector)];
                case 0 %add it to the last bin that can take it
                    good = lengths + deficit <= maxLength;
                    switch any(good)
                        case 1
                            adjust = find(good,1,'last'); 
                            inds(adjust:end,2) = inds(adjust:end,2) + deficit;
                        case 0
                            % Fall back, fall back
                            %Curious to see how often this happens.
                            good = lengths - (minLength - deficit) >= minLength;
                            adjust = find(good,1,'last');
                            inds(adjust:end,2) = inds(adjust:end,2) - (minLength - deficit);
                            inds(size(inds,1)+1,:) = [inds(size(inds,1),2)+1 length(vector)];
                    end   
                      
            end
            %Move all starts forward depending on the new ends
            if adjust < size(inds,1)-1
                inds(adjust+1:end,1) = inds(adjust:end-1,2) + 1;
                %it would be smarter just to do ends and then get
                %starts later
            end               
    end
end    
    
if inds(end,2) > length(vector) 
    inds(end,2) = length(vector);
end 

% 2. Shuffle the stuff
hfAmpShuffled = [];
shuffledInds = randperm(size(inds,1));
for shuffledInd=1:size(inds,1)
    hfAmpShuffled = [hfAmpShuffled HFsignal(inds(shuffledInds(shuffledInd),1):inds(shuffledInds(shuffledInd),2))];
end

% 4. Get an MI on this
[MI, ~, ~, ~] = Tort2010MI(LFsignal, hfAmpShuffled, numPhaseBins);
ShuffleMIs(shuffleNum)=MI;

clear inds hfAmpShuffled i
end %shuffling loop
% 5. Get an SD and p-val

%{
%Demo figs
colorsPatch=...
   [0.4000    0.6000    1.0000
    0.4000         0    1.0000
    0.4000    0.2000    0.8000
    1.0000         0         0
    1.0000         0    0.4000
    1.0000    0.4000         0
    1.0000    0.8000         0
    0.4000    1.0000         0
         0    1.0000    0.2000
         0    0.4000    0.4000];
demT=0.001:0.001:1;
z=sin(demT*2*pi);
figure; 
for gg=1:10
    x=[0 0.1 0.1 0]+0.1*(gg-1);
    y=[-1.25 -1.25 1.25 1.25];
    patch(x,y,colorsPatch(gg,:),'FaceAlpha',0.5);
end
hold on
plot(demT,z,'k','LineWidth',2)
ylim([-1.25 1.25])
title('Original')

randoms=randperm(10);
figure; 
for gg=1:10
    x=[0 0.1 0.1 0]+0.1*(gg-1);
    y=[-1.25 -1.25 1.25 1.25];
    patch(x,y,colorsPatch(randoms(gg),:),'FaceAlpha',0.5);
end
hold on
plot(demT,z,'k','LineWidth',2)
ylim([-1.25 1.25])
title('Shuffled')
%}

end
