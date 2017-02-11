function [ indexInWordList ] = FindMatchingPattern( mfcc, handles )
%FINDMATCHINGPATTERN Summary of this function goes here
%   Detailed explanation goes here
distanceList(1,1:length(handles.wordList)) = Inf;
i = 0;
for currentWord = handles.wordList
    i = i + 1;
    path = strcat(handles.samplesFolderName, '/', char(handles.sampleMode), '/', strjoin(currentWord));
    files = dir(path);

    totalDistance = 0;
    j = 1;
    for sampleFile = files'
        if(strcmp(sampleFile.name,'.') || strcmp(sampleFile.name, '..'))
            continue;
        end
        fileId = fopen(strcat(path, '/', sampleFile.name), 'r');
        mfccSample = fread(fileId, size(mfcc), 'double');
        fclose(fileId);
        
        sampleDistance = DTWDistanceIterative(mfccSample, mfcc);
        totalDistance = totalDistance + sampleDistance;
        j = j + 1;
    end
    
    if(j == 1)
        continue %In case no trained samples for currentWord exist
    end
    wordDistanceAverage = totalDistance / j;
    distanceList(i) = wordDistanceAverage;

end

[dev0, indexInWordList] = min(distanceList);
end

