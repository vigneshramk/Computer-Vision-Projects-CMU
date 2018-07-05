function [M2, P] = bundleAdjustment(K1, M1, p1, K2, M2_init, p2, P_init)
% bundleAdjustment:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   M2_init - 3x4 projection matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   P_init: Nx3 matrix of 3D coordinates
%
% Outputs:
%   M2 - 3x4 refined from M2_init
%   P - Nx3 refined from P_init

N= size(p1,1);

R = M2_init(1:3,1:3);
% convert into a rodrigues vector
r2 = invRodrigues(R);
t2 = M2_init(:,4);

x_init = [P_init(:);r2;t2];

fun = @(x)rodriguesResidual(K1, M1, p1, K2, p2, x);

options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','MaxFunctionEvaluations',80000, ...
'MaxIterations',1500,'FunctionTolerance', 1e-8);
[x,~] = lsqnonlin(fun, x_init,[],[],options);

P = reshape(x(1:3*N),[N,3]); %Optimized set of 3D points

r = x(3*N+1:3*N+3);
R = rodrigues(r);
t = x(3*N+4:3*N+6);

M2 = [R,t]; % Optimized extrinsics

end