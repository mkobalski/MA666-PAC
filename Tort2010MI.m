%{ 
    Tort et al. 2010 phase-amplitude modulation index (MI) pseudocode

    Modulation distribution:
    1. Filter signal for both frequency ranges interested in (LF/phase and
    HF/amplitude).
    2. Use the Hilbert transform to extract phase of LF and time series of
    amplitude envelope of HF. Then have composite N x 2 matrix with 
        [ LF phase , HF amplitude ]
    3. Bin phases and mean of HF amplitude over each phase bin. 
    4. Normalize mean amplidue by dividing each bin value by the sum over
    the bins.

    KL distance:
    1. Where P and Q are different distributions, 
        Dkl(P, Q) = sum(j:N)*P(j)*log[P(j)/Q(j)]
    
    2. Can also b calculated using Shannon entropy, where U is the uniform,
        Shannon H(P) = -sum(j:N)*P(j)*log[P(j)]
        then
        Dkl(P, U) = log(N)-H(P)
    
    Modulation index:
    1. MI = Dkl(P, U) / log(N)
%}

%{ 
    Notes on implementation:
    Probably want to go shannon route, don't have to deal with a second
    distribution, but might be useful to do that version later as a sanity
    check. 

    Really this easy to calculate using these formulas right here?
    
    Assume that each value of P distribution is that in bin j
    
    coherence between the amplitude envelope AfA and the phase-modulating rhythm fp
    "It should also be noted that the MI loses time information and it cannot 
    tell us whether the coupling occurred during the whole epoch being 
    analyzed or whether there occurred bursts of coupling inside the
    epoch." 
        So maybe we can try binning signal into chunks to see how this
        measure falls apart? 
    Figure 3: probably need about 30 seconds of data to be confident in
    spite of noise in signal

    Variance/confidents of results?
%}