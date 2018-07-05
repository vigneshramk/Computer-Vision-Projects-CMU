function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k,levels, compareA, compareB)
%%Compute BRIEF feature
% INPUTS
% im      - a grayscale image with values from 0 to 1
% locsDoG - locsDoG are the keypoint locations returned by the DoG detector
% levels  - Gaussian scale levels that were given in Section1
% compareA and compareB - linear indices into the patchWidth x patchWidth image 
%                         patch and are each nbits x 1 vectors
%
% OUTPUTS
% locs - an m x 3 vector, where the first two columns are the image coordinates 
%		 of keypoints and the third column is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of 
%        valid descriptors in the image and will vary

M=size(im,1); % M corresponds to rows -> y
N=size(im,2); % N corresponds to columns -> x

m=1;

compareA= compareA + 9;
compareB= compareB + 9;

for k=1:size(locsDoG,1)
    
    x=locsDoG(k,1);
    y=locsDoG(k,2);
    
    if(x-4 > 0 && x + 4 <= N && y-4 > 0 && y+4 <=M)
    
        patch = im(y-4:y+4,x-4:x+4);
        
    
        y1=floor(compareA./9);
        x1=mod(compareA,9);
        
        y2=floor(compareB./9);
        x2=mod(compareB,9);
            
        for j=1:size(compareA,1)
        
        if(x1(j)==0)
            x1(j)=9;
            y1(j)=y1(j)-1;
        end
        
        if(x2(j)==0)
            x2(j)=9;
            y2(j)=y2(j)-1;
        end
        
        end
        
       
        for i=1:size(compareA,1)
        
        desc(m,i)=(patch(y1(i),x1(i)) > patch(y2(i),x2(i)));
        end
        
        locs(m,:)=locsDoG(k,:);
        m=m+1;
    end
    
    end


end