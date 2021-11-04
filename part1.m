
[images, n] = import_images(340, 512, 0, 0);

% MinQuality establishes thresholding of [ratio] multiplied by the maximum
% corner quality value (relative thresholding at [ratio] * 100 %)
ratio = 0.1;
corners_1 = detectHarrisFeatures(images(:,:,1), 'MinQuality', ratio);
corners_2 = detectHarrisFeatures(images(:,:,2), 'MinQuality', ratio);
ncc_thresh = 0.5;
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
    a = corners1(i,:);
    for j = 1:length(corners2)
        b = corners2(j,:);
%         if((a(1)-ncc_mesh < 1) || (a(2)-ncc_mesh < 1) || (a(1)+ncc_mesh > length(im1)) || (a(2)+ncc_mesh > length(im1)))
%             break
%         end
        n1 = im1(a(2)-ncc_mesh:a(2)+ncc_mesh,a(1)-ncc_mesh:a(1)+ncc_mesh);
%         if((b(1)-ncc_mesh < 1) || (b(2)-ncc_mesh < 1) || (b(1)+ncc_mesh > length(im2)) || (b(2)+ncc_mesh > length(im2)))
%             break
%         end
        n2 = im2(b(2)-ncc_mesh:b(2)+ncc_mesh,b(1)-ncc_mesh:b(1)+ncc_mesh);
        norm = max(max(normxcorr2(n1,n2)));
        if(norm > ncc_thresh)
            ncc(i,j) = norm;
        end
    end
end

figure;
colormap gray;
image(images(:,:,2), 'CDataMapping', 'direct'); hold on;
plot(corners_2_nonmax);
hold off; 


