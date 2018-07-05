function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% Takes in DoGPyramid generated in createDoGPyramid and returns
% PrincipalCurvature,a matrix of the same size where each point contains the
% curvature ratio R for the corre-sponding point in the DoG pyramid
%
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% OUTPUTS
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each 
%                      point contains the curvature ratio R for the 
%corresponding point in the DoG pyramid

R=zeros(size(DoGPyramid));

for k=1:size(DoGPyramid,3)

    [gx, gy] = gradient(DoGPyramid(:,:,k));
    [gxx, gxy] = gradient(gx);
    [gxy, gyy] = gradient(gy);
    R1=(gxx + gyy).^2;
    R2=(gxx.*gyy) - gxy.^2;
    R(:,:,k)=R1./R2;
end

PrincipalCurvature = R;
end