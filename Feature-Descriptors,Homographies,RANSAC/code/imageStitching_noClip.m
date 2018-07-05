function [panoImg] = imageStitching_noClip(img1, img2, H2to1)

% Set an arbitrary Width(W) for the output image and compute the
% corresponding Height(H) to form out_size
W = 1800; 

H1 = size(img1,1); W1 = size(img1,2);

H2 = size(img2,1); W2 = size(img2,2);

corner_img2 = [1,1,1;W2,1,1;1,H2,1;W2,H2,1];

corner_img2w = H2to1 * corner_img2';

corner_img2w = corner_img2w ./ repmat(corner_img2w(3, :), 3, 1);


bound_left = floor(min(1,min(corner_img2w(1,:))));
bound_right = floor(max(W1,max(corner_img2w(1,:))));

bound_top = floor(min(1,min(corner_img2w(2,:))));
bound_bottom = floor(max(H1,max(corner_img2w(2,:))));

W_app = (bound_right - bound_left);
H_app = (bound_bottom - bound_top);

H = ceil(W * H_app/W_app);

M = [W/W_app,0,-bound_left;0,H/H_app,-bound_top;0,0,1];

out_size = [H,W];


warp_img1 = im2double(warpH(img1,M,out_size));
warp_img2 = im2double(warpH(img2,M*H2to1,out_size));


[panoImg] = blendingfn_max(warp_img1,warp_img2);
imwrite(panoImg,'../results/q6_2_pan.jpg');

end