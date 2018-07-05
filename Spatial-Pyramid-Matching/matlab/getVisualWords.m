function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)
if (size(img,3)==3)
[filterResponse] = extractFilterResponses(img, filterBank);

M=size(filterResponse,1);
N=size(filterResponse,2);

filterResponse = reshape(filterResponse,[size(filterResponse,1)*size(filterResponse,2),size(filterResponse,3)]);

[~,wordMap] = min(pdist2(dictionary,filterResponse,'euclidean'));

wordMap=reshape(wordMap, [M,N]);
end

end
