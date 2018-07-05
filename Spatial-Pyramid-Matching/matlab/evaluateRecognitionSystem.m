function [C,conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');
    source = '../data/';
    target = '../data/'; 
    
    l = length(test_imagenames);
    
    C=zeros(8,8);
    
    for i=1:l
	image = im2double(imread([source, test_imagenames{i}]));
	fprintf('[Getting Visual Words..]\n');
	wordMap = getVisualWords(image, filterBank, dictionary);
	h = getImageFeaturesSPM(3, wordMap, size(dictionary,1));
	distances = distanceToSet(h, train_features);
	[~,nnI] = max(distances);
	guess(i)=train_labels(nnI);
	original(i)=test_labels(i);
    
    C(guess(i),original(i))=C(guess(i),original(i))+1;
    
    end

    conf=trace(C)/sum(C(:));
end