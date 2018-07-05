function [filterResponses] = extractFilterResponses(img, filterBank)

% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses
filterResponses = zeros([size(img) 20]);

img_lab=RGB2Lab(img); % Convert the given image into Lab space 

for i=1:20 % Loop over all the filters  
    filter = cell2mat(filterBank(i)); % Convert filter into a matrix to apply the filtering
    filterResponses(:,:,:,i)=imfilter(img_lab,filter,'conv'); % Get the filter responses in W x H x 3 x N 
    
end

% Create Montage for the given image

montage(filterResponses,'Size',[4 5]);

filterResponses=filterResponses(:,:,:); % Make the responses into W x H x 3*N form

end
