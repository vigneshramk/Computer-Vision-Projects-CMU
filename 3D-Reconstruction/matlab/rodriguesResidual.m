function residuals = rodriguesResidual(K1, M1, p1, K2, p2, x)
% rodriguesResidual:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   x - (3N + 6)x1 flattened concatenation of P, r_2 and t_2

% Output:
%   residuals - 4Nx1 vector

N = size(p1,1);

P = reshape(x(1:3*N),[N,3]);

r = x(3*N+1:3*N+3);
R = rodrigues(r);
t = x(3*N+4:3*N+6);

M2 = [R,t];

C1 = K1*M1;
C2 = K2*M2;

p_homo = [P, ones(N, 1)]';

p1_hat = (C1*p_homo)';
p2_hat = (C2*p_homo)';

p1_hat = p1_hat(:,1 : 2) ./ repmat(p1_hat(:, 3), 1, 2);
p2_hat = p2_hat(:,1 : 2) ./ repmat(p2_hat(:, 3), 1, 2);

residuals = reshape([p1 - p1_hat; p2 - p2_hat], [], 1);

end