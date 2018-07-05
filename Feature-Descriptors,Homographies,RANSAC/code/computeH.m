function H2to1 = computeH(p1,p2)
% INPUTS:
% p1 and p2 - Each are size (2 x N) matrices of corresponding (x, y)'  
%             coordinates between two images
%
% OUTPUTS:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear 
%         equation

N=size(p1,2);

% Convert p1 and p2 to homogeneous coordinates, to get a Nx3 matrix for each of them. 

p1 = [p1(1, :)', p1(2, :)', ones(N, 1)]; 
p2 = [p2(1, :)', p2(2, :)', ones(N, 1)];


A=[ -p2, zeros(N,3), p2.*repmat(p1(:,1),1,3); zeros(N,3), -p2, p2.*repmat(p1(:,2),1,3)];


[U,S,V]=svd(A);

H2to1 = reshape(V(:, 9), 3, 3)'; % The elements of the last column of the matrix V correspond to H2to1

H2to1=real(H2to1/(det(H2to1)^(1/3))); % Normalize the H matrix to have a determinant 1

end