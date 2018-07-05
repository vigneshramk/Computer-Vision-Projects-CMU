function X = ReadImgs(Folder,ImgType)
    Imgs = dir([Folder '/' ImgType]);
    size_img = [256,256];
    NumImgs = size(Imgs,1);
    image = double(imread([Folder '/' Imgs(1).name]));
    X = zeros([NumImgs [256,256,3]]);
    for i=1:NumImgs
      image = double(imread([Folder '/' Imgs(i).name]));
      if (size(image,3) == 1)
        image = imresize(image, size_img);
        
        X(i,:,:,1) = image;
        X(i,:,:,2) = image;
        X(i,:,:,3) = image;
      else
        image = imresize(image, size_img);
        X(i,:,:,:) = image;
    end
end