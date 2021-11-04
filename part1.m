
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



figure;
imshow(images(:,:,2)); hold on;
plot(corners_2);
hold off; 


