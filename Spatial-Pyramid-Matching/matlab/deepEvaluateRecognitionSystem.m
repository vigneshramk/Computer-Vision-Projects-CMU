function [C,conf] = deepEvaluateRecognitionSystem(net)

    load('../data/traintest.mat');
    load('../data/fc7_training.mat');
    source = '../data/';
    target = '../data/';
    
    l = length(test_imagenames);
    
    C=zeros(8,8);
    
    for i=1:l
	I = double(imread([source, test_imagenames{i}]));
    fprintf('[Features for Image %d]\n',i);
    features = extractDeepFeatures(net,I);
    dist=deepDistance(features,fc7_training);
    [~,nnI] = max(dist);
    guess(i)=train_labels(nnI);
	original(i)=test_labels(i);
    
    C(guess(i),original(i))=C(guess(i),original(i))+1;
    
    end

    conf=trace(C)/sum(C(:));


end