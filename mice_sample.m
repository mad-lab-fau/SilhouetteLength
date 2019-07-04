% This code calculate the silhouette length of mice and use it for gait
% parameter (stride lengths and speed) scaling
%

clear all
close all
clc

% reading files:
folder = pwd;        % Letak file asli
file_list = [folder,'\mice_run_statistics_sample.xlsx'];
file_hasil = [folder,'\mice_results.xlsx'];

[n1,n2] = xlsread(file_list,1,'A2:J4');
weight = n1(:,1);
umur = n1(:,2);
animal = n2(:,5);
runs = n2(:,10);
group = n2(:,2);

kel_umur = [20 32 47];

xy_unit(:,1:2) = xlsread(file_list,1,'S2:T4');     % X-Unit

% Read gait parameters:
gait_pjg(:,1) = 0.5*(xlsread(file_list,1,'BC2:BC7')+xlsread(file_list,1,'FO2:FO7'));    % Front Stride Length (cm)
gait_pjg(:,2) = 0.5*(xlsread(file_list,1,'DI2:DI7')+xlsread(file_list,1,'HU2:HU7'));    % Hind Stride Length (cm)
gait_spd(:,1) = 0.25*(xlsread(file_list,1,'BY2:BY7')+xlsread(file_list,1,'EE2:EE7')+...
                     xlsread(file_list,1,'GK2:GK7')+xlsread(file_list,1,'IQ2:IQ7'));    % Body Speed (cm/s)
gait_spd(:,2) = 0.5*(xlsread(file_list,1,'BA2:BA7')+xlsread(file_list,1,'FM2:FM7'));    % Front Swing Speed (cm/s)
gait_spd(:,3) = 0.5*(xlsread(file_list,1,'DG2:DG7')+xlsread(file_list,1,'HS2:HS7'));    % Hind Swing Speed (cm/s)
gait = [gait_pjg,gait_spd];

for i = 1:3, % number of runs
    if umur(i) == 20 && strcmp(group(i),'tg_wt'), folder1 = '\Data_Mice\20w\tg_wt';
    elseif umur(i) == 20 && strcmp(group(i),'wt_wt'), folder1 = '\Data_Mice\20w\wt_wt';    
    elseif umur(i) == 32 && strcmp(group(i),'tg_wt'), folder1 = '\Data_Mice\32w\tg_wt';
    elseif umur(i) == 32 && strcmp(group(i),'wt_wt'), folder1 = '\Data_Mice\32w\wt_wt';    
    elseif umur(i) == 47 && strcmp(group(i),'tg_wt'), folder1 = '\Data_Mice\47w\tg_wt';
    elseif umur(i) == 47 && strcmp(group(i),'wt_wt'), folder1 = '\Data_Mice\47w\wt_wt';
    end      
    file_name = [char(animal(i)),'_',char(runs(i))];
    hasil = silhouette_length_3(folder,folder1,file_name,'mice',xy_unit(i,1),xy_unit(i,2));
    sil_length(i,:) = hasil(1);
    sil_area_notail(i,:) = hasil(2);
    sil_area_tail(i,:) = hasil(3);
end
% Length-Scaling:
gait_s = gait./repmat(sil_length(:,1),[1 5]);

% Save the scaled gait parameters:
for d=1:2,
    xlswrite(file_hasil,{'Group','Animal','Age','Run','Weight'},d,'A1')
    xlswrite(file_hasil,group,d,'A2')
    xlswrite(file_hasil,animal,d,'B2')
    xlswrite(file_hasil,umur,d,'C2')
    xlswrite(file_hasil,runs,d,'D2')
    xlswrite(file_hasil,weight,d,'E2')
end
xlswrite(file_hasil,{'Silhouette.Length','Front.Stride.Length','Hind.Stride.Length',...
    'Body.Speed','Front.Swing.Speed','Hind.Swing.Speed'},1,'F1')
xlswrite(file_hasil,sil_length,1,'F2')
xlswrite(file_hasil,gait,1,'G2')
xlswrite(file_hasil,{'Silhouette.Length','Scaled.Front.Stride.Length','Scaled.Hind.Stride.Length',...
    'Scaled.Body.Speed','Scaled.Front.Swing.Speed','Scaled.Hind.Swing.Speed'},2,'F1')
xlswrite(file_hasil,sil_length,2,'F2')
xlswrite(file_hasil,gait_s,2,'G2')