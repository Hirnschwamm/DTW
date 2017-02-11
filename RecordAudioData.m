function [ audioData ] = RecordAudioData( handles)
%RECORDAUDIODATA Summary of this function goes here
%   Detailed explanation goes here
handles.recordingAlertRdoBtn.Value = 1;
recorder = audiorecorder(handles.bitrate, handles.samplerate, handles.channel);
recordblocking(recorder, handles.recordDuration);
handles.recordingAlertRdoBtn.Value = 0;
audioDataRaw = getaudiodata(recorder);
audioData = audioDataRaw(50:end); %prevent noisy impulses at the start of the recording

end

