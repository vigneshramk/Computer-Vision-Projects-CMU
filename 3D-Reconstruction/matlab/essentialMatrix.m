function [ E ] = essentialMatrix( F, K1, K2 )
% essentialMatrix:
%    F - 3x3 Fundamental Matrix
%    K1 - 3x3 Camera Matrix 1
%    K2 - 3x3 Camera Matrix 2

% Q3.1:
%       Compute the 3x3 essential matrix 
%
%       Write the computed essential matrix in your writeup

E = K2'* F*K1;


end

