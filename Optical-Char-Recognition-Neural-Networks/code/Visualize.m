n_H = 400;
%n_H = 800;
classes = 26;
%classes = 36;

layers = [32*32, n_H, classes];
% [W, b] = InitializeNetwork(layers);

load('nist36_model.mat');

%load('nist26_model.mat');

%[W, b] = InitializeNetwork(layers);

load('../data/nist26_model_60iters.mat', 'W', 'b');

%len_W = length(W);


%dim_output = size(W{len_W}, 2);

%extra_W = 0.05*rand(dim_output,10);
%extra_b = zeros(1,10);

%W{len_W} = horzcat(W{len_W}', extra_W)';
%b{len_W} = horzcat(b{len_W}', extra_b)';

numImages = size(W{1}, 1);
img_size = sqrt(size(W{1}, 2));
montage_img = single([]);
minW = min(W{1}(:));

for i = 1:numImages
    W_img = W{1}(i, :);
    % Normalize the weights
    W_img = W_img - minW;
    W_img = W_img ./ max(W_img);
    currImage = reshape(W_img, [img_size img_size 1] );
    montage_img = cat(4, montage_img, currImage);
end

figure;
montage(montage_img,'DisplayRange',[0.5,1]);

end