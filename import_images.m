function [images, numImages] = import_images(x, y, start, stop)
%IMPORT_IMAGES Summary of this function goes here
%   Detailed explanation goes here


    directory = uigetdir(pwd, 'Select a Folder');
    filePattern = fullfile(directory, '*.jpg');
    imageFiles = dir(filePattern);
    numImages = length(imageFiles);
    images = zeros(x, y, numImages);
    
    if start == 0
       start = 1; 
    end
    if stop == 0
       stop = numImages; 
    end
    
    for i = start:stop
        file = imageFiles(i);
        images(:,:,i) = rgb2gray(imread(strcat(file.folder,'/',file.name)));
    end
end

