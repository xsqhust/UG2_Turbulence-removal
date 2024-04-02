clc
clear
close all 
%frame selection
frames_dir = 'G:\UG2+competation_submit\subtrack2.1\code\distorted_sequences\';
file_dirs = dir(frames_dir);
files_name  = sort_nat({file_dirs.name});
for m = 3:length(file_dirs)
    exist_dir = ['.\Intermediate results\sharpest_sequences\',files_name{m},'\'];
    source_dir = [frames_dir,'\',files_name{m},'\'];
    if exist(exist_dir)
        continue
    else
        mkdir(exist_dir);
    end
    imgs = dir([source_dir '*png']);
    name = sort_nat({imgs.name});
    for i = 1:length(imgs)
        temp = imread([source_dir name{i}]);
        if size(temp,3) == 3
            temp = rgb2gray(temp);
        end
        stack(:,:,i) = double(temp);
    end
    
    num_frames = size(stack,3);
    [rows,cols] = size(temp);
    y     = zeros(rows,cols,num_frames);
    Ygrad = zeros(rows,cols,num_frames);
    
    for i = 1:size(stack,3)
        tmp = stack(:,:,i);
        [Grad,~] = imgradient(tmp);
        Ygrad(:,:,i) = Grad;
    end
    mean_img = mean(stack,3);
    h    = ones(15,15); h = h/sum(h(:));
    score_sharp = zeros(rows,cols,num_frames);
    for k=1:num_frames            
        score_sharp(:,:,k) = imfilter( abs(Ygrad(:,:,k)), h, 'symmetric' );
    end
    
    score_sharp_sum = sum(sum(score_sharp));
    score_sharp_sum = reshape(score_sharp_sum,[1,size(score_sharp_sum,3)]);
    [score_sharp_sort,idx_sharp] = sort(score_sharp_sum,'descend');
    for sharp = 1:30
        name_sharp = idx_sharp(sharp);
        source_file = [frames_dir,files_name{m},'\',name{name_sharp}];
        target_file =exist_dir;
        copyfile(source_file,target_file);
    end
end 


