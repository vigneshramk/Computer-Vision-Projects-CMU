% Script to test BRIEF under rotations

increment = 10;
ratio = 0.8;
im_orig = im2double(rgb2gray(imread('../data/model_chickenbroth.jpg')));


[locs1, desc1] = briefLite(im_orig);

k=1;

for i=0:increment:359

rotated_img = imrotate(im_orig,i);
[locs_rot, desc_rot] = briefLite(rotated_img);

matches(k) = size(briefMatch(desc1, desc_rot, ratio),1);

k=k+1;
end

bar([0:10:359],matches);
axis([-10 359 0 1200]);
axis 'auto y'
title('Number of BRIEF features in the rotated image when compared to the original image');
xlabel('Rotation in degrees');
ylabel('Number of matched features');
