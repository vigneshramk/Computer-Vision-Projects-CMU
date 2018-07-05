function [img3] = generatePanorama(img1,img2)

nIter = 1500;
tol = 3;

img1 = im2double(img1);
img2 = im2double(img2);

if size(img1,3)==3
    img1_gray= rgb2gray(img1);
else
    img1_gray = img1;
end

if size(img2,3)==3
    img2_gray= rgb2gray(img2);
else
    img2_gray = img2;
end


[locs1, desc1] = briefLite(img1_gray);
[locs2, desc2] = briefLite(img2_gray);

[matches] = briefMatch(desc1, desc2, 0.8);

[H2to1] = ransacH(matches, locs1, locs2, nIter, tol);

img3 = imageStitching_noClip(img1, img2, H2to1);

imwrite(img3,'../results/q6_3.jpg');

end