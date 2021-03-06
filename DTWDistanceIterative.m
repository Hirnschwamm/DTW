function [ distance ] = DTWDistanceIterative( patternA, patternB)
%DTWDISTANCE Computes the DTW distance
%   Takes two patterns in forms of matrices and calculates the time warped
%   distance between them iteratively
n = size(patternA, 2);
m = size(patternB, 2);
matrix = zeros(n, m);
for i = 1:n
    currentColA = patternA(:,i);
    for j = 1:m
        currentColB = patternB(:,j);
        difference = norm(currentColA - currentColB);
        if i == 1 && j == 1
            matrix(i, j) = abs(norm(difference));
        elseif i == 1
            subset = matrix(i, j - 1);
            matrix(i, j) = subset + abs(norm(difference));
        elseif j == 1
            subset = matrix(i - 1, j);
            matrix(i, j) = subset + abs(norm(difference));
        else
            subset1 = matrix(i - 1, j - 1);
            subset2 = matrix(i - 1, j);
            subset3 = matrix(i, j - 1);
            minSubset = min([subset1, subset2, subset3]);      
            newSubset = minSubset + abs(norm(difference));
            matrix(i, j) = newSubset;
        end
    end
end
distance = matrix(n, m);
end



