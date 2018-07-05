% Your code here.
im1 = imread('../images/01_list.jpg');
im2 = imread('../images/02_letters.jpg');
im3 = imread('../images/03_haiku.jpg');
im4 = imread('../images/04_deep.jpg');

[lines1, bw1] = findLetters(im1);
[lines2, bw2] = findLetters(im2);
[lines3, bw3] = findLetters(im3);
[lines4, bw4] = findLetters(im4);

colors = ["blue", "green", "red", "cyan", "magenta", "black","blue", "green", "red"];

for i = 1:length(lines1)
    curr_line = lines1{i}; 
    [num_obj, ~] = size(curr_line);
    for k = 1:num_obj
        curr_obj = curr_line(k, :);
        W = curr_obj(3) - curr_obj(1);
        H = curr_obj(4) - curr_obj(2);
        im1 = insertShape(im1,'Rectangle',[curr_obj(1), curr_obj(2), W, H],'LineWidth', 7,'Color', char(colors(i)) );
    end
end
figure;
imshow(im1)

for i = 1:length(lines2)
    curr_line = lines2{i}; 
    [num_obj, ~] = size(curr_line);
    for k = 1:num_obj
        curr_obj = curr_line(k, :);
        W = curr_obj(3) - curr_obj(1);
        H = curr_obj(4) - curr_obj(2);
        im2 = insertShape(im2,'Rectangle',[curr_obj(1), curr_obj(2), W, H],'LineWidth', 7,'Color', char(colors(i)));
    end
end
figure;
imshow(im2)

for i = 1:length(lines3)
    curr_line = lines3{i}; 
    [num_obj, ~] = size(curr_line);
    for k = 1:num_obj
        curr_obj = curr_line(k, :);
        W = curr_obj(3) - curr_obj(1);
        H = curr_obj(4) - curr_obj(2);
        im3 = insertShape(im3,'Rectangle',[curr_obj(1), curr_obj(2), W, H],'LineWidth', 7,'Color', char(colors(i)));
    end
end
figure;
imshow(im3)

for i = 1:length(lines4)
    curr_line = lines4{i}; 
    [num_obj, ~] = size(curr_line);
    for k = 1:num_obj
        curr_obj = curr_line(k, :);
        W = curr_obj(3) - curr_obj(1);
        H = curr_obj(4) - curr_obj(2);
        im4 = insertShape(im4,'Rectangle',[curr_obj(1), curr_obj(2), W, H],'LineWidth', 7,'Color',char(colors(i)));
    end
end
figure;
imshow(im4)
