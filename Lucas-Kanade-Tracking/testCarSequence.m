% your code here

clear all; close all;

rect = [60, 117, 146, 152]';
testframes = [1,100,200,300,400];

load('../data/carseq.mat');
[H,W,N] = size(frames);

rects = zeros(N,4);

for k = 1:N
    start = tic;
    
    pause(0.005);
    
    current_frame = frames(:,:,k);
    
    
    % Track using normal Lucas-Kanade algorithm
    if k ~=1
    
    previous_frame = frames(:,:,k-1);    
    [dp_x,dp_y] = LucasKanade(previous_frame, current_frame, rect);
    rect = rect + [dp_x, dp_y, dp_x, dp_y]';
    end
    
    rects(k, :) = rect';
    
    imshow(current_frame);
    hold on;
    
    % Plot the tracker (rectangle) on the image
    width = rect(3) - rect(1);
    height = rect(4) - rect(2);
    rectangle('Position', [rect(1), rect(2), width, height], 'LineWidth', 3, 'EdgeColor', 'y');
    hold off;
    
    if ~isempty(find(k == testframes,1))
    
        title(sprintf('%d (%0.3f milliseconds)', k, toc(start) * 1000));
        print(char(strcat('../results/',sprintf('Q1.3_Frame_%d.jpg',k))),'-djpeg');  
       
        
    end
    
end

save('./carseqrects.mat','rects');