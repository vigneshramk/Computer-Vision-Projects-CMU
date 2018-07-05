% Supplementary code for confusion matrix visualization

load('nist36_model.mat');
load('../data/nist36_test.mat', 'test_data', 'test_labels');

%load('nist26_model.mat');
%load('../data/nist26_test.mat', 'test_data', 'test_labels');

[outputs] = Classify(W, b, test_data);

n_C = size(outputs, 2);
n_D = size(outputs, 1);
confusion_mat = zeros(n_C, n_C);

for l = 1:n_D
    [~, curr_label] = max(test_labels(l, :));  
    [~, curr_predict] = max(outputs(l, :));  
    confusion_mat(curr_label, curr_predict) = confusion_mat(curr_label, curr_predict) + 1;
end 

confusion1 = confusion_mat;

confusion_mat = mat2gray(confusion_mat);
confusion_mat = imresize(confusion_mat, 10, 'nearest');
figure;
imshow(confusion_mat);