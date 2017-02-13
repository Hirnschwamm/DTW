function [] = SaveMFCCToFile( mfccCoefficients, handles, sampleMode )
%SAVEMFCCTOFILE Summary of this function goes here
%   Saves a recoreded sample to a file in the form of the mel coefficients. 
%   For each configuration (that is, liftering and preemphasis activation) and word
%   there is a folder in which that word is stored.
sampleFolderName = handles.samplesFolderName;
if exist(sampleFolderName, 'dir') == 0
    mkdir(sampleFolderName);
end

sampleModeFolderName = char(sampleMode);

selectedItemIndex = handles.wordListPopup.Value;
wordName = strjoin(handles.wordListPopup.String(selectedItemIndex));
wordPath = strcat(sampleFolderName, '/', sampleModeFolderName, '/', wordName);
if exist(wordPath, 'dir') == 0
    mkdir(wordPath);
end

directoryList = dir(wordPath);
fileCount = length(directoryList) - 2; % account for '.' and '..' files

filename = strcat(wordPath, '/', wordName, '_', int2str(fileCount));
fileId = fopen(filename, 'w');
fwrite(fileId, mfccCoefficients, 'double');
fclose(fileId);

end

