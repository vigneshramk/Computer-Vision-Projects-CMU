function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.
[~,N] = size(data);
[~,C] = size(labels);
assert(size(W{1},2) == N, 'W{1} must be of size [~,N]');
assert(size(b{1},2) == 1, 'b{1} must be of size [~,1]');
assert(size(b{end},2) == 1, 'b{end} must be of size [~,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,~]');

%Your code here

% Compute D,N,C
n_D = size(data,1);
n_N = size(data,2);
n_C = size(labels,2);

n_right_pred = 0;
loss = 0;

% Find the softmax output probabilities on the training data
[outputs] = Classify(W, b, data);

% Iterate over the data and find the number of correct predicitons
for i=1:n_D
    
    curr_label = labels(i,:);
    output_pred = outputs(i,:);
    
    % choose the index with the maximum softmax probability
    [~,idx] = max(output_pred);
    
    if curr_label(idx) == 1
        n_right_pred = n_right_pred + 1;
    end
    
    % Loss is computed using the cross-entropy loss definition
    loss = loss - sum(curr_label.*log((output_pred)));
end

% Compute accuracy and average loss
accuracy = n_right_pred/n_D;
loss = loss/n_D;

end