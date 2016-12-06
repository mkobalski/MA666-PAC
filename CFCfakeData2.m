function [time, x, low, highComp] = CFCfakeData2(numSeconds,LF,HF,distF,couplingStrength,whiteNoiseAmp,couplingStrength)

resol=0.001;
if ~exist('LF','var')
    LF = 5;
elseif ~exist('HF','var')
    HF = 40;
elseif ~exist('numSeconds','var')
    numSeconds = 30;
elseif ~exist('dist','var')
    distF = 42;
elseif ~exist('couplingStrength','var')
    couplingStrength=1;
elseif ~exist('whiteNoiseAmp','var')
    whiteNoiseAmp=0.2;
end

t = [resol:resol:numSeconds]; % interval for longer simulations

A1=1; % amplitude for f1
A2=1; % amplitude for f2
A3=1; % amplitude for f3

low=A1*sin(2*pi*LF*t); % lower frequency oscillation over ts (2 seconds)
high=A2*sin(2*pi*HF*t);  % higher frequency oscillation over ts (2 seconds)
dist=A3*sin(2*pi*distF*t); %disturbance at 42 Hz over ts (2 seconds)

couplingStrength=1; 
b=0.2; % amplitude of compound higher frequency

highComp=b*couplingStrength*low.*high;
whiteNoise = randn(size(simt))*whiteNoiseAmp;
x=low+highComp+b*dist+whiteNoise;  % simulated data
%plot(t,x)

end