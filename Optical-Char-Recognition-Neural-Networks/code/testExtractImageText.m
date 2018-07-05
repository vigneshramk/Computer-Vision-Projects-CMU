% Your code here.

% Load the files
fname{1} = '../images/01_list.jpg';
fname{2} = '../images/02_letters.jpg';
fname{3} = '../images/03_haiku.jpg';
fname{4} = '../images/04_deep.jpg';

% Extract the text for each of the cases
for k = 1:length(fname)
    text = extractImageText(fname{k});
    text_all{k} = text;
    
    disp(text)
end
