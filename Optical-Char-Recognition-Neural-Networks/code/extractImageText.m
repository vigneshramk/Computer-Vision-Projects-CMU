function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.

% Read the image and extract the bounding boxes and the binary image
im = imread(fname);
[lines, bw] = findLetters(im);

load('nist36_model_321_best.mat');

% The labels of the 36 classes
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

text = '';
cnt =1;

prevx2 = 0;

for k = 1:length(lines)
    curr_line = lines{k};
    num_obj = size(curr_line, 1);
    
    for c = 1: num_obj
        
        curr_obj = curr_line(c, :);
        
        % To find where spaces have to put appended
        x1 = curr_obj(1); x2 = curr_obj(3);
        y1 = curr_obj(2); y2 = curr_obj(4);
        
        if c==1
            prevx2 = x2;
            l_size = x2 - x1;
            sum_size = l_size;
        else
            sum_size = sum_size + (x2 - x1);
            l_size = sum_size/c;
            
            if x1 - prevx2 > 0.55*l_size
                
                text = [text ' '];
              
            end
        
            prevx2 = x2;
        end
        
        % To find the letter inside each bounding box
        Y_idx = curr_obj(2):curr_obj(4);
        X_idx = curr_obj(1):curr_obj(3);
        curr_img = bw(Y_idx,X_idx);
       
        img = imresize(curr_img, [32 32]);
      
        %img = padarray(img,[4 4],255,'both');
        %img = imresize(img, [32 32]);
        
        data = reshape(img,[1,1024]);
        
        predict = Classify(W, b, data);
        
        [~, ind] = max(predict);
        
        text = [text letters(ind)];
        
    end
    
    % append a newline for each new line
    text = [text newline];
  
end

end