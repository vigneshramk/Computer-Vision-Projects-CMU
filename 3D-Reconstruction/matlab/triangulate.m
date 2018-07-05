function [ P, err ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error

% Q3.2:
%       Implement a triangulation algorithm to compute the 3d locations
%

N = size(p1,1);

P = zeros(N,3);

x1 = p1(:,1); y1 = p1(:,2); 
x2 = p2(:,1); y2 = p2(:,2);

for k = 1:N
    
    A = [x1(k)* C1(3,:) - C1(1,:)
         y1(k)* C1(3,:) - C1(2,:)
         x2(k)* C2(3,:) - C2(1,:)
         y2(k)* C2(3,:) - C2(2,:)];
    
    [~,~,V] = svd(A);
    
    P(k, :) = V(1 : 3, end)' / V(4, end);
    
end

% Calculate the reprojection error
p_homo = [P, ones(N, 1)]';

p1_est = (C1*p_homo)';
p2_est = (C2*p_homo)';

p1_est = p1_est(:,1 : 2) ./ repmat(p1_est(:, 3), 1, 2);
p2_est = p2_est(:,1 : 2) ./ repmat(p2_est(:, 3), 1, 2);

err = sum((p1(:) - p1_est(:)).^2 + (p2(:) - p2_est(:)).^2);


end
