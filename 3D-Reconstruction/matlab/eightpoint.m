function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup


%Scale the points using the given scaling parameter

pts1 = pts1 / M;
pts2 = pts2 / M;

x1 = pts1(:,1); y1 = pts1(:,2);
x2 = pts2(:,1); y2 = pts2(:,2);

% Formulate the A matrix from the given point correspondences
A = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(size(pts1, 1), 1)];

% f is the column of V corresponding to the smallest singular value of A
[~, ~ ,V] = svd(A);

f = V(:,end);

F = reshape(f, [3 3]);

% Enforce the singularity constraint
[U1, S1, V1] = svd(F);
S1(3, 3) = 0;
F = U1 * S1 * V1';

F = refineF(F,pts1,pts2);

% Unscale the fundamental matrix
T = diag([1/M, 1/M, 1]);

F =  T' * F * T;


end