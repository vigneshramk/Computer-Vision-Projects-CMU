function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here

[H, W] = size(wordMap);

h = zeros(dictionarySize*(4^(layerNum)-1)/3, 1);

L=layerNum-1;

H_small=floor(H/2^L); 
W_small=floor(W/2^L);

%record the current size of h
current_size = 0;
up_index = 0;

% Given that we'll be using a 3-layer spatial pyramid - split the image
% into 16 and compute the histograms of the finest layer

for i=1:2^L
  for j=1:2^L
      cell = wordMap(1+(i-1)*H_small:i*H_small, 1+(j-1)*W_small:j*W_small);
      cellnum = (i-1)*(2^L) + j;
      current_size = cellnum*dictionarySize;
      h(1+(cellnum-1)*dictionarySize: current_size, 1) = getImageFeatures(cell, dictionarySize) ./32;
  end
end

% Histogram of Layer 1 and Layer 0


for i = 1:L
    
    layernumber = L - i;   
    layersize = 2 ^ layernumber;
    
    if layernumber==0
        weight=1;
    end
    if layernumber==1
        weight=0.5;
    end
    
    for j = 1:layersize
        for k = 1:layersize
            
            first_index = dictionarySize*(4*(j-1)*layersize + 2*(k-1)) + up_index;
            second_index = first_index + 1*dictionarySize;
            third_index = first_index + 2*layersize*dictionarySize;
            fourth_index = third_index + 1*dictionarySize;
            
            h(1+current_size:dictionarySize+current_size) = (h(1+first_index:first_index+dictionarySize) + h(1+second_index:second_index+dictionarySize) + h(1+third_index:third_index+dictionarySize) + h(1+fourth_index:fourth_index+dictionarySize)) .* weight;
            current_size = current_size + dictionarySize;
            
        end
    end
    
    up_index = up_index + dictionarySize * (2 ^ (layernumber+1))^2;
end

end