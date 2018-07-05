function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.


%Your code here

% Pre-process the image
im = rgb2gray(im);
im = imbinarize(im);
im = imcomplement(im);
im = imdilate(im, strel('disk', 5));
im = imerode(im, strel('disk', 2));

% Save the binary image
bw = ~im;

cc = bwconncomp(im);
num_obj = cc.NumObjects;
pixel_idxs = cc.PixelIdxList;


cnt = 0;


for k=1:num_obj
    x1 = size(im,2);x2 = 0;
    y1 = size(im,1);y2 = 0;
    
    for c=1:length(pixel_idxs{k})
        [y,x] = ind2sub(size(im),pixel_idxs{k}(c));
        
        x1 = min(x1, x);x2 = max(x2, x);
        y1 = min(y1, y);y2 = max(y2, y); 
    end
    
    % If the bounding box is too small, don't add it
    if abs(x1 - x2) < 30 && abs(y1-y2) < 30
        continue
    end
    
    % Inflate the bounding box
    x1 = max(1,x1 -18);
    x2 = min(size(im,2),x2 + 18);
    y1 = max(1,y1 -18);
    y2 = min(size(im,1),y2 + 18);
    
    cnt = cnt+1;
    obj_coords(cnt, :) = [x1, y1, x2, y2];

end


n_obj = size(obj_coords,1);

lines = cell(n_obj,1);

count = 1;

% Group the object into lines 
obj_rem = n_obj;

while obj_rem > 0
    
    [y1_top,idxtop] = min(obj_coords(:,2));
    y2_top = obj_coords(idxtop,4);
    
    line_grp = [];
    line_obj_idx = [];
    for k=1:size(obj_coords,1)
        if((obj_coords(k,2) >= y1_top) && (obj_coords(k,2) <= y2_top))
            line_grp = [line_grp;obj_coords(k,:)];
            line_obj_idx = [line_obj_idx;k];
        end
    end
    
    if ~isempty(line_grp)
        lines{count} = sortrows(line_grp);
        count = count +1;
        obj_coords(line_obj_idx,:) = [];
        obj_rem = obj_rem - size(line_grp,1); 
    end
    
end

lines = lines(1:count - 1);

assert(size(lines{1},2) == 4,'each matrix entry should have size Lx4');
assert(size(lines{end},2) == 4,'each matrix entry should have size Lx4');
lineSortcheck = lines{1};
assert(issorted(lineSortcheck(:,1)) | issorted(lineSortcheck(end:-1:1,1)),'Matrix should be sorted in x1');

end