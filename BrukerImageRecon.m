%% Bruker individual coil image reconstruction
% Hari Rallapalli

%% 
clear all
close all
clc

if exist('addBrukerPaths') == 0
    addpath G:\Code\Git\image-reconstruction\pvtools
    addBrukerPaths
end


%% Load image data

Acqp = readBrukerParamFile('G:\Code\Git\image-reconstruction\20180802_175417_20180802_HR_T1mapping_MN1_1_1\4\acqp');

%% 

data = readBrukerRaw(Acqp, 'G:\Code\Git\image-reconstruction\20180802_175417_20180802_HR_T1mapping_MN1_1_1\4\fid');


%%

frame = convertRawToFrame(data, Acqp);