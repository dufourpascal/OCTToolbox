function [ octRaw ] = rawVolumeFromGIPL( path, type, labelIds, labelColorsRGB )
%load a raw oct or segmentation from a gipl file.
%
%   Use the full path to a .gipl file.
%   type can be 'double' (preferred for oct)
%   or 'uint8' (preferred for segmentations).
%   The output raw volume has format [sz, sy, sx]
%
%   A segmentation can also be directly converted to RGB or RGBA format.
%   In that case set the type to 'rgb' or 'rgba' and specify the labelIds
%   (of size [nLabels 1], mapping the values in the gipl file to label ids)
%   and labelColors (of size [nLabels, 3], mapping the label ids to RGB
%   colors. The resulting 4d volume will then be of type double.

%% make sure the arguments are in the correct format
validatestring(type,{'double','uint8','rgb','rgba'},'rawVolumeFromGIPL','type',2);

if strcmp(type, 'rgb') || strcmp(type, 'rgba')
  if nargin < 4
    error(['Cannot create raw volume of type ', type, ' without labelIds and labelColors argument']);
  end
  if size(labelIds,1) ~= size(labelColorsRGB,1)
    error(['Size mismatch between labelIds (', num2str(size(labelIds,1)), ...
      ') and labelColors (', num2str(size(labelColorsRGB,1)), ').']);
  end
end

%% read the gipl file and put into correct order
octGipl = gipl_read_volume(path);
octGipl = permute(octGipl,[3 2 1]);
[sz, sy, sx] = size(octGipl);

%% convert to requested format 
switch type
  case 'double'
    octRaw = double(octGipl);
  case 'uint8'
    octRaw = uint8(octGipl);
  case {'rgb','rgba'}
    %% map label indices to RGB colors
    octR = zeros(sz,sy,sx, 'double');
    octG = zeros(sz,sy,sx, 'double');
    octB = zeros(sz,sy,sx, 'double');
    
    nLabels = size(labelIds,1);
    for l = 1:nLabels
      indLabels = find(octGipl == labelIds(l));
      octR(indLabels) = labelColorsRGB(l,1);
      octG(indLabels) = labelColorsRGB(l,2);
      octB(indLabels) = labelColorsRGB(l,3);
    end
    
    if strcmp(type,'rgb');
      octRaw = zeros(sz,sy,sx,3);
    elseif strcmp(type,'rgba');
      octRaw = zeros(sz,sy,sx,4);
      octRaw(:,:,:,4) = 0.5;
    end
    
    octRaw(:,:,:,1) = octR(:,:,:);
    octRaw(:,:,:,2) = octG(:,:,:);
    octRaw(:,:,:,3) = octB(:,:,:);
    
end

end
