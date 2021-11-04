
[images, n] = import_images(340, 512, 0, 0);

% MinQuality establishes thresholding of [ratio] multiplied by the maximum
% corner quality value (relative thresholding at [ratio] * 100 %)
ratio = 0.1;
corners_1 = detectHarrisFeatures(images(:,:,1), 'MinQuality', ratio);
corners_2 = detectHarrisFeatures(images(:,:,2), 'MinQuality', ratio);
ncc_thresh = 0.7;
ncc_mesh = 1;

ratio = 0.4;

nonmax_distance = 3.0;
corners_2_nonmax = nonmax_suppression(corners_2, nonmax_distance);

% figure;
% imshow(images(:,:,2)); hold on;
% plot(corners_2_nonmax);
% hold off; 

corners1 = round(corners_1.Location);
corners2 = round(corners_2.Location);

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

ransac_tries = 10;

% For some arbitrary number of tries
    % Select 4 corner pairs between images 1 and 2
    % Compute homography H using algebraic distance on those corner pairs
    % Apply H to corner 1 and asses "inliers"
        % For each point correspondence detected between images 1 and 2
            % Determine whether transformed 1 matches 2 (within error)
    % Table the number of inliers for each try
    % If number of inliers > max found so far, keep that set of inliers
% (Kept largest set of inliers)
% Recompute H using algebraic distance with all inliers (of largest set)
        

figure;
colormap gray;
image(images(:,:,2), 'CDataMapping', 'direct'); hold on;
plot(corners_2_nonmax);
hold off; 


