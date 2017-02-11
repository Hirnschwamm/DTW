function [ H, f, c ] = trifbank_V02( M, K, R, fs)

%   Reference
%           [1] Huang, X., Acero, A., Hon, H., 2001. Spoken Language Processing: 
%               A guide to theory, algorithm, and system development. 
%               Prentice Hall, Upper Saddle River, NJ, USA (pp. 314-315).

%   Author  Kamil Wojcicki, UTD, June 2011


    if( nargin~= 4 ), help trifbank; return; end; 

    f_min = 0;          % filter coefficients start at this frequency (Hz)
    f_low = R(1);       % lower cutoff frequency (Hz) for the filterbank 
    f_high = R(2);      % upper cutoff frequency (Hz) for the filterbank 
    f_max = 0.5*fs;     % filter coefficients end at this frequency (Hz)
    f = linspace( f_min, f_max, K ); % frequency range (Hz), size 1xK
    
    fw = hz2mel_transform(f);
    
    %fw = h2M( f );

    c = mel2hz_transform( hz2mel_transform(f_low)+[0:M+1]*...
        ((hz2mel_transform(f_high)-hz2mel_transform(f_low))/(M+1)) );
    %c = M2h( h2M(f_low)+[0:M+1]*((h2M(f_high)-h2M(f_low))/(M+1)) );
    
    cw = hz2mel_transform(c);
    
    %cw = h2M( c );

    H = zeros( M, K );                  % zero otherwise
    for m = 1:M 

        k = f>=c(m) & f<=c(m+1); % up-slope
        H(m,k) = (f(k)-c(m))/(c(m+1)-c(m));
        k = f>=c(m+1)&f<=c(m+2); % down-slope
        H(m,k) = (c(m+2)-f(k))/(c(m+2)-c(m+1));
       
    end


