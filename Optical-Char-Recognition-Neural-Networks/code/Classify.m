function [outputs] = Classify(W, b, data)
% [predictions] = Classify(W, b, data) should accept the network parameters 'W'
% and 'b' as well as an DxN matrix of data sample, where D is the number of
% data samples, and N is the dimensionality of the input data. This function
% should return a vector of size DxC of network softmax output probabilities.
[D,N] = size(data);
C = size(b{end},1);
assert(size(W{1},2) == N, 'W{1} must be of size [H,N]');
assert(size(b{1},2) == 1, 'W{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');

% Your code here

n_D = size(data, 1);
n_C = size(b{end},1);
outputs = zeros(n_D, n_C);

% Take each training sample, do the forward pass and store the output in a
% D x C array
for i = 1:n_D
    X = data(i,:)';
    
    % Do the forward pass on each data sample and store the output
    [curr_output, ~, ~] = Forward(W, b, X);    
    outputs(i, :) = curr_output';
end

assert(all(size(outputs) == [D,C]), 'output must be of size [D,C]');
end