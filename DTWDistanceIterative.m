function [ distance ] = DTWDistanceRecursive( patternA, patternB)
%DTWDISTANCE Summary of this function goes here
%   Detailed explanation goes here
global matrix
n = size(patternA, 2);
m = size(patternB, 2);
matrix = zeros(n, m);
for i = 1:n
    for j = 1:m
        if i == 1 && j == 1
            matrix(i, j) = abs(norm(patternA(:,i)) - norm(patternB(:,j)));
        elseif i == 1
            subset = matrix(i, j - 1);
            matrix(i, j) = subset + abs(norm(patternA(:,i)) - norm(patternB(:,j)));
        elseif j == 1
            subset = matrix(i - 1, j);
            matrix(i, j) = subset + abs(norm(patternA(:,i)) - norm(patternB(:,j)));
        else
            subset1 = matrix(i - 1, j - 1);
            subset2 = matrix(i - 1, j);
            subset3 = matrix(i, j - 1);
            minSubset = min([subset1, subset2, subset3]);
            newSubset = minSubset + abs(norm(patternA(:,i)) - norm(patternB(:,j)));
            matrix(i, j) = newSubset;
        end
    end
end
distance = matrix(n, m);
end


