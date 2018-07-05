function y = fully_connected(x,W,b)

J=size(W,1);
K=size(x,1);

y=zeros(J,1);

for j=1:J
    for k=1:K
        
        y(j)= y(j) + x(k)* W(j,k);
    end
    y(j)=y(j) + b(j);
end

end