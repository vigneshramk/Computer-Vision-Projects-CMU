% Your code here.

% Initialize parameters required for the function
n_epochs = 10;
learning_rate = 0.01;
epsilon = 10^-4;
thresh = 10^-4;

% Input layer of 1024, 1 hidden layer and 1 output layer with size 26
layers = [1024,400,26];

N = layers(1);
D = 1;
data = rands(D,N); % Some example training data
labels = zeros(1,26); labels(5) = 1; % Some example label

% Initialize the weights and biases for the network with random numbers
[W, b] = InitializeNetwork(layers);
size_layers = size(W, 1);


for k=1:n_epochs
    
    for p=1:D
        
        X = data(p,:)';
        Y = labels(p,:)';
        
        % Do the forward and backward pass
        [output, act_h, act_a] = Forward(W, b, X);
        [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a);
        
        % checking the gradient obtained from the backward pass
        for l=1:size_layers
            
            % Sample a few elements from W{l} and b{l} for testing (less number of samples to speed up) 
            b_test = randsample(numel(b{l}),6);
            
            for j=1: size(b_test,1)
                
                b1 = b; b2 = b;
                
                b1{l}(b_test(j)) = b1{l}(b_test(j)) + epsilon;
                b2{l}(b_test(j)) = b2{l}(b_test(j)) - epsilon;
                
                % Compute the approximate gradient and for a small epsilon
                % and compare it with the gradient obtained in the backward
                % pass
                [~, loss1] = ComputeAccuracyAndLoss(W, b1, data, labels);
                [~, loss2] = ComputeAccuracyAndLoss(W, b2, data, labels);
                
                g = (loss1 - loss2) / (2*epsilon);
                diff = abs(grad_b{l}(b_test(j)) - g);
                
                if diff > thresh
                    fprintf('Error in Layer - %d, Error - %f',l, diff);
                else
                    continue
                end      
            end
            
            
            W_test = randsample(numel(W{l}),6);
            [x, y] = ind2sub(size(W{l}), W_test);
            
            for i=1: size(W_test,1)
                W1 = W; W2 = W;
             
                W1{l}(x(i), y(i)) = W1{l}(x(i), y(i)) + epsilon;
                W2{l}(x(i), y(i)) = W2{l}(x(i), y(i)) - epsilon;
                
                % Compute the approximate gradient and for a small epsilon
                % and compare it with the gradient obtained in the backward
                % pass
                [~, loss1] = ComputeAccuracyAndLoss(W1, b, data, labels);
                [~, loss2] = ComputeAccuracyAndLoss(W2, b, data, labels);
                
                g = (loss1 - loss2) / (2*epsilon);
                
                diff = abs(grad_W{l}(x(i), y(i)) - g);
                if diff > thresh
                    fprintf('Error in Layer - %d, Error - %f',l, diff);
                else
                    continue
                end
            end
            
            
            
        end
    end
    
    
    % Compute the accuracy and loss after each epoch
    [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);
    [accuracy, loss_fin] = ComputeAccuracyAndLoss(W, b, data, labels);
    fprintf('Epoch - %d, Accuracy - %f , Average Loss: %f\n', k, accuracy,loss_fin)
end