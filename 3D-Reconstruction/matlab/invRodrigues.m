function r = invRodrigues(R)
% invRodrigues
% Input:
%   R: 3x3 rotation matrix
% Output:
%   r: 3x1 vector

if R==eye(3)
    r = zeros(3,1); % Infinite number of solutions possible
    return;
end


A = (R - R')./2;

rho = [A(3,2),A(1,3),A(2,1)]';

s = norm(rho);

c = (trace(R) - 1)/2;

u = rho/s;

theta = atan2(s,c);

r = u*theta;
end