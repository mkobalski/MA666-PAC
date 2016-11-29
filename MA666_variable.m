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
% a(1,400:420)=5;
a(1,600:620)=5;
%a(1,800:820)=5;
a(1,1000:1020)=5;
%a(1,1200:1220)=5;
a(1,1400:1420)=5;
%a(1,1600:1620)=5;
a(1,1800:1820)=5;

sim=low+b*(a.*low.*high+dist);  % simulated data
figure()
plot(ts,sim)