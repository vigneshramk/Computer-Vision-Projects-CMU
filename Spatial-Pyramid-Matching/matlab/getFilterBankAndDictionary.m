function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)

% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();
    filter_responses = [];
    
    for i=1:length(imPaths)
        
        img=imread(char(imPaths(i)));
        if (size(img,3)==3)
            
        filterResponses = extractFilterResponses(img,filterBank);
        n=size(filterResponses,1)*size(filterResponses,2);
        alpha=randperm(n,300);
        
        alpha_3F_response=[];
        for i=1:size(filterResponses,3)
        
        filterResponse = filterResponses(:,:,i);
        
        filterResponse = reshape(filterResponse,[size(filterResponse,1)*size(filterResponse,2),1]);
        filterResponse = filterResponse(alpha);
        
        alpha_3F_response = [alpha_3F_response filterResponse];
        
        end
        
        filter_responses=[filter_responses; alpha_3F_response];
    end
    end
    K=100;
    [~, dictionary]=kmeans(filter_responses, K, 'EmptyAction', 'drop', 'MaxIter',1500);
end
