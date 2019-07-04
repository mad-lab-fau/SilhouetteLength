% This code calculate the silhouette length of rats and use it for gait
% parameter (stride lengths and speed) scaling

clear all
close all
clc

% reading files:
folder = pwd;        % Letak file asli
file_list = [folder,'\rats_run_statistics_sample.xlsx'];
file_hasil = [folder,'\rats_results.xlsx'];

[n1,n2] = xlsread(file_list,1,'A2:D5');
umur = n1(:,1);
group = n2(:,1);
animal = n2(:,2);
runs = n2(:,4);

kel_umur = [2.5 6 10.5 13 15];
% pixel: The same for all rats, taken from the run statistics
x_mm_pixel = 1.01522842639594;
y_mm_pixel = 1.02040816326531;

% Read gait parameters:
gait_pjg(:,1) = 0.5*(xlsread(file_list,1,'AW2:AW13')+xlsread(file_list,1,'FI2:FI13'));    % Front Stride Length (cm)
gait_pjg(:,2) = 0.5*(xlsread(file_list,1,'DC2:DC13')+xlsread(file_list,1,'HO2:HO13'));    % Hind Stride Length (cm)
gait_spd(:,1) = 0.25*(xlsread(file_list,1,'BS2:BS13')+xlsread(file_list,1,'DY2:DY13')+...
                     xlsread(file_list,1,'GE2:GE13')+xlsread(file_list,1,'IK2:IK13'));    % Body Speed (cm/s)
gait_spd(:,2) = 0.5*(xlsread(file_list,1,'AU2:AU13')+xlsread(file_list,1,'FG2:FG13'));    % Front Swing Speed (cm/s)
gait_spd(:,3) = 0.5*(xlsread(file_list,1,'DA2:DA13')+xlsread(file_list,1,'HM2:HM13'));    % Hind Swing Speed (cm/s)
gait = [gait_pjg,gait_spd];

for i = 1:4, % number of runs
    if umur(i) == 2.5 && strcmp(group(i),'wt'), folder1 = '\Data_Rats\Rats_02mo\Rats_wt';
    elseif umur(i) == 2.5  && strcmp(group(i),'tg'), folder1 = '\Data_Rats\Rats_02mo\Rats_tg';
    elseif umur(i) == 6 && strcmp(group(i),'wt'), folder1 = '\Data_Rats\Rats_06mo\Rats_wt';
    elseif umur(i) == 6 && strcmp(group(i),'tg'), folder1 = '\Data_Rats\Rats_06mo\Rats_tg';
    elseif umur(i) == 10.5 && strcmp(group(i),'wt'), folder1 = '\Data_Rats\Rats_10mo\Rats_wt';
    elseif umur(i) == 10.5 && strcmp(group(i),'tg'), folder1 = '\Data_Rats\Rats_10mo\Rats_tg';
    elseif umur(i) == 13 && strcmp(group(i),'wt'), folder1 = '\Data_Rats\Rats_13mo\Rats_wt';
    elseif umur(i) == 13 && strcmp(group(i),'tg'), folder1 = '\Data_Rats\Rats_13mo\Rats_tg';
    elseif umur(i) == 15 && strcmp(group(i),'wt'), folder1 = '\Data_Rats\Rats_15mo\Rats_wt';
    elseif umur(i) == 15 && strcmp(group(i),'tg'), folder1 = '\Data_Rats\Rats_15mo\Rats_tg';
    end    
    file_name = [char(animal(i)),'_',char(runs(i))];
    hasil = silhouette_length_3(folder,folder1,file_name,'rats',x_mm_pixel,y_mm_pixel);
    sil_length(i,:) = hasil(1);
    sil_area_notail(i,:) = hasil(2);
    sil_area_tail(i,:) = hasil(3);
end
% Scaling:
gait_s = gait./repmat(sil_length(:,1),[1 5]);

% Save the scaled gait parameters:
for d=1:2,
    xlswrite(file_hasil,{'Group','Animal','Age','Run'},d,'A1')
    xlswrite(file_hasil,group,d,'A2')
    xlswrite(file_hasil,animal,d,'B2')
    xlswrite(file_hasil,umur,d,'C2')
    xlswrite(file_hasil,runs,d,'D2')
end
xlswrite(file_hasil,{'Silhouette.Length','Front.Stride.Length','Hind.Stride.Length',...
    'Body.Speed','Front.Swing.Speed','Hind.Swing.Speed'},1,'E1')
xlswrite(file_hasil,sil_length,1,'E2')
xlswrite(file_hasil,gait,1,'F2')
xlswrite(file_hasil,{'Silhouette.Length','Scaled.Front.Stride.Length','Scaled.Hind.Stride.Length',...
    'Scaled.Body.Speed','Scaled.Front.Swing.Speed','Scaled.Hind.Swing.Speed'},2,'E1')
xlswrite(file_hasil,sil_length,2,'E2')
xlswrite(file_hasil,gait_s,2,'F2')