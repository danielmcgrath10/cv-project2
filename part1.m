
[images, n] = import_images(340, 512, 0, 0);

% MinQuality establishes thresholding of [ratio] multiplied by the maximum
% corner quality value (relative thresholding at [ratio] * 100 %)
ratio = 0.1;
corners_1 = detectHarrisFeatures(images(:,:,1), 'MinQuality', ratio);
corners_2 = detectHarrisFeatures(images(:,:,2), 'MinQuality', ratio);

ratio = 0.4;

nonmax_distance = 3.0;
corners_2_nonmax = nonmax_suppression(corners_2, nonmax_distance);

% figure;
% imshow(images(:,:,2)); hold on;
% plot(corners_2_nonmax);
% hold off; 

corners1 = round(corners_1.Location);
corners2 = round(corners_2.Location);

nnc = zeros(length(corners1));
for i = 1:length(corners1)
    a = corners1(i);
    for j = 1:length(corners2)
        b = corners2(j);
        
    end
end

figure;
colormap gray;
image(images(:,:,2), 'CDataMapping', 'direct'); hold on;
plot(corners_2_nonmax);
hold off; 


