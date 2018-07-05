function y = stride(x,stride_val)

y=x(1:stride_val(1):end,1:stride_val(2):end,:);

end