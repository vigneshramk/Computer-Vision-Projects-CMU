% Code to initialize W,X and K and to compute H from X and W (given in hw2.pdf) and then to call
% compute_extrinsics using the H and K

% Output - R and t
W = [0,18.2,18.2,0;0,0,26,26;0,0,0,0];

X = [483,1704,2175,67;810,781,2217,2286];

K = [3043.72,0,1196.00;0,3043.72,1604.00;0,0,1.0];

H = computeH(X,W(1:2,:));

[R,t] = compute_extrinsics(K, H);
