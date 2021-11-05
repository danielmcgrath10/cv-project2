clearvars;
close all;
[rgb_images, images] = import_images(340, 512, 0, 0);

% MinQuality establishes thresholding of [ratio] multiplied by the maximum
% corner quality value (relative thresholding at [ratio] * 100 %)
harris_ratio = 0.1;
corners_1 = detectHarrisFeatures(images(:,:,1), 'MinQuality', harris_ratio);
corners_2 = detectHarrisFeatures(images(:,:,2), 'MinQuality', harris_ratio);
ncc_thresh = 0.8;
ncc_mesh = 3;

nonmax_distance = 3.0;
corners_1_nonmax = nonmax_suppression(corners_1, nonmax_distance);
corners_2_nonmax = nonmax_suppression(corners_2, nonmax_distance);

% figure;
% imshow(images(:,:,2)); hold on;
% plot(corners_2_nonmax);
% hold off;

corners1 = round(corners_1_nonmax.Location);
corners2 = round(corners_2_nonmax.Location);

ncc = zeros(length(corners1), length(corners2));
im1 = images(:,:,1);
im2 = images(:,:,2);
for i = 1:length(corners1)
    corner1 = corners1(i,:);
    for j = 1:length(corners2)
        corner2 = corners2(j,:);
%         if((a(1)-ncc_mesh < 1) || (a(2)-ncc_mesh < 1) || (a(1)+ncc_mesh > length(im1)) || (a(2)+ncc_mesh > length(im1)))
%             break
%         end
        mesh1 = im1(corner1(2)-ncc_mesh:corner1(2)+ncc_mesh,corner1(1)-ncc_mesh:corner1(1)+ncc_mesh);
%         if((b(1)-ncc_mesh < 1) || (b(2)-ncc_mesh < 1) || (b(1)+ncc_mesh > length(im2)) || (b(2)+ncc_mesh > length(im2)))
%             break
%         end
        mesh2 = im2(corner2(2)-ncc_mesh:corner2(2)+ncc_mesh,corner2(1)-ncc_mesh:corner2(1)+ncc_mesh);
        nccval = max(max(normxcorr2(mesh1,mesh2)));
        if(nccval > ncc_thresh)
            ncc(i,j) = nccval;
        end
    end
end

im1corners = [];
im2corners = [];
counter = 1;
for i = 1:size(ncc,1)
    maxval = max(ncc(i,:));
    j = 1;
    if(maxval > 0)
        while j < size(ncc,2)
            if(ncc(i,j) == maxval)
                im1corners(counter, :) = corners1(i,:);
                im2corners(counter, :) = corners2(j,:);
                counter = counter + 1;
                j = size(ncc, 2);
            else
                j = j + 1;
            end
        end
    end
end

% temp = im1corners(:,1);
% im1corners(:,1) = im1corners(:,2);
% im1corners(:,2) = temp;
% 
% temp = im2corners(:,1);
% im2corners(:,1) = im2corners(:,2);
% im2corners(:,2) = temp;
                    
correspondences = [im1corners(:,2), im1corners(:,1), im2corners(:,2), im2corners(:,1)];

ransac_tries = 1000;
ransac_distance = 10.0;

ransac_inliers = zeros(ransac_tries, 1);
ransac_H_set = zeros(3, 3, ransac_tries);
% For some arbitrary number of tries
for i = 1:ransac_tries
    % Select 4 correspondent corner pairs between images 1 and 2
    samples = randsample(size(correspondences, 1), 4);
    subset = correspondences(samples, :);
    % Compute homography H using algebraic distance on those corner pairs
    H = homography(subset);
    ransac_H_set(:,:,i) = H;
    % Apply H to first image corners and asses "inliers" on second image
    for j = 1:size(correspondences,1)
        c = correspondences(j, :);
        p = [c(1); c(2); 1];
        p_prime = sum((H .* p), 2);
        compare = c(3:4)';
        if (abs(sum(p_prime(1:2) - compare)) <= ransac_distance)
           ransac_inliers(i) = ransac_inliers(i) + 1;
        end
    end
end
        % For each point correspondence detected between images 1 and 2
            % Determine whether transformed 1 matches 2 (within error)
    % Table the number of inliers for each try
    % If number of inliers > max found so far, keep that set of inliers
% (Kept largest set of inliers)
% Recompute H using algebraic distance with all inliers (of largest set)


disp(max(ransac_inliers));

figure;
ax = axes;
showMatchedFeatures(rgb_images(:,:,:,1),rgb_images(:,:,:,2),im1corners,im2corners,'montage','Parent',ax);

figure;
colormap gray;
imshow(rgb_images(:,:,:,2)); hold on;
plot(corners_2_nonmax);
hold off;

