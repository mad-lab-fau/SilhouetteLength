% This code calculates the silhouette length of mice and use it for gait
% parameter (stride lengths and speed) scaling
%
% The data are named: 
% [animal_name]_Run[XXX].xls
% background_[animal_name]_Run[XXX].png
% Video_[animal_name]_Run[XXX].avi
%
% This code is related to the publication Timotius et.al, 
% "Silhouette-length-scaled gait parameters for motor functional analysis 
% in mice and rats", eNeuro, 2019.
%
% Ivanna K. Timotius (2019)

clear all
close all
clc

% reading files:
folder = pwd;                               % The folder position of files
file_list = [folder,'\mice_run_statistics_sample.xlsx'];
file_result = [folder,'\mice_results.xlsx'];

[n1,n2] = xlsread(file_list,1,'A2:J4');     % Please adjust with the number of data
weight = n1(:,1);
ages = n1(:,2);
animal = n2(:,5);
runs = n2(:,10);
group = n2(:,2);

kel_ages = [20 32 47];      % Use this if the folders are arrange according to age point

xy_unit(:,1:2) = xlsread(file_list,1,'S2:T4');     % X-Unit and Y-Unit. Please adjust with the number of data

% Read gait parameters: Please adjust with the number of data
gait_pjg(:,1) = 0.5*(xlsread(file_list,1,'BC2:BC4')+xlsread(file_list,1,'FO2:FO4'));    % Front Stride Length (cm)
gait_pjg(:,2) = 0.5*(xlsread(file_list,1,'DI2:DI4')+xlsread(file_list,1,'HU2:HU4'));    % Hind Stride Length (cm)
gait_spd(:,1) = 0.25*(xlsread(file_list,1,'BY2:BY4')+xlsread(file_list,1,'EE2:EE4')+...
                     xlsread(file_list,1,'GK2:GK4')+xlsread(file_list,1,'IQ2:IQ4'));    % Body Speed (cm/s)
gait_spd(:,2) = 0.5*(xlsread(file_list,1,'BA2:BA4')+xlsread(file_list,1,'FM2:FM4'));    % Front Swing Speed (cm/s)
gait_spd(:,3) = 0.5*(xlsread(file_list,1,'DG2:DG4')+xlsread(file_list,1,'HS2:HS4'));    % Hind Swing Speed (cm/s)
gait = [gait_pjg,gait_spd];

for i = 1:3, % number of runs
    if ages(i) == 20 && strcmp(group(i),'tg_wt'), folder1 = '\Data_Mice\20w\tg_wt';
    elseif ages(i) == 20 && strcmp(group(i),'wt_wt'), folder1 = '\Data_Mice\20w\wt_wt';    
    elseif ages(i) == 32 && strcmp(group(i),'tg_wt'), folder1 = '\Data_Mice\32w\tg_wt';
    elseif ages(i) == 32 && strcmp(group(i),'wt_wt'), folder1 = '\Data_Mice\32w\wt_wt';    
    elseif ages(i) == 47 && strcmp(group(i),'tg_wt'), folder1 = '\Data_Mice\47w\tg_wt';
    elseif ages(i) == 47 && strcmp(group(i),'wt_wt'), folder1 = '\Data_Mice\47w\wt_wt';
    end      
    file_name = [char(animal(i)),'_',char(runs(i))];
    result = silhouette_length_3(folder,folder1,file_name,'mice',xy_unit(i,1),xy_unit(i,2));
    sil_length(i,:) = result(1);
    sil_area_notail(i,:) = result(2);
    sil_area_tail(i,:) = result(3);
end
% Length-Scaling:
gait_s = gait./repmat(sil_length(:,1),[1 5]);

% Save the scaled gait parameters:
for d=1:2,
    xlswrite(file_result,{'Group','Animal','Age','Run','Weight'},d,'A1')
    xlswrite(file_result,group,d,'A2')
    xlswrite(file_result,animal,d,'B2')
    xlswrite(file_result,ages,d,'C2')
    xlswrite(file_result,runs,d,'D2')
    xlswrite(file_result,weight,d,'E2')
end
xlswrite(file_result,{'Silhouette.Length (mm)','Front.Stride.Length','Hind.Stride.Length',...
    'Body.Speed','Front.Swing.Speed','Hind.Swing.Speed'},1,'F1')
xlswrite(file_result,sil_length,1,'F2')
xlswrite(file_result,gait,1,'G2')
xlswrite(file_result,{'Silhouette.Length (mm)','Scaled.Front.Stride.Length','Scaled.Hind.Stride.Length',...
    'Scaled.Body.Speed','Scaled.Front.Swing.Speed','Scaled.Hind.Swing.Speed'},2,'F1')
xlswrite(file_result,sil_length,2,'F2')
xlswrite(file_result,gait_s,2,'G2')