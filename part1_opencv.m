%%%% OPENCV IMPLEMENTATION %%%%
clearvars;
close all;

[rgb_images, images] = import_images(340, 512, 0, 0);

harris_ratio = 0.01;

rgb_image_1 = rgb_images(:,:,1);
rgb_image_2 = rgb_images(:,:,2);

image_1 = images(:,:,1);
image_2 = images(:,:,2);

corners_1 = detectHarrisFeatures(image_1, 'MinQuality', harris_ratio);
corners_2 = detectHarrisFeatures(image_2, 'MinQuality', harris_ratio);

[f1, vpts1] = extractFeatures(image_1, corners_1);
[f2, vpts2] = extractFeatures(image_2, corners_2);

indexPairs = matchFeatures(f1, f2);
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));

figure; ax=axes;
showMatchedFeatures(image_1, image_2, matchedPoints1, matchedPoints2, 'montage', 'Parent', ax);

im1corners = round(matchedPoints1.Location);
im2corners = round(matchedPoints2.Location);

correspondences = [im1corners, im2corners];

ransac_iterations = 10;
ransac_distance = 10.0;

[ransac_H, ransac_inliers] = my_ransac(correspondences, ransac_iterations, ransac_distance);
