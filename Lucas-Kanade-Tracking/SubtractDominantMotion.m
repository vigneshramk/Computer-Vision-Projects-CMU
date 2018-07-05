function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size - imref2d

% Convert uint8 into double
image1 = im2double(image1);
image2 = im2double(image2);

[H,W] = size(image2);
mask = zeros(H,W);

% Find the transformation matrix M and perform warp
M = LucasKanadeAffine(image1, image2);

img1_warp = warpH(image1, M, [H,W],NaN);

mask = zeros(size(image2)); 

% Find the common regions of the warped image vs image2
for x =1:W
    for y = 1:H
        if ~isnan(img1_warp(y, x))
            mask(y,x) = image2(y,x) - img1_warp(y,x);
        end 
    end
end 

mask = abs(mask);

end