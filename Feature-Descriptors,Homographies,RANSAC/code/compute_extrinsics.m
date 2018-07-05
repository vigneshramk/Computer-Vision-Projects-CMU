function [R,t] = compute_extrinsics(K, H)

% Note that the value of H is found using the code given in main_qn7.m.
% main_qn7.m also calls this function to output R and t 

H1 = inv(K) * H;

R1 = H1(:,1:2);

[U,S,V] = svd(R1);

S1=[1,0;0,1;0,0];

R = U*S1*V';

R(:,3) = cross(R(:,1),R(:,2));

lambda = sum(sum(H1(:,1:2)./R(:,1:2)))/6;

if det(R) == -1
R(:,3) = -R(:,3);
end

t = H1(:,3) ./ lambda;

end