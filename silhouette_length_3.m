function result = silhouette_length_3(folder,cohort_name,file_name,animal,x_mm_pixel,y_mm_pixel)
% [length_mm_max,area_max,area_w_tail_max] = silhouette_length_3(folder,cohort_name,file_name,animal,x_mm_pixel,y_mm_pixel)
%
% This function calculates silhouette length based on the CatWalk data.
% The 'folder' and 'cohort_name' refer to the folder name, where the CatWalk
% data are located.
% The CatWalk data needed are the 'video', 'background image' and 'run
% data'.
% The 'animal' here refers to the type of rodents, which is related to the
% structuring element size.
% The 'x_mm_pixel' and 'y_mm_pixel' information could be read from the 'run statistic'. 
%
% example:
% folder = pwd;
% cohort_name = 'Rats_06mo\Rats_wt';
% file_name = '5772_Run024';
% animal = 'rats';
% x_mm_pixel = 1.01522842639594;
% y_mm_pixel = 1.02040816326531;
%
% folder = pwd;
% cohort_name = '47w\wt_wt\';
% file_name = '1219_Run002';
% animal = 'mice' or 'rats';
% x_mm_pixel = 0.738007380073801;
% y_mm_pixel = 0.72463768115942;
%
% This code is related to the publication Timotius et.al, 
% "Silhouette-length-scaled gait parameters for motor functional analysis 
% in mice and rats", eNeuro, 2019.
%
% Ivanna K. Timotius (2019)

% Structuring element:
if animal == 'rats',
    se_size = 9;
elseif animal == 'mice'
    se_size = 7;
end
xy_mm2_pixel = x_mm_pixel*y_mm_pixel;
se = strel('diamond',se_size);

%Read files:
MiceObj = VideoReader([folder,cohort_name,'\Video_',file_name,'.avi']);
background = imread([folder,cohort_name,'\background_',file_name,'.png']);
[batas(1),batas(2)] = start_stop_2([folder,cohort_name,'\',file_name,'.xlsx']);
vidWidth = MiceObj.Width;
vidHeight = MiceObj.Height;
vidFrameRate = MiceObj.FrameRate;
vidDuration = MiceObj.Duration;
vidNumberFrame = vidFrameRate*vidDuration;
mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
k = 1;
while hasFrame(MiceObj)
    mov(k).cdata = readFrame(MiceObj);
    if k >= batas(1) && k<= batas(2),
        im_k = mov(k).cdata;
        % Silhouette making:
        i_background = logical(abs(double(im_k) - double(background)) > 10);
        i_blob_black = i_background(:,:,1) | i_background(:,:,2) | i_background(:,:,3);
        i_blob_open = imopen(i_blob_black,se);
        i_blob_fill = imfill(i_blob_open,'holes');
        i_blob_big = bwareafilt(i_blob_fill,1);
        % for area_w_tail:
            i_blob_w_tail = bwareafilt(imfill(i_blob_black,'holes'),1);
        % Silhouette_length calculation:
        [f(:,2),f(:,1)] = find(i_blob_big);
        [endpoint1,u1] = max(f(:,1)); 
        [endpoint2,u2] = min(f(:,1));
        tu1 = [endpoint1 f(u1,2)];
        tu2 = [endpoint2 f(u2,2)];
        length_max_min(k) = sqrt(sum(((tu1 - tu2 - [se_size 0]).*[x_mm_pixel y_mm_pixel]).^2));
        % Silhouette_area calculation:
        area(k) = sum(sum(i_blob_big))*xy_mm2_pixel;
        area_w_tail(k) = sum(sum(bwareafilt(i_blob_w_tail,1)))*xy_mm2_pixel;  
    else
        length_max_min(k) = NaN;
        area(k) = NaN;
        area_w_tail(k) = NaN;
    end        
    k = k+1;
    clear f 
    clear i_blob i_blob_black i_blob_fill i_blob_big i_background
end
[area_max,frame_area]=max(area);
[area_w_tail_max,frame_area_w_tail]=max(area_w_tail);
[length_mm_max,frame_length_mm]=max(length_max_min);
result = [length_mm_max,area_max,area_w_tail_max];