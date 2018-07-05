function [] = computefc7 (net)

    load('../data/traintest.mat');
    load('../data/fc7_training.mat');
    source = '../data/';
    target = '../data/';
    
    l = length(train_imagenames)
    
    for i=1:l
	I = im2double(imread([source, train_imagenames{i}]));
    fprintf('[Features for Image %d]\n',i);
    features(i,:)=activations(net,im2double(imresize(I,[224,224])),'fc7','OutputAs','channels');
    end

save([target, 'fc7_training_kvr.mat'],'features');    
    
end