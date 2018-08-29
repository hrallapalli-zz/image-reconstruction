%% Bruker individual coil image reconstruction
% Hari Rallapalli

%% 
clear all
close all
clc

if exist('addBrukerPaths') == 0
    addpath pvtools
    addBrukerPaths
end


%% Path to files

DIRECTORYNAME = uigetdir('', 'Navigate to Image Directory!');

%% Load image parameters

Acqp = readBrukerParamFile([DIRECTORYNAME '\acqp']);
Method = readBrukerParamFile([DIRECTORYNAME '\method']);

%% import raw, unreconstructed FID data

data = readBrukerRaw(Acqp, [DIRECTORYNAME '\fid']);

if iscell(data)
    data = data{:};
end
%% reshape FID data to image size

frame = convertRawToFrame(data, Acqp);

%% correctly circshift to produce kspace

ckdata = convertFrameToCKData(frame, Acqp, Method);

%% Remove singleton dimensions

coilkspace = squeeze(frame);
% This is in the form [Nx Ny (Nz) Nc NObjects NRep]. In the case of 2D-VTR
% protocols, this is [Nx Ny Nc Nte Ntr]


%% Reconstruct coil images, assuming fully sampled, cartesian k-space trajectory 

image_coil1 = squeeze(fftshift(fftn(ckdata(:,:,:,1,1,:,:))));
image_coil2 = squeeze(fftshift(fftn(ckdata(:,:,:,1,2,:,:))));
image_coil3 = squeeze(fftshift(fftn(ckdata(:,:,:,1,3,:,:))));
image_coil4 = squeeze(fftshift(fftn(ckdata(:,:,:,1,4,:,:))));


%% Save kspace data, and reconstructed coil images

% save([DIRECTORYNAME '\kspace'], 'coilkspace');
% save([DIRECTORYNAME '\coilimages'], 'image_coil1', 'image_coil2', 'image_coil3', 'image_coil4');