function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1 
% output - M affine transformation matrix

tol = 0.1; p = zeros(6,1); dp = ones(6,1);

% Convert uint8 into double
It = im2double(It);
It1 = im2double(It1);

[H,W] = size(It);

[X, Y] = meshgrid(1 : W, 1 : H);

Xv= X(:)'; Yv= Y(:)';

[It1_x, It1_y] = gradient(It1);

% Convert into homogeneous coordinates
Tcoord_homo = [Xv; Yv; ones(size(Yv))];

num_iter=0;

while(norm(dp) >= tol) && (num_iter<=100)
    
    M = [1 + p(1),p(3),p(5); p(2),1 + p(4), p(6);0,0,1];
     
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
    
    % Compute the warped gradients
    It_x = interp2(X, Y, It1_x, q_x, q_y);
    It_y = interp2(X, Y, It1_y, q_x,q_y);
    
    % Make the undefined elements into zeros
    It_x(isnan(It_x)) = 0;
    It_y(isnan(It_y)) = 0;
    
    % Steepest descent images
    A = [It_x(:) .* X(:), It_y(:) .* X(:), It_x(:) .* Y(:),It_y(:) .* Y(:), It_x(:), It_y(:)];
    
    % Compute the error image
    Error = It - Warped_Img;
    

    % Solve the linear system to get p
    
    H = A' * A;
    
    b = A'* Error(:);
    
    dp = H \ b;
    
    p = p + dp;
    
    num_iter = num_iter + 1;

end

end

