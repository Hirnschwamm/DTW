function [ audioData ] = RecordAudioData( handles)
%RECORDAUDIODATA Records audio data

handles.recordingAlertRdoBtn.Value = 1;
recorder = audiorecorder(handles.bitrate, handles.samplerate, handles.channel);
recordblocking(recorder, handles.recordDuration);
handles.recordingAlertRdoBtn.Value = 0;
audioDataRaw = getaudiodata(recorder);
audioData = audioDataRaw(50:end); %prevent noisy impulses at the start of the recording due to hardware problems

end

