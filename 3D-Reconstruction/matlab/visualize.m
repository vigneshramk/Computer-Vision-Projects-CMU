% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

clear all; close all;

load('../data/templeCoords.mat');
load('../data/some_corresp.mat');
load('../data/intrinsics.mat');


im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

% Find M, the scale parameter
s_I1 = max(size(im1));
s_I2 = max(size(im2));
M = max(s_I1, s_I2);

F = eightpoint( pts1, pts2, M );

for k = 1: size(x1,1)

[x2(k), y2(k)] = epipolarCorrespondence(im1, im2, F, x1(k), y1(k));
end
x2 = x2';
y2 = y2';
% Fix M1 as [I|0]
M1 = [eye(3), zeros(3, 1)];

% final camera matrix is the product of the intrinsics and the canonical
% camera matrix
C1 = K1*M1;

p1 = [x1,y1];
p2 = [x2,y2];

% Compute the essential matrix using the given intrinsics of the camera
E  = essentialMatrix( F, K1, K2 );

% Find the possible M2s using the given function
M2s = camera2(E);

for i = 1 : size(M2s, 3)
    C2s(:, :, i) = K2 * M2s(:,:,i);
end

prev_valid = 0;

for i = 1 : size(M2s, 3)
    
    C2_temp = C2s(:, :, i);
    
    % Triangulate using each of the M2s
    [P_temp, err] = triangulate(C1, p1, C2_temp, p2);
    
    valid_pts = sum(P_temp(:,3) > 0);
    
    % Check for the triangulation with the maximum (if not all) the 3D points lie in 
    % front of the camera (chirality constraint)
    if valid_pts > prev_valid
        P = P_temp;
        C2 = C2_temp;
        prev_valid = valid_pts;
        index = i;
    end
    
end

M2 = M2s(:,:,index);

% Visualize the 3D plot
scatter3(P(:,1),P(:,2),P(:,3));