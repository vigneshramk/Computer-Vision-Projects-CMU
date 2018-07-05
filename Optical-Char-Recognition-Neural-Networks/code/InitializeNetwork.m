function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

% Your code here

tot_layers = length(layers);
N = layers(1);
C = layers(tot_layers);
n_hidden = size(tot_layers) - 2;


size_layers = tot_layers - 1;

% Initialize W and b using cell arrays
W = cell(size_layers, 1);
b = cell(size_layers, 1);

for k=2:size_layers+1
    % Weights are initialized randomly and the variances are normalized
    W{k-1} = 0.05*randn(layers(k),layers(k-1)) ./ sqrt(layers(k-1));
    % Biases are initialized to zeros as the symmetry breaking is already done using the weights
    b{k-1} = zeros(layers(k),1);
end


C = size(b{end},1);
assert(size(W{1},2) == 1024, 'W{1} must be of size [H,N]');
assert(size(b{1},2) == 1, 'b{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');

end