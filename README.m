%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                      %
%                   README GUIDE for MA666 project on                  %
%                       CROSS-FREQUENCY COUPLING                       %
%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%{
This project includes scripts to:
    - Simulate data: 
        CFCfakeData1.m: simple LF sine + HF sine, plus white noise, HF
        directly phase locked to LF.
        Marek's: some kinda multiplier thing
    - Pre-process data: filtering into standardized format for use with any
        of our functions. Returns the filtered HF and LF data signals, uses
        eegfilt from EEG toolbox, included here. 
        PreProcessForCFC.m: we filter in 5hz bands.
    - Compute measures of cross-frequency coupling using as inputs the
        filtered signals from pre-processed data. These measures do no
        filtering. Some measures require additional inputs, possibly
        including the original unfiltered signal. 
        Tort2010MI.m
        canolty1b_Marek.m
        eroac_corr.m ????

    All our measures were designed to look at theta/gamma coupling, but
    should be robust enough to handle other frequency bands

We additionally include sample simulated data for use in comparing how each
measure handles different aspects of EEG/LFP signals. These are:
    - 30s 5hz with peak-, trough-, ascending- or descending-locked 40hz
        signal. 
    - 30s 5hz with peak-, trough-, ascending- or descending-locked 40hz
        signal with low-amplitude white noise
    - 30s 5hz with peak-, trough-, ascending- or descending-locked 40hz
        signal with high-amplitude white noise
    OTHER simulated data?
%}

%{

Suggestions for use:
    1. Run data through PreProcessForCFC.m
        Expects as inputs the signal and a time variable with time stamps
        for each point, along with LF and HF variables (e.g., 5 and 40)
    2. Run pre-processed signals through function for desired measure

That's it, really. 
%}
 