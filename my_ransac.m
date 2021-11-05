function [inliers,H_set] = my_ransac(correspondences, iterations, max_distance)
%RANSAC Summary of this function goes here
%   Detailed explanation goes here

inliers = zeros(iterations, 1);
H_set = zeros(3, 3, iterations);

for i = 1:iterations
    % Select 4 correspondent corner pairs between images 1 and 2
    samples = randsample(size(correspondences, 1), 4);
    subset = correspondences(samples, :);
    % Compute homography H using algebraic distance on those corner pairs
    H = homography(subset);
    H_set(:,:,i) = H;
    % Apply H to first image corners and asses "inliers" on second image
    for j = 1:size(correspondences,1)
        c = correspondences(j, :);
        p = [c(1); c(2); 1];
        p_prime = sum((H .* p), 2);
        compare = c(3:4)';
        if (abs(sum(p_prime(1:2) - compare)) <= max_distance)
           inliers(i) = inliers(i) + 1;
        end
    end
end
        % For each point correspondence detected between images 1 and 2
            % Determine whether transformed 1 matches 2 (within error)
    % Table the number of inliers for each try
    % If number of inliers > max found so far, keep that set of inliers
% (Kept largest set of inliers)
% Recompute H using algebraic distance with all inliers (of largest set)

end

