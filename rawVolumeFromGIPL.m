function [ octRaw ] = rawVolumeFromGIPL( path, type )
%load a raw oct or segmentation from a gipl file.
%   Use the full path to a .gipl file.
%   type can be 'double' (preferred for oct) or 'uint8' (preferred for segmentations)

if ~strcmp(type, 'double') && ~strcmp(type, 'uint8')
  warning(['trying to create type ', type, ', but only double or uint8 are supported']);
end

octGipl = gipl_read_volume(path);

[sx, sy, sz] = size(octGipl)
octRaw = zeros(sz,sy,sx, type);

for z = 1:sz
  if strcmp(type, 'double')
    octRaw(z,:,:) = double(squeeze(octGipl(:,:,z))') ./ 255;
  elseif strcmp(type, 'uint8')
    octRaw(z,:,:) = uint8(squeeze(octGipl(:,:,z))');
  else
    octRaw(z,:,:) = squeeze(octGipl(:,:,z))';
    warning(['handling bscan with type ', type]);
  end
end

end


