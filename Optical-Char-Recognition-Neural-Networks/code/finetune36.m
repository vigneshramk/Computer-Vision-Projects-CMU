
num_epoch = 5;
classes = 36;
learning_rate = 0.01;

load('../data/nist26_model_60iters.mat', 'W', 'b');
load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')


len_W = length(W);


dim_output = size(W{len_W}, 2);

extra_W = 0.05*rand(dim_output,10);
extra_b = zeros(1,10);

W{len_W} = horzcat(W{len_W}', extra_W)';
b{len_W} = horzcat(b{len_W}', extra_b)';

train_acc_epochs = zeros(1,num_epoch);
train_loss_epochs = zeros(1,num_epoch);

valid_acc_epochs = zeros(1,num_epoch);
valid_loss_epochs = zeros(1,num_epoch);

for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc, train_loss] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    train_acc_epochs(j) = train_acc*100;
    train_loss_epochs(j) = train_loss;
    
    [valid_acc, valid_loss] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);
    valid_acc_epochs(j) = valid_acc*100;
    valid_loss_epochs(j) = valid_loss;
    
    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc, valid_acc, train_loss, valid_loss)
end

save('nist36_model.mat', 'W', 'b')
save('../acculoss.mat','train_acc_epochs','valid_acc_epochs','train_loss_epochs','valid_loss_epochs');

% Plot of accuracy of the training and cross-validation sets
figure; hold on;
plot1 = plot(1:num_epoch, train_acc_epochs);
plot1.LineWidth = 2;
plot2 = plot(1:num_epoch, valid_acc_epochs);
plot2.LineWidth = 2;
title('Accuracy vs Number of epochs')
xlabel('Epoch number')
ylabel('Accuracy (Percentage)')


% Plot of loss of the training and cross-validation sets
figure; hold on;
plot1 = plot(1:num_epoch, train_loss_epochs);
plot1.LineWidth = 2;
plot2 = plot(1:num_epoch, valid_loss_epochs);
plot2.LineWidth = 2;
title('Loss vs Number of epochs')
xlabel('Epoch number')
ylabel('Average Loss')