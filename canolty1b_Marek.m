% Reproducing 1B from Canolty et al. (2006) on ketamine data from Seun

%Bandpass filter on a range of center frequencies (in my case, 4-100 Hz)
%with 4-Hz bandwidths in 2-Hz steps (= 2 Hz of overlap between two
%neighboring bands)


%Filter out noise around 60 Hz (d1) and 78 Hz (d2) from data




%{
d1 = designfilt('bandstopiir','FilterOrder',2, ...
'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
'DesignMethod','butter','SampleRate',srate);

d2 = designfilt('bandstopiir','FilterOrder',2, ...
'HalfPowerFrequency1',77,'HalfPowerFrequency2',79, ...
'DesignMethod','butter','SampleRate',srate);

x=sim;
x=filtfilt(d1, filtfilt(d2,x));
%}

srate=1000;
x=y;

% Start

i=4;
maxf=100;
x_bp=[];

while i<=maxf
x_bp=[x_bp; eegfilt(x,srate,i-2,i+2)];
i=i+2;
end

%Create a vector of center frequencies of the bandpass filter
bandfreq = 4:2:100;

%Plot(t,x_bp(find(bandfreq==k),:))  %plot bandpass signal from around your center frequency of choice


%Normalize each of the bandpass signals by subtracting temporal mean and dividing by temporal stdev
x_mean=mean(x_bp,2);
x_sd=std(x_bp,0,2);
x_norm=zeros(size(x_bp)); %initiate matrix of normalized signal 

for i=1:size(x_bp,2)
x_norm(:,i)=(x_bp(:,i)-x_mean)./x_sd;
end

%Perform a Hilbert Transform on each normalized bandpass signal
x_hil=hilbert(x_norm');

%Compute a power series from Hilbert transform
x_power=(abs(x_hil')).^2;

%Isolate the theta band 5-9 Hz (single band centered at 6 Hz)
theta=x_bp(find(bandfreq==6),:);
%Hilbert transform of 5-9
theta_hil=hilbert(theta);
%Extract phase information of theta
theta_phi=angle(theta_hil);

%Finding local minima of theta:

troughs=zeros(1,15001);    % 0 if no minimum, value if there is a minimum
for i=2:length(theta_phi)-1
if theta_phi(i)<theta_phi(i+1) & theta_phi(i)<theta_phi(i-1)
troughs(i)=theta_phi(i);
else troughs(i)=0;
end
end
troughs_ind=find(troughs<=-2.8);


% Locking theta phase to troughs:

theta_locked=[];
theta_locked_norm=[];

for i=1:length(troughs_ind)-1
    if troughs_ind(i)>250 & troughs_ind(i)<(length(theta_phi)-250)
        theta_locked=[ theta_locked  ; x(troughs_ind(i)-250:troughs_ind(i)+250)];
        theta_locked_norm=[ theta_locked_norm  ; x_norm(2, troughs_ind(i)-250:troughs_ind(i)+250)];
        
    end
end
theta_wave = mean(theta_locked_norm);


x_P=[];

for i=1:size(x_power,1)
    locks=[];
    for j=1:length(troughs_ind)-1
        if troughs_ind(j)>250 & troughs_ind(j)<(length(theta_phi)-250)
        locks=[locks; x_power(i,troughs_ind(j)-250:troughs_ind(j)+250)];
        end
    end
x_P=[ x_P; mean(locks) ];
end

             
             
             


%time_theta=linspace(-1000,1000,size(theta_wave,2));


%Plot phase series for theta with superimposed local minima ("troughs")
%plot(t,theta_phi)
%hold on; plot(t(troughs_ind),troughs(troughs_ind),'.r')
%labels('Time [ms]','Phase angle','Theta (5-9 Hz) phase for patient #5')
%legend('Theta phase angle','Local minima identified as "theta troughs"')
%set(gca,'XTickLabel',0:10000:60000)

%{
image:

imagesc(linspace(-1000,1000,length(theta_wave)),bandfreq,x_P); axis xy,
colormap jet; xlabel('Time [ms]'); ylabel('Frequency [Hz]')

plot(linspace(-1000,1000,length(theta_wave)),theta_wave); axis tight

%}

% figure; imagesc(x_P,[1.6 2.3]); colormap jet
