function [ indexInWordList ] = FindMatchingPattern( mfcc, handles )
%FINDMATCHINGPATTERN Finds the closest word to a given sample
%   Calculates the DTW distance between the argument sample and all all words 
%   in the word list and returns the index of the word with the smallest distance

%Initialize the distance list with positive infinity to find minimums easily
%in case not every word has an associated distance yet
distanceList(1,1:length(handles.wordList)) = Inf;
i = 0;
%Iterate through every word in the wordlist
for currentWord = handles.wordList
    i = i + 1;
    path = strcat(handles.samplesFolderName, '/', char(handles.sampleMode), '/', strjoin(currentWord));
    files = dir(path);

    %Iterate through every sample for the current word and calculate DTW distance
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
    
    %Compute average distance for current word and store it in the distance list
    if(j == 1)
        continue %In case no trained samples for currentWord exist
    end
    wordDistanceAverage = totalDistance / j;
    distanceList(i) = wordDistanceAverage;
end

%Return the index of the word with the minimal distance in the word list
[dev0, indexInWordList] = min(distanceList);
end

