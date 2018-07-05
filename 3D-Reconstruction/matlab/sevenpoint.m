function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - 7x2 matrix of (x,y) coordinates
%   pts2 - 7x2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup


%Scale the points using the given scaling parameter
pts1 = pts1 / M;
pts2 = pts2 / M;

x1 = pts1(:,1); y1 = pts1(:,2);
x2 = pts2(:,1); y2 = pts2(:,2);

% Formulate the A matrix from the given point correspondences
A = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(size(pts1, 1), 1)];

% f is the column of V corresponding to the smallest singular value of A
[~, ~ ,V] = svd(A);

F1 = reshape(V(:, end), [3, 3]);
F2 = reshape(V(:, end-1), [3, 3]);

syms lambda_var

eqn = (det(F1 + lambda_var*F2) == 0);
lambda = solve(eqn,lambda_var);

lambda = double(lambda);

% Find the real lambda's
index = abs(imag(lambda)) < eps;
lambda = real(lambda(index));

F = cell(1, length(lambda));
T = diag([1/M, 1/M, 1]);

for k = 1:length(lambda)
    
    F{k} = F1 + lambda(k)*F2;
   
    % Refine and Unscale the fundamental matrix
    F{k} = refineF(F{k}, pts1, pts2);
    F{k} = T' * F{k} * T;
end

end