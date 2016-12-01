clear
%%Creates a simulated signal that will change in coupling strength based on
%%events given in a

t = [0:.001:60]; % interval for longer simulations
ts=[0:.001:2]; % sample interval (time)
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
figure()
plot(t,sim)


