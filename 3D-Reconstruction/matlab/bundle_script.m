clear all;
close all;

load('../data/intrinsics.mat');
load('../data/some_corresp_noisy.mat');

I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

% Fix M1 as [I|0]
M1 = [eye(3), zeros(3, 1)];
C1 = K1*M1;

% Find M, the scale parameter
s_I1 = max(size(I1));
s_I2 = max(size(I2));
M = max(s_I1, s_I2);

% Find the extrinsics using RANSAC (7-pt)
[F,p1,p2] = ransacF_in( pts1, pts2, M );

E  = essentialMatrix( F, K1, K2 );

M2s = camera2(E);

for i = 1 : size(M2s, 3)
    C2s(:, :, i) = K2 * M2s(:,:,i);
end

prev_valid = 0;

for i = 1 : size(M2s, 3)
    
    C2_temp = C2s(:, :, i);
    
    % Triangulate using each of the M2s
    [P_temp, err_bef_bundle] = triangulate(C1, p1, C2_temp, p2);
    
    valid_pts = sum(P_temp(:,3) > 0);
    
    % Check for the triangulation with the maximum (if not all) the 3D points lie in 
    % front of the camera (chirality constraint)
    if valid_pts > prev_valid
        P_init = P_temp; %Initialize the bundleAdjustment with these 3D points
        C2_init = C2_temp;
        prev_valid = valid_pts;
        index = i;
    end
    
end

M2_init = M2s(:,:,index); % Initial M2 for bundleAdjustment

   
[M2, P] = bundleAdjustment(K1, M1, p1, K2, M2_init, p2, P_init);

%Finding re-projection error after bundle adjustment
C2 = K2*M2;

p_homo = [P, ones(size(P,1), 1)]';

p1_est = (C1*p_homo)';
p2_est = (C2*p_homo)';

p1_est = p1_est(:,1 : 2) ./ repmat(p1_est(:, 3), 1, 2);
p2_est = p2_est(:,1 : 2) ./ repmat(p2_est(:, 3), 1, 2);

err_bundle = sum((p1(:) - p1_est(:)).^2 + (p2(:) - p2_est(:)).^2);

scatter3(P_init(:,1),P_init(:,2),P_init(:,3));
hold on;
scatter3(P(:,1),P(:,2),P(:,3));