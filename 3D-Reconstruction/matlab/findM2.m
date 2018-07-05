% Q3.3:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q3_3.mat

clear all; close all;

% Load the input images
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

P = [];
M2 = [];

% Fix M1 as [I|0]
M1 = [eye(3), zeros(3, 1)];


% Find M, the scale parameter
s_I1 = max(size(I1));
s_I2 = max(size(I2));
M = max(s_I1, s_I2);

% Load the intrinsics and the point correspondences
load('../data/intrinsics.mat');
load('../data/some_corresp.mat');

% Compute the fundamental matrix using eight-point algorithm
F = eightpoint( pts1, pts2, M );

% Compute the essential matrix using the given intrinsics of the camera
E  = essentialMatrix( F, K1, K2 );

% Find the possible M2s using the given function
M2s = camera2(E);

% final camera matrix is the product of the intrinsics and the canonical
% camera matrix
C1 = K1*M1;

for i = 1 : size(M2s, 3)
    C2s(:, :, i) = K2 * M2s(:,:,i);
end

prev_valid = 0;

for i = 1 : size(M2s, 3)
    
    C2_temp = C2s(:, :, i);
    
    % Triangulate using each of the M2s
    [P_temp, err] = triangulate(C1, pts1, C2_temp, pts2);
    
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