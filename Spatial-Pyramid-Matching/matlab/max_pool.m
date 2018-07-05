function y = max_pool(x,sz)

y=zeros(size(x,1),size(x,2),size(x,3));

for i=1:size(x,3)
    for m=1:size(x,1)-1
        for n=1:size(x,2)-1
            kernel=x(m:(m+sz(1)-1),n:(n+sz(2)-1),i);
            y(m,n,i) = max(kernel(:));
    
end
    end
end

end