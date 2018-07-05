function y1 = multichannel_conv2(x,h,b,stride)

J=size(h,4);
K=size(x,3);
y1=zeros(size(x,1),size(x,2),J);
for j=1:J
    for k=1:K
        h(:,:,k,j) = rot90(h(:,:,k,j),2);
        y1(:,:,j)= y1(:,:,j) + conv2(x(:,:,k),h(:,:,k,j),'same');
    end
    y1(:,:,j)= y1(:,:,j) + b(j);
end

end