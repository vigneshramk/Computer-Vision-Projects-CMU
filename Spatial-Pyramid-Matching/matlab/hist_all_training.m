function hist_all_training() 


%load the files and texton dictionary
load('../data/traintest.mat','train_imagenames','mapping');


source = '../data/';
target = '../data/'; 

if ~exist(target,'dir')
    mkdir(target);
end

for category = mapping
    if ~exist([target,category{1}],'dir')
        mkdir([target,category{1}]);
    end
end

l = length(train_imagenames)

dictionarySize=200;
layerNum=3;
histograms=zeros(4200,l);
for i=1:l
    wordMapload = strrep(train_imagenames{i},'.jpg','.mat');
    fprintf('Converting to histograms %s and %d\n', wordMapload,i);
    load([source,wordMapload]);
    histograms(:,i) = getImageFeaturesSPM(layerNum,wordMap, dictionarySize);
end
    
fprintf('Saving the data\n');

save_hist=strcat('train_features',string(j),'.mat');
save([target,'train_features.mat'],'histograms');
end