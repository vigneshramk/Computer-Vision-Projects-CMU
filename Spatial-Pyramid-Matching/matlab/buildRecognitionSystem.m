function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../data/traintest.mat');

	% TODO create train_features
    
    source = '../data/';
    target = '../data/'; 

    filterBank=createFilterBank();
    
    l = length(train_imagenames)
    dictionarySize=size(dictionary,1);
    layerNum=3;
    histograms=zeros(21*dictionarySize,l);

    for i=1:l
        wordMapload = strrep(train_imagenames{i},'.jpg','.mat');
        fprintf('Converting to histograms %s and %d\n', wordMapload,i);
        load([source,wordMapload]);
        histograms(:,i) = getImageFeaturesSPM(layerNum,wordMap, dictionarySize);
    end

    fprintf('Saving the data\n');
    train_features=histograms;
    save([target,'train_features.mat'],'histograms');


save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end