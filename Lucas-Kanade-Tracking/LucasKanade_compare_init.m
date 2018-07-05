function [dp_x,dp_y] = LucasKanade_compare_init(It, It1, rect,p_init)

tol = 0.1;

dp = [0.3,0.3]';

% Initialize p as the argument passed into the function
p = p_init;

[temp_X, temp_Y] = meshgrid(rect(1) : rect(3), rect(2) : rect(4));

% Convert uint8 into double
It = im2double(It);
It1 = im2double(It1);

Template = interp2(It, temp_X, temp_Y);


% Take the gradient of the image at t+1 (Current-image)
[It1_x, It1_y] = gradient(It1);

num_iter = 0;

while(norm(dp) >= tol) && (num_iter<=1000) 
    
    % Crop the portion of the image to be compared with the template
    [X, Y] = meshgrid((rect(1) : rect(3)) + p(1),(rect(2) : rect(4)) + p(2));
    Image = interp2(It1, X, Y);
    
    Error = Template - Image;
    
    I_x = interp2(It1_x, X, Y);
    I_y = interp2(It1_y, X, Y);
    
    A = [I_x(:) I_y(:)];
    
    % Solve the linear system to get p
    
    ATA = A' * A;
    
    b = Error(:);
    
    ATb = A' * b;
    
    dp = ATA \ ATb;
    
    p = p + dp;
    
    num_iter = num_iter + 1;

end

dp_x = p(1);
dp_y = p(2);


end