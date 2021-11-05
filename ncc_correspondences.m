function [im1corners, im2corners] = ncc_correspondences(image1, image2, corners1, corners2, ncc_mesh, ncc_thresh)
%NCC_CORRESPONDENCES Summary of this function goes here
%   Detailed explanation goes here
ncc = zeros(length(corners1), length(corners2));

for i = 1:length(corners1)
    corner1 = corners1(i,:);
    for j = 1:length(corners2)
        corner2 = corners2(j,:);
%         if((a(1)-ncc_mesh < 1) || (a(2)-ncc_mesh < 1) || (a(1)+ncc_mesh > length(im1)) || (a(2)+ncc_mesh > length(im1)))
%             break
%         end
        mesh1 = image1(corner1(2)-ncc_mesh:corner1(2)+ncc_mesh,corner1(1)-ncc_mesh:corner1(1)+ncc_mesh);
%         if((b(1)-ncc_mesh < 1) || (b(2)-ncc_mesh < 1) || (b(1)+ncc_mesh > length(im2)) || (b(2)+ncc_mesh > length(im2)))
%             break
%         end
        mesh2 = image2(corner2(2)-ncc_mesh:corner2(2)+ncc_mesh,corner2(1)-ncc_mesh:corner2(1)+ncc_mesh);
        nccval = max(max(normxcorr2(mesh1,mesh2)));
        if(nccval > ncc_thresh)
            ncc(i,j) = nccval;
        end
    end
end

im1corners = [];
im2corners = [];
counter = 1;
for i = 1:size(ncc,1)
    maxval = max(ncc(i,:));
    j = 1;
    if(maxval > 0)
        while j < size(ncc,2)
            if(ncc(i,j) == maxval)
                im1corners(counter, :) = corners1(i,:);
                im2corners(counter, :) = corners2(j,:);
                counter = counter + 1;
                j = size(ncc, 2);
            else
                j = j + 1;
            end
        end
    end
end
% correspondences = [im1corners(:,2), im1corners(:,1), im2corners(:,2), im2corners(:,1)];
end

