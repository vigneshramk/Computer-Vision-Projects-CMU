function [dp_x,dp_y] = LucasKanadeBasis(It, It1, rect, bases)

% input - image at time t, image at t+1, rectangle (top left, bot right
% coordinates), bases 
% output - movement vector, [dp_x,dp_y] in the x- and y-directions.

tol = 0.1; dp = [0.3,0.3]'; p = [0,0]';

[temp_X, temp_Y] = meshgrid(rect(1) : rect(3), rect(2) : rect(4));

It = im2double(It);
It1 = im2double(It1);

Template = interp2(It, temp_X, temp_Y);

% Take the gradient of the image at t+1
[It1_x, It1_y] = gradient(It1);

N_bases = size(bases,3);

num_iter = 0;

while(norm(dp) >= tol) && (num_iter<=1000) 
    
    % Crop the portion of the image to be compared with the template
    [X, Y] = meshgrid((rect(1) : rect(3)) + p(1),(rect(2) : rect(4)) + p(2));
    
    Image = interp2(It1, X, Y);
    
    % Compute the error image
    Error = Template - Image;
    
    I_x = interp2(It1_x, X, Y);
    I_y = interp2(It1_y, X, Y);
    
    A = [I_x(:) I_y(:)];
    
    b = Error(:);
    
    B= reshape(bases,[size(bases,1)*size(bases,2),size(bases,3)]);
    
    % According to Equation [9] in hw3.pdf, as B is an orthobasis
    
    A = A - B*B'*A;
    
    b = b - B*B'*b;
    
    % Solve the linear system to get p
    
    ATA = A' * A;
    
    ATb = A' * b;
    
    dp = ATA \ ATb;
    
    p = p + dp;
    
    num_iter = num_iter + 1;

end

dp_x = p(1);
dp_y = p(2);



end