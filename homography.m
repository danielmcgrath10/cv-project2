function [H] = homography(correspondences)
%HOMOGRAPHY Summary of this function goes here
%   Detailed explanation goes here
N = size(correspondences, 1);
A = zeros(2 * N, 9);
for i = 1 : N
    c = correspondences(i, :);
    x1 = c(1);
    y1 = c(2);
    x1p = c(3);
    y1p = c(4);
    
    A((i * 2) - 1, :) = [x1, y1,  1,  0,  0, 0, -x1*x1p, -y1*x1p, -x1p];
    A((i * 2), :)     = [ 0,  0,  0, x1, y1, 1, -x1*y1p, -y1*y1p, -y1p];
end

[h, D] = eigs(A' * A, 1, 'smallestabs');
if abs(D) > 0.1
    disp("error!")
end

    % reshape
H = [h(1:3)' ; h(4:6)' ; h(7:9)'];
end

