function [img, hdr]=read_analyze(pname, fname, msg)

if ~exist('fname'),
    if ~exist('msg')
        msg='Select a file to read';
    end
    [fname,pname] = uigetfile(['*.img'],msg);
elseif length(fname)==0
    if ~exist('msg')
        msg='Select a file to read';
    end
    [fname,pname] = uigetfile(['*.img'],msg);
end

six=findstr(fname, '.');
if length(six) == 0
    fcore=fname;
else
    fcore=fname(1:six(end)-1);
end

if pname(end) ~= '/', pname=[pname '/']; end
%[pname fcore]
%read header
fid=fopen([pname fcore '.hdr'], 'r');
hdr.hk.sizeof_hdr=fread(fid,1,'int32');
hdr.hk.data_type=fread(fid,10,'uint8');
hdr.hk.db_name=fread(fid,18,'uint8');
hdr.hk.extents=fread(fid,1,'int32');
hdr.hk.session_error=fread(fid,1,'int16');
hdr.hk.regular=fread(fid,1,'int8');
hdr.hk.hkey_un0=fread(fid,1,'int8');

hdr.dime.dim=fread(fid,8,'int16');
hdr.dime.unused8=fread(fid,1,'int16');
hdr.dime.unused9=fread(fid,1,'int16');
hdr.dime.unused10=fread(fid,1,'int16');
hdr.dime.unused11=fread(fid,1,'int16');
hdr.dime.unused12=fread(fid,1,'int16');
hdr.dime.unused13=fread(fid,1,'int16');
hdr.dime.unused14=fread(fid,1,'int16');
hdr.dime.datatype=fread(fid,1,'int16');
hdr.dime.bitpix=fread(fid,1,'int16');
hdr.dime.dim_un0=fread(fid,1,'int16');
hdr.dime.pixdim=fread(fid,8,'float32');
hdr.dime.vox_offset=fread(fid,1,'float32');
hdr.dime.funused1=fread(fid,1,'float32');
hdr.dime.funused2=fread(fid,1,'float32');
hdr.dime.funused3=fread(fid,1,'float32');
hdr.dime.cal_max=fread(fid,1,'float32');
hdr.dime.cal_min=fread(fid,1,'float32');
hdr.dime.compressed=fread(fid,1,'float32');
hdr.dime.verified=fread(fid,1,'float32');
hdr.dime.glmax=fread(fid,1,'int32');
hdr.dime.glmin=fread(fid,1,'int32');

hdr.hist.descrip=fread(fid,80,'uchar');
hdr.hist.aux_file=fread(fid,24,'uchar');
hdr.hist.orient=fread(fid,1,'uint8');
hdr.hist.originator=fread(fid,10,'uint8');
hdr.hist.generated=fread(fid,10,'int8');
hdr.hist.scannum=fread(fid,10,'int8');
hdr.hist.patient_id=fread(fid,10,'uint8');
hdr.hist.exp_data=fread(fid,10,'int8');
hdr.hist.exp_time=fread(fid,10,'int8');
hdr.hist.hist_un0=fread(fid,3,'int8');
hdr.hist.views=fread(fid,1,'int32');
hdr.hist.vols_added=fread(fid,1,'int32');
hdr.hist.start_field=fread(fid,1,'int32');
hdr.hist.field_skip=fread(fid,1,'int32');
hdr.hist.omax=fread(fid,1,'int32');
hdr.hist.omin=fread(fid,1,'int32');
hdr.hist.smax=fread(fid,1,'int32');
hdr.hist.smin=fread(fid,1,'int32');
fclose(fid);
% end of reading header


xres=hdr.dime.dim(2)
yres=hdr.dime.dim(3)
numslices=hdr.dime.dim(4)
numser=hdr.dime.dim(5)
if numser ==0, numser=1; end

hdr.dime.datatype

switch hdr.dime.datatype
    case 2 
        datatype='uint8';
    case 4
        datatype='int16';
    case 8
        datatype='int32';
    case 16
        datatype='float32';
    case 32
        datatype='complex';
    case 64
        datatype='float64';
end

fid=fopen([pname fcore '.img'], 'r');
%img=fread(fid, inf, datatype);
img=single(fread(fid, xres*yres*numslices*numser, datatype));
fclose(fid);

% 
% match the image display orientation
temp=reshape(img, xres, yres, numslices, numser);
img=(zeros(yres, xres, numslices, numser)); 
for r=1:numser
    for s=1:numslices
        img(:,:,s,r)=flipud(temp(:,:,s,r)');
    end
end
hdr.dime.dim(2)=yres;
hdr.dime.dim(3)=xres;

xres=hdr.dime.pixdim(2);
yres=hdr.dime.pixdim(3);
hdr.dime.pixdim(2)=yres;
hdr.dime.pixdim(3)=xres;
  
    
    
    
    
    
    
