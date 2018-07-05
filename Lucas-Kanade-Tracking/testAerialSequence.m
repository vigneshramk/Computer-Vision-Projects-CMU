% your code here

clear all; close all;

testframes = [30,60,90,120];
load('../data/aerialseq.mat');
[H,W,N] = size(frames);
for k=2:N
    
    start = tic;
    
    pause(0.005);
    
    current_frame = frames(:,:,k);
    previous_frame = frames(:,:,k-1);
    
    mask = SubtractDominantMotion(previous_frame, current_frame);
    
    % Morphological operations on the mask
    
    % Perform median filtering and thresholding
    mask = medfilt2(mask);
    mask = imbinarize(mask,'global');


    % Perform morphological operations on the output mask
    se2 = strel('disk',7);
    mask = imdilate(mask, se2);
    mask = imerode(mask, se2);

    % Remove big blobs
    mask = mask - bwareaopen(mask, 370);

   
    mask = uint8(mask);
    
    % visualize the mask on the image using imfuse
    mask_img = zeros(H, W, 3);
    mask_img(:,:,1) = mask * 255;
    mask_img(:,:,2) = 0;
    mask_img(:,:,3) = mask * 255;
    fusedImg = imfuse(current_frame, mask_img, 'blend','Scaling','joint');
    
    imshow(fusedImg);
    
    if ~isempty(find(k == testframes,1))
    
        title(sprintf('%d (%0.3f milliseconds)', k, toc(start) * 1000));
        print(char(strcat('../results/',sprintf('Q3_3_Frame_%d.jpg',k))),'-djpeg');      
    end
    
end