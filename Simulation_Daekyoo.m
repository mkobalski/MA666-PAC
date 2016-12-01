% Simulation Data
t = [0:.001:60]; % interval for longer simulations
ts=[0:.001:2]; % sample interval (time)
f1=5; %lower frequency
f2=40; % higher frequency
A1=1; % amplitude for f1
A2=1; % amplitude for f2
A3=1; % amplitude for f3

low=A1*sin(2*pi*f1*ts); % lower frequency oscillation over ts (2 seconds)
high=A2*sin(2*pi*f2*ts);  % higher frequency oscillation over ts (2 seconds)
dist=A3*sin(2*pi*42*ts); %disturbance at 42 Hz over ts (2 seconds)

%%a=1; % coupling strength 
b=0.2; % amplitude of compound higher frequency
a=ones(1,2001);
a(1,200:220)=5;
% a(1,400:410)=5;
a(1,600:620)=5;
%a(1,800:810)=5;
a(1,1000:1020)=5;
%a(1,1200:1210)=5;
a(1,1400:1420)=5;
%a(1,1600:1610)=5;
a(1,1800:1820)=5;

sim=low+b*(a.*low.*high+dist);  % simulated data
sim=sim+randn(size(sim))*0.2;

%--------------------------------------------------------------------
% Visual Inspection
figure(1), subplot(2,3,1)
plot(ts,sim)
hold on
title('Voltage Trace','linewidth',0.5,'fontsize',9)
xlabel('Time [s]','fontsize',9)
ylabel('Voltage [mV]','fontsize',9)
%events=[200 600 1000 1400 1800];

dt=ts(3)-ts(2);
srate=1/dt;
data=sim;
locutoff=5;
hicutoff=40;
[smoothdata] = eegfilt(data,srate,locutoff,hicutoff);
f=srate;
T = ts(end);
N = length(data);
x=smoothdata';
x = hann(N).*x;
%-----------------------------------------------------------
% Fourier Transform of simulation data
xf = fft(x)-mean(x);
Sxx = (2*dt^2/T)*(xf.*conj(xf));
Sxx = Sxx(1:N/2+1);
df = 1/max(T);
fNQ = f/2;
faxis = (0:df:fNQ);

subplot(2,3,2)
plot(faxis, Sxx)
plot(faxis, 10*log10(Sxx))
xlim([0 60]);
ylim([-120 0]);
title('Spectrum','fontsize',9)
xlabel('Frequency [Hz]','fontsize',9)
ylabel('Power [mV^2/Hz]','fontsize',9)

% Filtering data into low- and high-frequency band
Wn = 10/fNQ;
n = 100;
b = fir1(n,Wn,'low');
% Low-frequency signal
Vlo = filtfilt(b,1,sim);

Wn = [30,50]/fNQ;
n = 100;
b = fir1(n,Wn); 
% High-frequency signal
Vhi = filtfilt(b,1,sim);

subplot(2,3,3)
plot(ts, Vlo)
title('Filtering','fontsize',9)
hold on
plot(ts, Vhi)
legend('low','high')

% Extracting the Amplitude and Phase from filtered signal
phi = angle(hilbert(Vlo));
phi=phi+pi/2;
phi(phi<0)=phi(phi<0)+2*pi;
amp = hilbert(Vhi);
amp = amp.*conj(amp);

subplot(2,3,4)
plot(ts,phi)
title('Phase of LF','fontsize',9)
subplot(2,3,5)
plot(ts,amp)
title('Amplitude of HF','fontsize',9)

%-----------------------------------------------------
% Determine if the phase and amplitude are related
% Phase-amplitude plot
num_p_bins = 18;
p_bins = 360/num_p_bins;
p_bins_deg = 0:p_bins:360;
p_bins_rad = deg2rad(p_bins_deg);

a_mean = zeros(num_p_bins-1,1);
p_mean = zeros(num_p_bins-1,1);
for k=1:num_p_bins-1
    pL = p_bins_rad(k);
    pR = p_bins_rad(k+1);
    indices=find(phi>=pL & phi<pR);
    a_mean(k) = mean(amp(indices));
    p_mean(k) = mean([pL, pR]);
end

% Difference between max and min modulation (Is it mean vector length? 
% or modulation index (MI)?)
h = max(a_mean)-min(a_mean);

pa_mean = [p_mean, a_mean];
a_mean_temp = find(a_mean==max(a_mean));
max_a_mean = pa_mean(a_mean_temp,:);
a_mean_temp = find(a_mean==min(a_mean));
min_a_mean = pa_mean(a_mean_temp,:);

subplot(2,3,6)
plot(p_mean, a_mean,'k-','linewidth',2)
hold on
plot([max_a_mean(1),max_a_mean(1)],[max_a_mean(2),min_a_mean(2)],...
    'b-', 'linewidth', 2)
title('Phase-amplitude','fontsize',9)
xlabel('LF Phase [radians]','fontsize',9)
ylabel('HF Amplitude','fontsize',9)
xlim([0 7])

% Surrogate data
n_surrogates = 1000;
h_s = zeros(n_surrogates,1);

for n_s=1:n_surrogates;
    amp_s = amp(randperm(length(amp)));
    phi_s = phi(randperm(length(phi)));
   
    a_mean = zeros(num_p_bins-1,1);
    p_mean = zeros(num_p_bins-1,1);
    for k=1:num_p_bins-1
        pL = p_bins_rad(k);
        pR = p_bins_rad(k+1);
        indices = find(phi_s>=pL & phi_s<pR);
        a_mean(k) = mean(amp_s(indices));
        p_mean(k) = mean([pL, pR]);
    end
    h_s(n_s) = max(a_mean)-min(a_mean);
end

figure(2),hist(h_s)
hold on
plot([h,h],[0 300],'r-','linewidth',2)
title('h distribution','fontsize',9)

legend('simulation','surrogate')
xlabel('h','fontsize',9)
ylabel('Counts','fontsize',9)

% Compute the p-value
% A p-value is very small (closed to 0); there are no surrogate values
% of h that exceed the observed value of h. 
% So, we can conclude that the observed value of h is significant.
% We can reject the null hypothesis of no CFC between 
% the phase of the 5 Hz low-frequency band and the amplitude of 
% the 40 Hz high-frequency band.
p = length(find(h_s>h))/length(h_s);
p_value=fprintf('p-value is %d!',p);
msgbox('p_value is smaller than 0.05; there are no surrogate values of h that exceed simulation value of h.')

% MI_Tort(2010b): surrogate data
LFsignal = Vlo(randperm(length(Vlo)));
HFsignal = Vhi(randperm(length(Vhi)));
numPhaseBins=18;
[MI, binAmp, lfPhase, hfAmp]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
MI_s=MI;
binAmp_s=binAmp;
lfPhase_s=lfPhase;
hfAmp_s=hfAmp;

% MI_Tort(2010b)
LFsignal=Vlo;
HFsignal=Vhi;
numPhaseBins=18;
[MI, binAmp, lfPhase, hfAmp]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
y=[MI; MI_s];
fHand = figure(3);
aHand = axes('parent',fHand);
hold(aHand,'on')

colors = hsv(numel(y));
for i = 1:numel(y)
    bar(i, y(i),0.5, 'parent', aHand, 'facecolor', colors(i,:));
end
set(gca, 'XTick', 1:numel(y), 'XTickLabel', {'MI observed', 'MI simulated'})
title('Comparison of MI')
ylabel('Modulation Index')

% GLM-CFC
% Eight control points
% We have analyzed the low- and high-frequency signals.
% r and its 95% CI
% The approximately ~% maximal deviation between the two models is
% represented by the height of the blue vertical line. 
% We can conclude that CFC occurs between the chosen low- and
% high-freuquency bands.
% These results are consistent with the conclusions from the
% phase-amplitude plot and MI as well.

nCtlPts = 8;
[r, r_CI] = GLM_CFC(Vlo, Vhi, nCtlPts);
title('GLM','fontsize',9)

