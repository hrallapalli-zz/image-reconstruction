
%% Bruker Image importer
clear all
close all

%% Read FID

% read in fid file as int32 with file header
[FID, FIDPATH] = uigetfile('*.*');
path = [FIDPATH FID];
fi=fopen(path, 'rb', 'ieee-le');
[data, cnt]=fread(fi, inf,'int32');
fclose(fi);
% reshape the data and construct an array of complex numbers
  data1 = data(1:4:end);
  data2 = data(2:4:end);
  data3 = data(3:4:end);
  data4 = data(4:4:end);

  data1_real = data1(1:2:end);
  data1_imag = data1(2:2:end);
  
cdata=complex(data1_real, data1_imag);
 
% now cdata is an array of complex number, you can reshape it for following fft reconstruction

%% Reconstruct

matrix_size = bruker_method(FIDPATH, 'acqp', 'ACQ_size');

num_echoes = bruker_method(FIDPATH, 'method', 'PVM_NEchoImages');
num_exp   =  bruker_method(FIDPATH, 'method', 'PVM_NEchoImages');
num_coils =  bruker_method(FIDPATH, 'method', 'PVM_EncNReceivers');


reshape_size = [matrix_size,1,num_coils,num_exp,num_echoes];
kspace_temp = reshape(cdata,matrix_size(1),matrix_size(2),num_coils,25);
kspace_size = size(kspace_temp);

im_recon =  fftshift(fftn(fftshift(kspace_temp)))*1/sqrt(length(kspace_temp(:)));
im_recon = circshift(im_recon,-kspace_size(3)/2,3);

imagesc(abs(im_recon(:,:,40)))
colormap gray


%% Write image to file

data = uint16(abs(im_recon));
outputFileName = [FIDPATH 'matlabRecon.tif'];


for k = 1:size(data,3)
    imwrite(data(:,:,k),outputFileName,'writemode','append','compression','none')
end
