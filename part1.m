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

corners1 = round(corners_1_nonmax.Location);
corners2 = round(corners_2_nonmax.Location);

[im1corners, im2corners] = ncc_correspondences(images(:,:,1), images(:,:,2), corners1, corners2, ncc_mesh, ncc_thresh);
correspondences = [im1corners(:,2), im1corners(:,1), im2corners(:,2), im2corners(:,1)];

ransac_iterations = 100;
ransac_distance = 10.0;

[ransac_inliers, ransac_H_set] = my_ransac(correspondences, ransac_iterations, ransac_distance);

disp(max(ransac_inliers));

figure;
ax = axes;
showMatchedFeatures(rgb_images(:,:,:,1),rgb_images(:,:,:,2),im1corners,im2corners,'montage','Parent',ax);

figure;
colormap gray;
imshow(rgb_images(:,:,:,2)); hold on;
plot(corners_2_nonmax);
hold off;


