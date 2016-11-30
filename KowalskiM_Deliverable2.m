% Reproducing figure 1D (modulation index) from Canolty 2006
% Exploratory analysis of phase-amplitude coupling: What are the most
% significant relationships between phases of 2-20 Hz and amplitudes of 5-100 Hz?

x=sim;
srate=1000;

maxf_a=100;
maxf_p=20;
minf_a=5;
minf_p=2;

xa_bp=[];   % set up empty matrix for bandpassed amplitudes
xp_bp=[];   % set up empty matrix for bandpassed phases



% Bandpass raw signal every 5 Hz with 4 Hz bandwidth, in the range 5-100 Hz
i=minf_a;
while i<=maxf_a
xa_bp=[xa_bp; eegfilt(x,srate,i-2,i+2)];
i=i+5;
end

% Bandpass raw signal every 1 Hz, with 1 Hz bandwidth, in the range 2-20 Hz
j=minf_p;
while j<=maxf_p
    xp_bp=[xp_bp; eegfilt(x,srate,j-.5,j+.5)];
    j=j+1;
end

bandfreq_a=5:5:100;   % center frequencies for amplitude
bandfreq_p=2:1:20;    % center frequencies for phase



% Extract amplitudes and phases from bandpassed signals:
amplis=(abs(hilbert(xa_bp')))';
phases=(angle(hilbert(xp_bp')))';



% Compute raw values of modulation indices:
M_raws=zeros(size(amplis,1),size(phases,1));
for i=1:size(M_raws,1)
    for j=1:size(M_raws,2)
        M_raws(i,j)=abs(mean(amplis(i,:).*exp(1i*phases(j,:))));
    end
end



% Create surrogate amplitudes for all frequencies using a time lag:

n=length(x);
numsurrogate=200;
minskip=srate;
maxskip=n-srate;
skip=ceil(n.*rand(numsurrogate*2,1));
skip(find(skip>maxskip))=[];
skip(find(skip<minskip))=[];
skip=skip(1:numsurrogate,1);

sur_amplis=[];
sur_M=[];
for i=1:size(amplis,1)
    for s=1:numsurrogate
        for k=1:size(phases,1)
        sur_amplis(i,:)=[amplis(i,skip(s):end) amplis(i,1:skip(s)-1)];
        sur_M(i,s,k)=abs(mean(sur_amplis(i).*exp(1i*phases(k,:))));
        end
    end
end


% Fit normal distributions to the surrogate values and obtain mean and
% standard deviation:

for i=1:size(sur_M,1)
    for k=1:size(sur_M,3)
    [m,n]=normfit(sur_M(i,:,k));
    sur_mean(i,k)=m;
    sur_st(i,k)=n;
    end
end


% Normalize raw modulation index values using mean and stdev of surrogate
% values:
M_norm_length=(abs(M_raws)-sur_mean)./sur_st;
M_norm_phase=(angle(M_raws));
M_norm=M_norm_length.*exp(1i*M_norm_phase);


% Plot a heatmap of modulation indices:
imagesc(bandfreq_p, bandfreq_a, M_norm); axis xy;
xlabel('Frequencies for phase [Hz]'); ylabel('Frequencies for amplitude [Hz]');
title('Modulation index for an array of combinations of amplitudes and phases');
colormap jet; colorbar;



