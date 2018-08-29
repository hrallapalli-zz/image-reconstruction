% Estimate T1 using RARE SR saturation T1 + T2 map reconstructed from
% Bruker

clear all;
close all;

if exist('addBrukerPaths') == 0
    addpath G:\Code\Git\image-reconstruction\pvtools
    addBrukerPaths
end

disp('RARE SR T1 - Estimated from Bruker ISA');

% select RARE SR T1 ISA estimated path
if exist('pname', 'dir')==0
    pname=uigetdir(pwd, 'Pick ISA estimated T1 Folder');
end

% amendament '\' to the path name string if there is not
if pname(end)~= '\'
    pname=[pname '\'];
end

% T1 map or T2 map
ISAfuncName=bruker_method(pname, 'isa', 'ISA_func_name');
if strcmp(ISAfuncName, 't1sat')
    bT1orT2=1; % T1 map
elseif strcmp(ISAfuncName, 't2vtr')
    bT1orT2=0; % T2 map
else
end

% number of TRs and TEs
nTE=5;
nTR=5;

nPara=5; 
% <signal intensity> 
% <std dev of signal intensity> 
% <T1 relaxation time> 
% <std dev of T1 relaxation time> 
% <std dev of the fit>

nSlice=1;
ParaImg='x2dseq.img';
[img, hdr]=read_analyze(pname, ParaImg);
nFrame=size(img, 3);
ParaSlope=bruker_method(pname, 'visu_pars', 'VisuCoreDataSlope');
ParaOffset=bruker_method(pname, 'visu_pars', 'VisuCoreDataOffs');

for i=1:1:nFrame
    RealValueImg(:,:,i)=img(:,:,i)*ParaSlope(i)+ParaOffset(i);
end

for j=1:1:nFrame/nTR/nSlice
    T1Maps(:,:,j)=RealValueImg(:,:,3+(j-1)*nPara)/1000;
end

% one slice
Map.T1orT2_NR1=[squeeze(T1Maps(:,:,3))];
Map.T1orT2_NR2=[squeeze(T1Maps(:,:,8))];


if bT1orT2
    % plot    
    mat_T1=Map.T1orT2_NR1;
    index=find(mat_T1>4);
    mat_T1(index)=4;
    index=find(mat_T1<0.1);
    mat_T1(index)=0.1;
        
    figure;    
    subplot(1,2,1);
    colormap_range=64;
    [ColorMatrix]=ColorMap4ParameterMatrix(flipud(mat_T1), 0, 4.0);
    [n1,xout] =hist(ColorMatrix(:), colormap_range);   % hist intensities according to the colormap range
    [val ind]=sort(abs(xout)); % sort according to values closest to zero
    j = jet;
    j(ind(1),:) = [ 0 0 0 ]; % also see comment below
    % you can also use instead something like j(ind(1:whatever),:)=ones(whatever,3);
    image(ColorMatrix);
    colormap(j);
    %axis image;
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    title('T_1 Map from Repetition 1');
    axis image;
    colorbar('YTick', 0:16:64, 'YTickLabel', {'0', '1.0 s', '2.0 s', '3.0 s', '4.0 s'});
    
    % plot        
    mat_T1=Map.T1orT2_NR2;
    index=find(mat_T1>4);
    mat_T1(index)=4;
    index=find(mat_T1<0.1);
    mat_T1(index)=0.1;
    
    subplot(1,2,2);
    colormap_range=64;
    [ColorMatrix]=ColorMap4ParameterMatrix(flipud(mat_T1), 0, 4.0);
    [n1,xout] =hist(ColorMatrix(:), colormap_range);   % hist intensities according to the colormap range
    [val ind]=sort(abs(xout)); % sort according to values closest to zero
    j = jet;
    j(ind(1),:) = [ 0 0 0 ]; % also see comment below
    % you can also use instead something like j(ind(1:whatever),:)=ones(whatever,3);
    image(ColorMatrix);
    colormap(j);
    %axis image;
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    title('T_1 Map from Repetition 2');            
    axis image;
    colorbar('YTick', 0:16:64, 'YTickLabel', {'0', '1.0 s', '2.0 s', '3.0 s', '4.0 s'});
end

if ~bT1orT2
    % plot
    mat_T1=Map.T1orT2_NR1;
    figure;
    subplot(1,2,1);
    colormap_range=64;
    [ColorMatrix]=ColorMap4ParameterMatrix(flipud(mat_T1), 0, 0.1);
    [n1,xout] =hist(ColorMatrix(:), colormap_range);   % hist intensities according to the colormap range
    [val ind]=sort(abs(xout)); % sort according to values closest to zero
    j = jet;
    j(ind(1),:) = [ 0 0 0 ]; % also see comment below
    % you can also use instead something like j(ind(1:whatever),:)=ones(whatever,3);
    image(ColorMatrix);
    colormap(j);
    %axis image;
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    title('T_2 Map from Repetition 1');
    axis image;
    h=colorbar('YTick', 0:16:64, 'YTickLabel', {'0', '25 ms', '50 ms', '75 ms', '100 ms'});
    
    % plot
    mat_T1=Map.T1orT2_NR2;
    subplot(1,2,2);
    colormap_range=64;
    [ColorMatrix]=ColorMap4ParameterMatrix(flipud(mat_T1), 0, 0.1);
    [n1,xout] =hist(ColorMatrix(:), colormap_range);   % hist intensities according to the colormap range
    [val ind]=sort(abs(xout)); % sort according to values closest to zero
    j = jet;
    j(ind(1),:) = [ 0 0 0 ]; % also see comment below
    % you can also use instead something like j(ind(1:whatever),:)=ones(whatever,3);
    image(ColorMatrix);
    colormap(j);
    %axis image;
    set(gca, 'XTickLabel', []);
    set(gca, 'YTickLabel', []);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    title('T_2 Map from Repetition 2');
    axis image;
    h=colorbar('YTick', 0:16:64, 'YTickLabel', {'0', '25 ms', '50 ms', '75 ms', '100 ms'});
    
    
end

if bT1orT2==1
    savefile='RARESRBrukerT1.mat';
elseif bT1orT2==0
    savefile='RARESRBrukerT2.mat';
end

save([pname savefile], 'Map', 'T1Maps');


