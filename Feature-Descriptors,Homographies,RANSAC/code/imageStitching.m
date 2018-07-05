function [panoImg] = imageStitching(img1, img2, H2to1)
%
% INPUT
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear
%         equation
%
% OUTPUT
% Blends img1 and warped img2 and outputs the panorama image

save('../results/q6_1.mat','H2to1');

out_size=[600,1700];

warp_img2 = im2double(warpH(img2,H2to1,out_size));

panoImg=blendingfn_max(img1,warp_img2);

imwrite(panoImg,'../results/q6_1.jpg');

end