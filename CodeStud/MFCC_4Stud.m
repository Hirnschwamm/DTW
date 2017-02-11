%=======================================
% Filter (lifter) aktivieren oder deaktivieren
%=======================================
preemp_filter_yes = true;
mfcc_filter_yes   = true;

%=======================================
% Audio-File einlesen
%=======================================
[speech,fs] = audioread('sp10.wav' );

%=======================================
% Pre-Emphasis Filter (Akzentuierung)
% Anhebung der hohen Frequenzen
%=======================================

alpha   = 0.9;            % 0.9 <= alpha <= 1

% Filterkoeffizienten
b       = [1 -alpha];
a       = 1;

%=======================================
% Filterung Spektrum ja/nein
%=======================================
if preemp_filter_yes 
    speech_filt = filter(b,a, speech);
else
    speech_filt = speech;
end

%=======================================
% ggf. sound abspielen
%=======================================
% sound(speech,16000)
% sound(speech_filt,16000)

%=======================================
% ggf. die beiden Stimmsignale plotten
%=======================================
figure('Color',[1 1 1]); 
plot(speech); hold on; 
plot(speech_filt,'r')


%=======================================
% Original-Spektrum plotten (nur pos Frequenzen)
%=======================================
spec = fft(speech);
f = fs/2*linspace(0,1,length(spec)/2+1);

figure('Color',[1 1 1]);
plot(f,abs(spec(1:length(f))));
title('Energiepsektrum vor Preemphase'), 
xlabel('Frequenz [Hz]');


%=======================================
% Gefiltertes-Spektrum plotten (nur pos Frequenzen)
%=======================================
    
spec = fft(speech_filt);
f = fs/2*linspace(0,1,length(spec)/2+1);

figure('Color',[1 1 1]);
plot(f,abs(spec(1:length(f)))), 
title('Energiepsektrum nach Preemphase'), 
xlabel('Frequenz [Hz]');

%=======================================
% Zeitliche Fensterung
%=======================================

% Zeitshift
frame_t_ms = 25;   
win_shift_ms = 10;      

% Shift in Samples
frame_dur_samp = (frame_t_ms/1000) * fs;
win_shift_samp = (win_shift_ms/1000) * fs;

% Fensterfunktion
win = hamming(frame_dur_samp);

%=======================================
% ggf. Fenster plotten
%=======================================
%figure('Color',[1 1 1]);
%plot(win);

%=======================================
% Sprachsignal in Fenster unterteilen
%=======================================
padding = 0;
matrix = vec2frames(speech_filt,frame_dur_samp,win_shift_samp,'cols',win,padding);

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
[H,f,c] = trifbank_V02(filter_kanaele,frame_dur_samp/2,borders,fs);

%=======================================
% Filterbank plotten
%=======================================
figure('Color',[1 1 1]); 

f = fs/2*linspace(0,1,frame_dur_samp/2);

plot(f,H,'LineWidth',2), 
title('Mel-Filterbank (20 Kanäle)'), 
xlabel('Frequenz in [Hz]'), 
ylabel('Amplitude');

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
mfcc =  DCT * log_mel_spectrum;

%=======================================
% Liftering (anhebung hohe Cep-Koeffs)
%=======================================
if mfcc_filter_yes
    lifter = ceplifter_func( anz_cep_koeffs, 22 );
    mfcc = diag( lifter ) * mfcc;
end


[ Nw, NF ] = size( matrix ); 

% Zeitachse in Frames
time_frames = [0:NF-1]*win_shift_ms*0.001+0.5*Nw/fs; 

% Zeitachse in Sekunden
time = [ 0:length(speech)-1 ]/fs;    

%=======================================
% Ergebnis plotten
%=======================================
figure('Color',[1 1 1]); 

% Zeitsignal
subplot( 311 );
plot( time, speech, 'k' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Zeit (s)' );
ylabel( 'Amplitude' );
title( 'Sprachsignal');

% Logarithmiertes Mel-Filterbank Energiespektrum
subplot( 312 );
imagesc( time_frames, [1:filter_kanaele], mel_spectrum );
axis( 'xy' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Zeit (s)' );
ylabel( 'Mel Index' );
title( 'Logarithmiertes Mel-Energiespektrum');


% Mel Frequenz Cepstrum
subplot( 313 );
imagesc( time_frames, [1:anz_cep_koeffs], mfcc(2:end,:) );
axis( 'xy' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Zeit (s)' );
ylabel( 'Cepstrum Index' );
title( 'MFCC' );


