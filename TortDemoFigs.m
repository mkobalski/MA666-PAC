%patch on one cycle
time=[0:0.001:1];
x=sin(time*2*pi);
fig=plot(time,x,'k','LineWidth',2.5);
ylim([-1.25 1.25])
ax=gca;
ax.XTick=[0 0.25 0.5 0.75 1];
ax.XTickLabel=[{'0', 'pi/2', 'pi', '3/2 pi', '2pi'}];
z=[0.125 0.375 0.375 0.125];
y=[-1.25 -1.25 1.25 1.25];
patch(z,y,'blue','FaceAlpha',0.3);
xlabel('Phase')
ylabel('amplitude')

%patches on 4 cycles
time=[0:0.001:4];
x=sin(time*2*pi);
fig2=plot(time,x,'k','LineWidth',2.5);
ylim([-1.25 1.25])
ax2=gca;
ax2.XTick=[0 0.5 1 1.5 2 2.5 3 3.5 4];
ax2.XTickLabel=[{'0', 'pi', '2pi', '3pi', '4pi', '5pi', '6pi'}];
for gg=1:4
z=[0.125 0.375 0.375 0.125]+gg-1;
y=[-1.25 -1.25 1.25 1.25];
patch(z,y,'blue','FaceAlpha',0.3);
end
xlabel('Phase')
ylabel('amplitude')


%% Quality control
numPhaseBins=18;
uniform = zeros(1,numPhaseBins); uniform(:)=1/numPhaseBins;
couple = zeros(1,numPhaseBins); couple(5)=0.5; couple(14)=0.5;
onebin = zeros(1,numPhaseBins); onebin(2) = 1;
small = zeros(1,numPhaseBins); small(2:4)=[0.25 0.5 0.25];

binAmp=small;
logAmp=log2(binAmp);
ShannonH =-sum(binAmp(logAmp~=-Inf).*logAmp(logAmp~=-Inf)); 
Dkl = log2(numPhaseBins)-ShannonH;
MI=Dkl/log2(numPhaseBins);
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


% MI various lengths of time and noise
%{
[time, y, HFsignal, LFdata]=CFCfakeData1(numSeconds, LF, HF, phaseLock, whiteNoiseAmp,binTrimming);
[LFsignal, HFsignal]=PreProcessForCFC(t,x,LF,HF);
[MI, binAmp, lfPhase, hfAmp]=Tort2010MI(LFsignal, HFsignal, numPhaseBins)
%}
%% For presentation
uniform = zeros(1,numPhaseBins); uniform(:)=0.5;
ideal = zeros(1,numPhaseBins); ideal([5 14])=0.75;
ideal([1 9 10 18]) = 0.25;
ideal([2 8 11 17]) = 0.32;
ideal([4 6 13 15]) = 0.67;
ideal([3 7 12 16]) = 0.5;
figure; 
bar(ideal,'b','BarWidth',0.9,'FaceAlpha',0.5);
hold on
bar(uniform,'g','BarWidth',0.9,'FaceAlpha',0.5);
xlim([0.5 18.5])
ylim([0 1])
xlabel('bin')
ylabel('amount')

%% 4 seconds no noise
LF=5; HF=40;
loNoise=0.65;
hiNoise=1.2;
numPhaseBins=18;

[time, x, ~, ~]=CFCfakeData1(4, LF, HF, 'peaks', 0,0.15,1);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI, binAmp, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp); title(['4s, 0.0 WN, MI= ' num2str(MI)])
%some noise
[time, x, ~, ~]=CFCfakeData1(4, LF, HF, 'peaks', loNoise,0.15,1);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI2, binAmp2, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp2); title(['4s, 0.1 WN, MI= ' num2str(MI2)])
%lots of noise
[time, x, ~, ~]=CFCfakeData1(15, LF, HF, 'peaks', hiNoise,0.15,1);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI3, binAmp3, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp3); title(['4s, 0.4 WN, MI= ' num2str(MI3)])

%15s no noise
[time, x, ~, ~]=CFCfakeData1(15, LF, HF, 'peaks', 0,0.15,0);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI4, binAmp4, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp4); title(['15s, 0.0 WN, MI= ' num2str(MI4)])
%some noise
[time, x, ~, ~]=CFCfakeData1(4, LF, HF, 'peaks', loNoise ,0.15);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI5, binAmp5, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp5); title(['15s, 0.1 WN, MI= ' num2str(MI5)])
%lots of noise
[time, x, ~, ~]=CFCfakeData1(15, LF, HF, 'peaks', 0,4.15);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI6, binAmp6, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp6); title(['15s, 0.4 WN, MI= ' num2str(MI6)])

%30s no noise
[time, x, ~, ~]=CFCfakeData1(30, LF, HF, 'peaks', 0,0.15);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI7, binAmp7, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp7); title(['30s, 0.0 WN, MI= ' num2str(MI7)])
%some noise
[time, x, ~, ~]=CFCfakeData1(30, LF, HF, 'peaks', loNoise,0.15);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI8, binAmp8, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp8); title(['30s, 0.1 WN, MI= ' num2str(MI8)])
%lots of noise
[time, x, ~, ~]=CFCfakeData1(30, LF, HF, 'peaks', 0,4.15);
[LFsignal, HFsignal]=PreProcessForCFC(time,x,LF,HF);
[MI9, binAmp9, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp9); title(['30s, 0.4 WN, MI= ' num2str(MI9)])
MIs=[MI MI2 MI3 MI4 MI5 MI6 MI7 MI8 MI9];

%% raw measures
LF=5; HF=40;
loNoise=0.1;
hiNoise=0.4;
numPhaseBins=18;

[~, ~, HFsignal, LFsignal]=CFCfakeData1(4, LF, HF, 'peaks', 0,0.15);
[MI, binAmp, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp); title(['4s, 0.0 WN, MI= ' num2str(MI)])
%some noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(4, LF, HF, 'peaks', loNoise,0.15);
[MI2, binAmp2, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp2); title(['4s, 0.1 WN, MI= ' num2str(MI2)])
%lots of noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(4, LF, HF, 'peaks', hiNoise,0.15);
[MI3, binAmp3, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp3); title(['4s, 0.4 WN, MI= ' num2str(MI3)])

%15s no noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(15, LF, HF, 'peaks', 0,0.15);
[MI4, binAmp4, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp4); title(['15s, 0.0 WN, MI= ' num2str(MI4)])
%some noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(4, LF, HF, 'peaks',loNoise,0.15);
[MI5, binAmp5, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp5); title(['15s, 0.1 WN, MI= ' num2str(MI5)])
%lots of noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(15, LF, HF, 'peaks', hiNoise,0.15);
[MI6, binAmp6, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp6); title(['15s, 0.4 WN, MI= ' num2str(MI6)])

%30s no noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(30, LF, HF, 'peaks', 0,0.15);
[MI7, binAmp7, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp7); title(['30s, 0.0 WN, MI= ' num2str(MI7)])
%some noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(30, LF, HF, 'peaks', loNoise,0.15);
[MI8, binAmp8, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp8); title(['30s, 0.1 WN, MI= ' num2str(MI8)])
%lots of noise
[~, ~, HFsignal, LFsignal]=CFCfakeData1(30, LF, HF, 'peaks', hiNoise,0.15);
[MI9, binAmp9, ~, ~]=Tort2010MI(LFsignal, HFsignal, numPhaseBins);
figure; bar(binAmp9); title(['30s, 0.4 WN, MI= ' num2str(MI9)])
MIs=[MI MI2 MI3 MI4 MI5 MI6 MI7 MI8 MI9];


%% Figures for presentation

[time, x, HFsignal, LFsignal]=CFCfakeData1(4, 5, 40, 'peaks', 0,0.15);
figure; plot(time,x)

%Marek's version
ts = [0:.001:4]; % interval for longer simulations
f1=5; %lower frequency
f2=40; % higher frequency
A1=1; % amplitude for f1
A2=1; % amplitude for f2
A3=1; % amplitude for f3

low=A1*sin(2*pi*f1*ts); % lower frequency oscillation over ts (2 seconds)
high=A2*sin(2*pi*f2*ts);  % higher frequency oscillation over ts (2 seconds)
dist=A3*sin(2*pi*42*ts); %disturbance at 42 Hz over ts (2 seconds)

a=1; % coupling strength 
b=0.2; % amplitude of compound higher frequency

sim=low+b*(a*low.*high+dist);  % simulated data
figure; plot(ts,sim)

%catherine's mod
t = [0:.001:60]; % interval for longer simulations
f1=5; %lower frequency
f2=40; % higher frequency
A1=1; % amplitude for f1
A2=1; % amplitude for f2
A3=1; % amplitude for f3

low=A1*sin(2*pi*f1*t); % lower frequency oscillation over ts (2 seconds)
high=A2*sin(2*pi*f2*t);  % higher frequency oscillation over ts (2 seconds)
dist=A3*sin(2*pi*42*t); %disturbance at 42 Hz over ts (2 seconds)

%%a=1; % coupling strength 
b=0.2; % amplitude of compound higher frequency
a=zeros(size(t));
events=[1000:1000:58000];
for i=1:length(events)
   eventts=events(i);
   a(1,eventts:eventts+100)=10;
end

sim=low+b*(a.*low.*high+dist);  % simulated data
sim=sim+randn(size(sim))*0.2;
figure; plot(t,sim);




%% Spectrogram
t=ts;

dt=t(2) - t(1);
Fs = 1/dt;
interval = 125;
overlap = round(interval*0.95);
nfft = round(1500);
[S,F,T,P]=spectrogram(x(1:4000)-mean(x(1:4000)),interval,overlap,nfft,Fs);
figure; imagesc(T,F,10*log10(P))
colorbar
axis xy
ylim([0 70])
xlabel('Time (s)')
ylabel('Frequency (Hz)')








