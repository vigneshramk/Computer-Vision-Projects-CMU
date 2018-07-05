function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels,PrincipalCurvature, th_contrast, th_r)
%%Detecting Extrema
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels  - The levels of the pyramid where the blur at each level is
%               outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the
%                      curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a
%               DoG response magnitude above this threshold
% th_r        - remove any edge-like points that have too large a principal
%               curvature ratio
%
% OUTPUTS
% locsDoG - N x 3 matrix where the DoG pyramid achieves a local extrema in both
%           scale and space, and also satisfies the two thresholds.

[H, W, L] = size(DoGPyramid);
locsDoG = zeros(H * W * L, 3);
index=1;

for l=1:L
    for x=1:W
        for y=1:H
            
            currDoG = DoGPyramid(y,x,l);
            
            if(x < 3 || x > W - 2 || y < 3 || y > H - 2)
                continue;
            else
            neighbours = DoGPyramid(y-1:y+1,x-1:x+1,l);    
            max_flag = all(currDoG >= neighbours(:));
            min_flag = all(currDoG <= neighbours(:));                    
            end 
            
            if l==1
             max_flag = all([max_flag,(currDoG > DoGPyramid(y,x,l+1))]);
             min_flag = all([min_flag,(currDoG < DoGPyramid(y,x,l+1))]);
             
            elseif l==L
                   
             max_flag = all([max_flag,(currDoG > DoGPyramid(y,x,l-1))]);
             min_flag = all([min_flag,(currDoG < DoGPyramid(y,x,l-1))]);
                    
            else
             
             neighour_scale =  DoGPyramid(y,x,l-1:l+1);  
             max_flag = all([max_flag,(currDoG >= neighour_scale(:))']);
             min_flag = all([min_flag,(currDoG <= neighour_scale(:))']);
                    
            end
           
           R = PrincipalCurvature(y,x,l);
            
           if((max_flag || min_flag) && abs(currDoG) > th_contrast && R>=0 && R<= th_r)
               locsDoG(index,:) = [x, y, DoGLevels(l)];
               index = index + 1;
           end
            
        end
    end
end


end
    