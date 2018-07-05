function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_h' and 'act_a' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'
N = size(X,1);
H = size(W{1},1);
C = size(b{end},1);
assert(size(W{1},2) == N, 'W{1} must be of size [H,N]');
assert(size(b{1},2) == 1, 'b{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');
assert(all(size(act_a{1}) == [H,1]), 'act_a{1} must be of size [H,1]');
assert(all(size(act_h{end}) == [C,1]), 'act_h{end} must be of size [C,1]');


% Your code here

size_layers = length(W);
n_N = size(X,1);
n_C = size(Y,1);

% initialize the gradients
grad_W = cell(size_layers, 1);
grad_b = cell(size_layers, 1);
err_layer = cell(size_layers, 1);

% Compute the gradients using the definition of cross entropy loss
for k = size_layers: -1: 1
    
    if k ~= size_layers
        err_layer{k} = (W{k+1}' * err_layer{k + 1}) .* act_h{k} .* (1 - act_h{k});
    else % Error for the output layer 
        err_layer{k} = act_h{k} - Y; % since Y is one-hot we can use such a error term for the output layer
    end
    
    grad_b{k} = (err_layer{k});
    
    if k == 1 % Gradient for the input layer
        grad_W{k} = (err_layer{k} * X');
    else
        grad_W{k} = (err_layer{k} * (act_h{k - 1})'); 
    end
    
end

assert(size(grad_W{1},2) == N, 'grad_W{1} must be of size [H,N]');
assert(size(grad_W{end},1) == C, 'grad_W{end} must be of size [C,N]');
assert(size(grad_b{1},1) == H, 'grad_b{1} must be of size [H,1]');
assert(size(grad_b{end},1) == C, 'grad_b{end} must be of size [C,1]');

end