% your code here

clear all; close all;

rect = [102, 62, 156, 108]';

rect_lk = rect;
rect_lk_ab= rect;

testframes = [1,200,300,350,400];

load('../data/sylvseq.mat');
[H,W,N] = size(frames);

rects = zeros(N,4);

load('../data/sylvbases.mat');

N_bases = size(bases,3);

for k = 1:N
    
    start = tic;
    
    pause(0.0001);
    
    current_frame = frames(:,:,k);
    
    if k ~=1
    
    previous_frame = frames(:,:,k-1);    
    
    % Tracking using the normal Lucas-Kanade Algorithm
    if ~isnan(rect_lk)
    [dp_x,dp_y] = LucasKanade(previous_frame, current_frame, rect_lk);
    rect_lk = rect_lk + [dp_x, dp_y, dp_x, dp_y]';
    else  % If the Lucas Kanade tracker is empty, reinitialize with the Appearance Basis tracker 
        % To ensure that the program won't crash if normal Lucas-Kanade
        % fails (it doesn't for the given test file.)
    [dp_x,dp_y] = LucasKanade(previous_frame, current_frame, rect_lk_ab);
    rect_lk = rect_lk_ab + [dp_x, dp_y, dp_x, dp_y]';
    end
    
    % Tracking using the Lucas-Kanade Algorithm with Appearance Basis 
    [dp_x_ab,dp_y_ab] = LucasKanadeBasis(previous_frame, current_frame, rect_lk_ab, bases);
    rect_lk_ab = rect_lk_ab + [dp_x_ab, dp_y_ab, dp_x_ab, dp_y_ab]';
    
    end
   
    rects(k, :) = rect_lk_ab';
   
    imshow(current_frame);
    hold on;
    
    % Plot the tracker (rectangle) of normal LK on the image if the tracker exists 
    if ~isnan(rect_lk)
    
    width = rect_lk(3) - rect_lk(1);
    height =rect_lk(4) - rect_lk(2);
    rectangle('Position', [rect_lk(1), rect_lk(2), width, height], 'LineWidth', 3, 'EdgeColor', 'g');
    
    end
    
    % Plot the tracker (rectangle) of Appearance Basis algorithm on the image
    width = rect_lk_ab(3) - rect_lk_ab(1);
    height =rect_lk_ab(4) - rect_lk_ab(2);
    rectangle('Position', [rect_lk_ab(1), rect_lk_ab(2), width, height], 'LineWidth', 3, 'EdgeColor', 'y');
    
    
    hold off;
    
    
    if ~isempty(find(k == testframes,1))
    
        title(sprintf('%d (%0.3f milliseconds)', k, toc(start) * 1000));
        print(char(strcat('../results/',sprintf('Q2_3_Frame_%d.jpg',k))),'-djpeg');   
    end
 
   
end

save('./sylvseqrects.mat','rects');
