function [ distance ] = DTWDistanceRecursive( patternA, patternB)
%DTWDISTANCE Computes the DTW distance
%   Takes two patterns in forms of matrices and calculates the time warped
%   distance between them recursively
global matrix
n = size(patternA, 2);
m = size(patternB, 2);
matrix(1:n,1:m) = -1;
distance = D_n_m(patternA, patternB, n, m);
end

function [distance] = D_n_m(patternA, patternB, n, m)
global matrix
if(matrix(n, m) > 0)
    distance = matrix(n, m);
    return
end

if(n == 1 && m == 1)
    distance = abs(norm(patternA(:,n)) - patternB(:,m));
    matrix(n, m) = distance;
elseif(n == 1)
    subset = D_n_m(patternA, patternB, n, m - 1);
    distance = subset + abs(norm(patternA(:,n)) - patternB(:,m));
    matrix(n, m) = distance;
elseif(m == 1)   
    subset = D_n_m(patternA, patternB, n - 1, m);
    distance = subset + abs(norm(patternA(:,n) - patternB(:,m));
    matrix(n, m) = distance;
else
    subset1 = D_n_m(patternA, patternB, n - 1, m - 1);
    subset2 = D_n_m(patternA, patternB, n - 1, m);
    subset3 = D_n_m(patternA, patternB, n, m - 1);
    minSubset = min([subset1, subset2, subset3]);
    distance = minSubset + abs(norm(patternA(:,n)) - patternB(:,m));
    matrix(n, m) = distance;
end
end


