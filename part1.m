
directory = uigetdir(pwd, 'Select a Folder');
filePattern = fullfile(directory, '*.jpg');
imageFiles = dir(filePattern);
numImages = length(imageFiles);
    
start = 1;
stop = 2; 
k_val = 0.04;
    
for i = start:stop
  file = imageFiles(i);
  images(:,:,i) = rgb2gray(imread(strcat(file.folder,'/',file.name)));
end

corners_1 = detectHarrisFeatures(images(:,:,1));
corners_2 = detectHarrisFeatures(images(:,:,2));

% imshow(images(:,:,1)); hold on;
% plot(corners_1.selectStrongest(50));
% hold off;

% This has the effect of selecting the [ratio]th strongest corner and
% making that strength value the threshold.
corners_2_th = corners_2.selectStrongest(round(corners_2.length * 0.4));

corners_2_nonmax = nonmax_suppression(corners_2_th, 1.0);

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



