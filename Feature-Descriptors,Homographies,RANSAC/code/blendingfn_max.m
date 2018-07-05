function [panoImg] = blendingfn_max(img1,img2)

max_size = max(size(img1), size(img2));
panoImg = zeros(max_size);

if(size(img1) == max_size)
    img2_pan = zeros(max_size);
    img2_pan(1:size(img2,1),1:size(img2,2),:) = img2;
    img1_pan= img1;
end

if(size(img2) == max_size)
    img1_pan = zeros(max_size);
    img1_pan(1:size(img1,1),1:size(img1,2),:) = img1;
    img2_pan = img2;

end


panoImg = max(img1_pan,img2_pan);

end