function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%%Produces DoG Pyramid
% inputs
% Gaussian Pyramid - A matrix of grayscale images of size
%                    (size(im), numel(levels))
% levels      - the levels of the pyramid where the blur at each level is
%               outputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%               created by differencing the Gaussian Pyramid input

DoGPyramid=zeros(size(GaussianPyramid,1),size(GaussianPyramid,2),size(GaussianPyramid,3)-1);
DoGLevels=zeros(size(levels,1),size(levels,2)-1);
for i=1:size(levels,2)-1
DoGLevels(i)=levels(i+1);
end

for i=1:size(GaussianPyramid,3)-1
DoGPyramid(:,:,i)=GaussianPyramid(:,:,i+1)-GaussianPyramid(:,:,i);
end


end