function R = rodrigues(r)
% rodrigues:

% Input:
%   r - 3x1 vector
% Output:
%   R - 3x3 rotation matrix

if r == zeros(3,1)
    R = eye(3);
    return;
end

theta = norm(r);

u = r/theta;

I = eye(3);

u_x = [0, -u(3), u(2); u(3), 0, -u(1);-u(2),u(1),0];

R = I*cos(theta) + (1 - cos(theta))*u*u' + u_x*sin(theta);

end