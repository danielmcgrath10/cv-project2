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

ransac_iterations = 1000;
ransac_distance = 5.0;

[ransac_H, ransac_inliers] = my_ransac(correspondences, ransac_iterations, ransac_distance);

im2 = double(images(:,:,2));
[xi, yi] = meshgrid(1:512, 1:340);
h = inv(ransac_H);
xx = (h(1,1)*xi+h(1,2)*yi+h(1,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
yy = (h(2,1)*xi+h(2,2)*yi+h(2,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
foo = uint8(interp2(im2,xx,yy));
figure(1); imshow(foo)
