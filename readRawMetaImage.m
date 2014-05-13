function [ raw, spacing ] = readRawMetaImage( fileName )
%READRAWMETAIMAGE Summary of this function goes here
%   Detailed explanation goes here

fid=fopen(fileName,'rb');
if fid < 0
  error(['Error opening file ', fileName]);
end

dimX = 1;
dimY = 1;
dimZ = 1;
spacing = [1 1 1];
pixelTransform = 'uchar=>uchar';

%% read header
rawDataStart = false;
while ~rawDataStart
  line = fgetl(fid);
  pair = strsplit(line, '=');
  
  if size(pair,2) ~= 2
    continue;
  end

  key = lower(strtrim(pair{1}));
  
  switch key
    case 'dimsize'
      vals = strsplit(strtrim(pair{2}), ' ');
      if size(vals, 2) < 3
        error('could not get dim size');
      end
      dimX = str2double(vals(1));
      dimY = str2double(vals(2));
      dimZ = str2double(vals(3));
      
   case 'elementspacing'
      vals = strsplit(strtrim(pair{2}), ' ');
      if size(vals, 2) < 3
        error('could not get element spacing');
      end
      spacing(1) = str2double(vals(1));
      spacing(2) = str2double(vals(2));
      spacing(3) = str2double(vals(3)); 
      
   case 'elementtype'
     val = lower(strtrim(pair{2}));
     if strcmp(val, 'met_uchar')
       pixelTransform = 'uchar=>uchar';
     elseif strcmp(val, 'met_short')
       pixelTransform = 'int16=>uchar';
     elseif strcmp(val, 'met_ushort')
       pixelTransform = 'uint16=>uchar';
     else
       error(['element type ', val, ' not implemented']);
     end

   case 'elementdatafile'
      val = lower(strtrim(pair{2}));
      if strcmp(val, 'local')
        %done reading header, the next line is the start of the raw data
        rawDataStart = true;
      else
        error(['element data file of type ', val, ' not implemented yet']);
      end
  end
end

%% read raw data
sizeA = dimX*dimY*dimZ;
rawSingleDim = fread(fid, sizeA, pixelTransform);  
raw = reshape(rawSingleDim, [dimX, dimY, dimZ]);
raw = permute(raw, [3 2 1]);

fclose(fid);


end

