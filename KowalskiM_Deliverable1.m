% Reproducing 1B from Canolty et al. (2006):
% Semi-exploratory phase-amplitude coupling: Which freqencies are modulated in amplitude by theta phase?

%{
    PLEASE NOTE: The filtering (bandpassing) stages of this script utilize the eegfilt.m function from the eeglab toolbox. This function has been used for simplicity of demonstration
        on simulated data. However, it has been found that filters used by eegfilt may be highly sensitive to noise. Design your own filters if analyzing real data with this script.
            
            %}


srate=1000;  % sampling rate
x=sim;       % row vector of raw data
maxf=100;    % maximum frequency examined
minf=4;      % minimum frequency examined




% Bandpass the raw signal from minf to maxf in 2-Hz steps, banwidth of 4 Hz:

x_bp=[];     % create an empty matrix to store bandpass data
i=minf;
while i<=maxf
x_bp=[x_bp; eegfilt(x,srate,i-2,i+2)];
i=i+2;
end

%Create a vector of center frequencies corresponding to individual bands:
bandfreq = 4:2:100;




% Normalize each of the bandpass signals by subtracting temporal mean and dividing by temporal stdev:

x_mean=mean(x_bp,2);
x_sd=std(x_bp,0,2);
x_norm=zeros(size(x_bp));

for i=1:size(x_bp,2)
x_norm(:,i)=(x_bp(:,i)-x_mean)./x_sd;
end



%Perform a Hilbert Transform on each normalized bandpass signal
x_hil=hilbert(x_norm');

              
              
%Compute a power series from Hilbert transform
x_power=(abs(x_hil')).^2;

    
             
%Isolate the theta band 4-8 Hz (single band centered at 6 Hz)
theta=x_bp(find(bandfreq==6),:);

             
%Hilbert transform & extract phase of theta:
theta_hil=hilbert(theta);
theta_phi=angle(theta_hil);

             
             
             
% Find local minima (troughs) of theta phase:

troughs=zeros(1,15001);
for i=2:length(theta_phi)-1
if theta_phi(i)<theta_phi(i+1) & theta_phi(i)<theta_phi(i-1)
troughs(i)=theta_phi(i);
else troughs(i)=0;
end
end
troughs_ind=find(troughs<=-2.8);  % choose only those minima that are lower than 2.8 (arbitrarily low number)


             
             
% Average 2-second fragments of bandpassed, normalized theta centered at troughs:

theta_locked=[];
theta_locked_norm=[];

for i=1:length(troughs_ind)-1
    if troughs_ind(i)>srate & troughs_ind(i)<(length(theta_phi)-srate)
        theta_locked=[ theta_locked  ; x(troughs_ind(i)-srate:troughs_ind(i)+srate)];
        theta_locked_norm=[ theta_locked_norm  ; x_norm(2, troughs_ind(i)-srate:troughs_ind(i)+srate)];
        
    end
end
theta_wave = mean(theta_locked_norm);


             
% For all other frequencies, average power centered at theta troughs:
             
x_P=[];

for i=1:size(x_power,1)
    locks=[];
    for j=1:length(troughs_ind)-1
        if troughs_ind(j)>srate & troughs_ind(j)<(length(theta_phi)-srate)
        locks=[locks; x_power(i,troughs_ind(j)-srate:troughs_ind(j)+srate)];
        end
    end
x_P=[ x_P; mean(locks) ];
end

             
             
% For spectral plotting, define x axis as time with respect to theta troughs:
time_theta=linspace(-1000,1000,length(theta_wave));
             

             
% Plot results, as per Canolty et al. (2006), Fig. 1B:
subplot(3,1,1); plot(2000:4000, x(2000:4000)); axis tight; xlabel('Time [ms]'); ylabel('Voltage'); title('Raw signal');
subplot(3,1,3); plot(time_theta, theta_wave); axis tight; xlabel('Time [ms]'); ylabel('Amplitude'); title('Theta wave');
subplot(3,1,2); imagesc(time_theta, bandfreq, x_P); axis xy; colormap jet; xlabel('Time [ms]'); ylabel('Frequency [Hz]'); title('Modulation heatmap');

             
    
