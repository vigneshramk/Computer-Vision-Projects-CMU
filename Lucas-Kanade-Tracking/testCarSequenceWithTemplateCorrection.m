% your code here

clear all; close all;

rect_init = [60, 117, 146, 152]';

rect_lk_normal = rect_init;
rect_lk_tcorr = rect_init;

testframes = [1,100,200,300,400];
load('../data/carseq.mat');
[H,W,N] = size(frames);

rects = zeros(N,4);

first_frame = frames(:,:,1);

epsilon = 2.5;

for k = 1:N
    
    start = tic;
    pause(0.01); 
    
    current_frame = frames(:,:,k);
     
    if k ~=1
    
    previous_frame = frames(:,:,k-1); 
    
    % Normal Lucas Kanade without Template Correction    
    [dp_x,dp_y] = LucasKanade(previous_frame, current_frame, rect_lk_normal);
    rect_lk_normal = rect_lk_normal + [dp_x, dp_y, dp_x, dp_y]';
    
    % Lucas Kanade with Template Correction 
    rect_prev = rect_lk_tcorr;
    [dp_x_t,dp_y_t] = LucasKanade(previous_frame, current_frame, rect_lk_tcorr);
    rect_lk_tcorr = rect_lk_tcorr + [dp_x_t, dp_y_t, dp_x_t, dp_y_t]';
 
    p_init = [rect_lk_tcorr(1:2) - rect_init(1:2)];
    [dp_x_init,dp_y_init] = LucasKanade_compare_init(first_frame, current_frame, rect_init,p_init);
    
    dp_x_init = dp_x_init - (rect_prev(1) - rect_init(1));
    dp_y_init = dp_y_init - (rect_prev(2) - rect_init(2));
    
    % Compare the two outputs to decide which one to use
    if norm([dp_x_init,dp_y_init] - [dp_x_t,dp_y_t]) <= epsilon
        dp_x_t = dp_x_init;
        dp_y_t = dp_y_init;
    end
    
    rect_lk_tcorr = rect_prev + [dp_x_t, dp_y_t, dp_x_t, dp_y_t]';
    
    end 
    
    rects(k,:) = rect_lk_tcorr';
    
    imshow(current_frame);
    hold on;
    
    % Plot the tracker (rectangle) on the image
    width_normal = rect_lk_normal(3) - rect_lk_normal(1);
    height_normal = rect_lk_normal(4) - rect_lk_normal(2);
    rectangle('Position', [rect_lk_normal(1), rect_lk_normal(2), width_normal,height_normal], 'LineWidth', 3, 'EdgeColor', 'g');
    
    % Plot the tracker (rectangle) on the image
    width_tcorr = rect_lk_tcorr(3) - rect_lk_tcorr(1);
    height_tcorr = rect_lk_tcorr(4) - rect_lk_tcorr(2);
    rectangle('Position', [rect_lk_tcorr(1), rect_lk_tcorr(2), width_tcorr, height_tcorr], 'LineWidth', 3, 'EdgeColor', 'y');
    
    hold off;
    
    if ~isempty(find(k == testframes,1))
    
        title(sprintf('%d (%0.3f milliseconds)', k, toc(start) * 1000));
        print(char(strcat('../results/',sprintf('Q_1.4_Frame_%d.jpg',k))),'-djpeg');  
       
        
    end
    
end

save('./carseqrects-wcrt.mat','rects');