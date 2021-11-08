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

ransac_iterations = 1000;
ransac_distance = 5.0;

[ransac_H, ransac_inliers] = my_ransac(correspondences, ransac_iterations, ransac_distance);

disp(max(ransac_inliers));

figure;
ax = axes;
showMatchedFeatures(rgb_images(:,:,:,1),rgb_images(:,:,:,2),im1corners,im2corners,'montage','Parent',ax);

figure;
colormap gray;
imshow(rgb_images(:,:,:,2)); hold on;
plot(corners_2_nonmax);
hold off;

h = inv(ransac_H);
im1 = images(:,:,1);
im = double(images(:,:,2));
[xi,yi] = meshgrid(1:size(im, 2), 1:size(im, 1));
xx = (h(1,1) * xi + h(1,2) * yi + h(1,3))./(h(3,1) * xi + h(3,2) * yi + h(3,3));
yy = (h(2,1) * xi + h(2,2) * yi + h(2,3))./(h(3,1) * xi + h(3,2) * yi + h(3,3));
foo = uint8(interp2(im, xx, yy));
figure;
% montage({im1, foo});
imshow(foo);

% im1 = images(:,:,1);
% im2 = images(:,:,2);
% 
% im1 = padarray(im1, [0 size(im2, 2)], 0, 'post');
% im1 = padarray(im1, [size(im2, 1) 0], 0, 'both');
% 
% for i = 1:size(im1, 2)
%    for j = 1:size(im1, 1)
%       p2 = ransac_H * [i; j-floor(size(im2, 1)); 1];
%       p2 = p2 ./ p2(3);
%       
%       x2 = floor(p2(1));
%       y2 = floor(p2(2));
%       
%       if x2 > 0 && x2 <= size(im2, 2) && y2 > 0 && y2 <= size(im2, 1)
%         im1(j, i) = im2(y2, x2);
%       end
%    end
% end
% 
% [row, col] = find(im1);
% c = max(col(:));
% d = max(row(:));
% 
% st = imcrop(im1, [1 1 c d]);
% 
% [row, col] = find(im1 ~= 0);
% a = min(col(:));
% b = min(row(:));
% meshedimage = imcrop(st, [a b size(st, 1) size(st, 2)]);
% 
% figure;
% imshow(meshedimage);


 


