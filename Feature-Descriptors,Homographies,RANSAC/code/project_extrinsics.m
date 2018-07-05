function [X] = project_extrinsics(K, W, R, t)

X = [483,1704,2175,67;810,781,2217,2286]; % As given in hw2.pdf

% H is needed for finding the 3D point corresponding to the center of
% 'o' in 'Computer' text in the image.

H = computeH(X,W(1:2,:)); 

sphere =importdata('../data/sphere.txt');

img = imread('../data/prince_book.jpg');

sphere = [sphere;repmat(1,1,size(sphere,2))];

sphere(3,:) = sphere(3,:) - min(sphere(3,:));
sphere(3,:) = -sphere(3,:);

center_o=[831,1635,1]';

center_o_world = H \ center_o;

center_o_world = center_o_world ./ center_o_world(3);

% Shift the sphere to the required position (bottom of the sphere aligned with the center of 'o')

sphere(1,:) = sphere(1,:) + center_o_world(1); 
sphere(2,:) = sphere(2,:) + center_o_world(2);

X = K * [R,t] * sphere;

X= X./ repmat(X(3, :), 3, 1);

X = X(1:2,:);

imshow(img); hold on;

scatter(X(1,:),X(2,:),10,'filled','y','LineWidth',0.1)

end