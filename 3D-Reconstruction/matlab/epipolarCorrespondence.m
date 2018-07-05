function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q4.1:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q4_1.mat
%
%           Explain your methods and optimization in your writeup

im1 = double(im1);
im2 = double(im2);

[H,W] = size(im2);

window_size = 9;
R = (window_size - 1) / 2;
sigma = 2; 
threshold = 45;

p1_homo = [x1, y1, 1]';

epi_line = F * p1_homo;

epi_line = epi_line/norm(epi_line);

weights = fspecial('gaussian', [window_size,window_size], sigma);

patch_img1 = im1((y1 - R): (y1 + R), (x1 -R): (x1 + R));

a = epi_line(1); b = epi_line(2); c = epi_line(3);

line_y1 = 1:H;
line_x1 = ceil(-(b * line_y1 + c) / a);

line_x2 = 1:W;
line_y2 = ceil(-(a * line_x2 + c) / b);


n_pts1 = nnz((line_x1 - R > 0) & (line_x1 + R <= W) ...
              & (line_y1 - R > 0) & (line_y1 + R <= H));

n_pts2 = nnz((line_x2 - R > 0) & (line_x2 + R <= W) ...
              & (line_y2 - R > 0) & (line_y2 + R <= H));
          
if(n_pts1 > n_pts2)
    line_x = line_x1;
    line_y = line_y1;
    n_pts = n_pts1;
else 
    line_x = line_x2;
    line_y = line_y2;
    n_pts = n_pts2;
end

max_err = inf;
match_idx = 0;

for k = 1: n_pts
    
    if ((line_x(k) - x1)^2 + (line_y(k)- y1)^2) <= threshold^2
    
        patch_img2 = im2((line_y(k) - R): (line_y(k) + R), (line_x(k) -R): (line_x(k) + R));
        diff = (patch_img2 - patch_img1).^2;
        err =  sum(diff .* weights);
        err = sum(err(:));
        
    if err < max_err
        max_err = err;
        match_idx = k;
    end
        
    end
end

x2 = line_x(match_idx);
y2 = line_y(match_idx);

end
