function dist = deepDistance(test_feature,train_features)

dist=-1*pdist2(test_feature,train_features,'euclidean');

end