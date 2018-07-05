function [ F ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q5.1:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using eightpoint
%          - using ransac

%     In your writeup, describe your algorithm, how you determined which
%     points are inliers, and any other optimizations you made

F = zeros(3, 3);
n_algo = 7;

threshold = 10^-3;

num = size(pts1, 1);

max_inliers = 0;
max_inlier_idx = [];

% Calculate the number of iterations needed for RANSAC with 75 percent inliers 
percent_inliers = 75;
prob = 0.99999;

w = percent_inliers/100;

max_iter = 4*ceil(log(1-prob)/log(1 - w^n_algo));

for iter = 1 : max_iter
    
    % Use the minimal set of points (7) for each RANSAC iteration
    rand_idx = randperm(num,n_algo);
    
    %use the 7-point algorithm to find possible F's
    F_init = sevenpoint(pts1(rand_idx,:), pts2(rand_idx,:), M);
    
    for k = 1:numel(F_init)
        
        num_inliers = 0;
        inlier_idx = [];
        err_total = 0;
        err = [];
        
        X1 = [pts1, ones(num, 1)];
        X2 = [pts2, ones(num, 1)];
        % The chosen error metric
        err_pts = diag(abs( X2 * F_init{k} * X1'));
        err_total = sum(err_pts);
        
        inlier_idx = err_pts < threshold;
        num_inliers = nnz(inlier_idx);
        
        %Number of inliers has be around 75 percent of the data
        if num_inliers > max_inliers && num_inliers < 0.7*num
            max_inliers = num_inliers;
            max_inlier_idx = inlier_idx;
            F = F_init{k};
        end
    end    
end

% Refine the RANSAC F using the inliers
pts1_in = pts1(max_inlier_idx,:);
pts2_in = pts2(max_inlier_idx,:);

F = refineF(F,pts1_in,pts2_in);

end