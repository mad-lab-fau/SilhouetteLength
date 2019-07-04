function [data_start,data_stop] = start_stop_2(file_run)
% [data_start,data_stop] = start_stop_2(file_run)
% Please enter the CatWalk run file
%
% This code is used to determined the first and last frame where the
% calculation begin
%
% This code is related to the publication Timotius et.al, 
% "Silhouette-length-scaled gait parameters for motor functional analysis 
% in mice and rats", eNeuro, 2019.
%
% Ivanna K. Timotius (2019)

data_run = xlsread(file_run);
x_RF = data_run(:,3);
x_RH = data_run(:,11);
x_LF = data_run(:,19);
x_LH = data_run(:,27);
xi_RF = ~isnan(x_RF);
xi_RH = ~isnan(x_RH);
xi_LF = ~isnan(x_LF);
xi_LH = ~isnan(x_LH);
xd_RF = diff(xi_RF);
xd_RH = diff(xi_RH);
xd_LF = diff(xi_LF);
xd_LH = diff(xi_LH);
f_RH = find(xd_RH==1);       
f_LH = find(xd_LH==1);
data_start = max([f_RH(1);f_LH(1)]);

l_RF = find(xd_RF==-1);
l_LF = find(xd_LF==-1);
data_stop = min([l_RF(end);l_LF(end)]);