im1=im2double(rgb2gray(imread('../data/model_chickenbroth.jpg')));
im2=im2double(rgb2gray(imread('../data/chickenbroth_01.jpg')));

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

ratio=.8;

[matches] = briefMatch(desc1, desc2, ratio);

plotMatches(im1, im2, matches, locs1, locs2);