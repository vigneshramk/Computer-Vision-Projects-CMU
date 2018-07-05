function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% INPUTS
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
%
% OUTPUTS
% bestH - homography model with the most inliers found during RANSAC

max_inliers=0;

% Default values for the parameters nIter and tol

if ~exist('nIter', 'var') || isempty(nIter)
    nIter = 1500;
end

if ~exist('tol', 'var') || isempty(tol)
    tol = 4;
end


p1 = locs1(matches(:, 1), 1:2)';
p2 = locs2(matches(:, 2), 1:2)';

for k=1:nIter
    
    % Choose 8 point pairs from all the matches and find H2to1 
    
    coords= randperm(size(matches, 1), 8);
    
    p1_random= locs1(matches(coords, 1), 1:2)';
    p2_random= locs2(matches(coords,2),1:2)';
    H2to1=computeH(p1_random,p2_random);
    
    p2_h= H2to1 * [p2; ones(1,size(p2,2))];
    p2_h = p2_h ./ repmat(p2_h(3, :), 3, 1);
    
    % Compute the number of inliers for the computed H2to1 using a Euclidean distance measure
    % thresholded by the given tolerance (tol) value
    num_inliers = nnz((sqrt(p1(1, :) - p2_h(1, :)).^2 + (p1(2, :) - p2_h(2, :)).^2) < tol);
    if num_inliers > max_inliers
        max_inliers = num_inliers;
        bestH = H2to1;
    end


end



end