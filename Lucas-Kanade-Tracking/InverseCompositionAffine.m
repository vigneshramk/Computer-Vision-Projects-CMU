function M = InverseCompositionAffine(It, It1)

% input - image at time t, image at t+1
% output - M affine transformation matrix

tol = 0.1; p = zeros(6,1); dp = ones(6,1);

% Convert uint8 into double
It = im2double(It);
It1 = im2double(It1);

[H,W] = size(It);

[X, Y] = meshgrid(1 : W, 1 : H);

Xv= X(:)';
Yv= Y(:)';

% Take the gradient of the template 
[It_x, It_y] = gradient(It);

% Precompute the steepest descent images
A = [It_x(:) .* X(:), It_y(:) .* X(:), It_x(:) .* Y(:),It_y(:) .* Y(:), It_x(:), It_y(:)];

% Convert into homogeneous coordinates
Tcoord_homo = [Xv; Yv; ones(size(Yv))];

iteration=0;

while(norm(dp) >= tol) && (iteration <= 100)
        
    M = [1 + p(1),p(3),p(5); p(2),1 + p(4), p(6);0,0,1];
    
    P_mat = M(1:2,:);
         
    % Perform Warp
    W_xp = M * Tcoord_homo;
    
    % Query points for the interp2 function
    q_x = W_xp(1, :)';
    q_y = W_xp(2, :)';
    
    % Perform interpolation and reshape the warped image
    Warped_Img = interp2(X, Y, It1,q_x,q_y);
    Warped_Img = reshape(Warped_Img, size(It1));
    
    % Make the undefined elements into zeros
    Warped_Img(isnan(Warped_Img)) = 0;
    
    % Compute the error image
    Error = Warped_Img - It;
    
    % Solve the linear system to get p
    
    H = A' * A;
    
    b = A'* Error(:);
    
    dp = H \ b;
    
    dp_mat = [1+dp(1),dp(3),dp(5);dp(2),1+dp(4),dp(6);0,0,1];
    
    % perform inverse composition on p with dp
    P_mat = P_mat / dp_mat;
    
    % Reassign p's
    p(1) = P_mat(1,1) - 1; p(3) = P_mat(1,2); p(5) = P_mat(1,3);
    p(2) = P_mat(2,1); p(4)= P_mat(2,2) - 1; p(6)= P_mat(2,3);
    
    iteration = iteration + 1;

end

end
