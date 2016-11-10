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

a=1; % coupling strength 
b=0.2; % amplitude of compound higher frequency

sim=low+b*(a*low.*high+dist);  % simulated data
plot(ts,sim)