function [ mfccCoefficients ] = GetMFCCCoefficients( audiodata, bitrate, sampleMode, plotMFCC )
%GetMFCCCoefficients Computes the 13 MFCC-Coefficients from a audiosample
%   Detailed explanation goes here

%=======================================
% Pre-Emphasis Filter (Akzentuierung)
% Anhebung der hohen Frequenzen
%=======================================
alpha   = 0.9;            % 0.9 <= alpha <= 1

% Filterkoeffizienten
b       = [1 - alpha];
a       = 1;

%=======================================
% Filterung Spektrum ja/nein
%=======================================
if sampleMode == SampleMode.Preemphasis_On_Liftering_Off || sampleMode == SampleMode.Preemphasis_On_Liftering_On
    audioDataFilter = filter(b, a, audiodata);
else
    audioDataFilter = audiodata;
end


%=======================================
% Original-Spektrum plotten (nur pos Frequenzen)
%=======================================
spec = fft(audiodata);
f = bitrate/2*linspace(0,1,length(spec)/2+1);


%=======================================
% Gefiltertes-Spektrum plotten (nur pos Frequenzen)
%=======================================
    
spec = fft(audioDataFilter);
f = bitrate/2*linspace(0,1,length(spec)/2+1);

%=======================================
% Zeitliche Fensterung
%=======================================

% Zeitshift
frame_t_ms = 25;   
win_shift_ms = 10;      

% Shift in Samples
frame_dur_samp = (frame_t_ms/1000) * bitrate;
win_shift_samp = (win_shift_ms/1000) * bitrate;

% Fensterfunktion
win = hamming(frame_dur_samp);

%=======================================
% Sprachsignal in Fenster unterteilen
%=======================================
padding = 0;
matrix = vec2frames(audioDataFilter,frame_dur_samp,win_shift_samp,'cols',win,padding);

%=======================================
% Fouriertransformation jeder Zeile
%=======================================
ft = abs(fft(matrix)).^2; 

%=======================================
% Berechnung der Filterbank
%=======================================
filter_kanaele = 24;

min_frequ = 20;
max_frequ = 8000;

borders = [min_frequ max_frequ];

%=======================================
% MEL-Filterbank bauen
%=======================================
[H,f,c] = trifbank_V02(filter_kanaele,frame_dur_samp/2,borders,bitrate);


f = bitrate/2*linspace(0,1,frame_dur_samp/2);


%=======================================
% Filterbank Anwendung 
%=======================================

mel_spectrum = H * ft(1:frame_dur_samp/2,:); 

%=======================================
% Logarithmierung des Ergebnisses
%=======================================

log_mel_spectrum = log(mel_spectrum);

%=======================================
% Anzahl Cepstrum-Koeffizienten
%=======================================
anz_cep_koeffs = 13; 

%=======================================
% DCT Matrix erstellen
%=======================================
DCT = dct_matrix( anz_cep_koeffs, filter_kanaele );

%=======================================
% DCT anwenden
%=======================================
mfccCoefficients =  DCT * log_mel_spectrum;

%=======================================
% Liftering (anhebung hohe Cep-Koeffs)
%=======================================
if sampleMode == SampleMode.Preemphasis_Off_Liftering_On || sampleMode == SampleMode.Preemphasis_On_Liftering_On
    lifter = ceplifter_func( anz_cep_koeffs, 22 );
    mfccCoefficients = diag( lifter ) * mfccCoefficients;
end

if(plotMFCC)
    [ Nw, NF ] = size( matrix ); 
    % Zeitachse in Frames
    time_frames = [0:NF-1]*win_shift_ms*0.001+0.5*Nw/bitrate;
    
    imagesc( time_frames, [1:anz_cep_koeffs], mfccCoefficients(2:end,:) );
    axis( 'xy' );
    xlim( [ min(time_frames) max(time_frames) ] );
    xlabel( 'Time (s)' );
    ylabel( 'Cepstrum Index' );
    title( 'MFCC' ); 
end

end

