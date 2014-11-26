function [ convVolumes ] = convolute3dRawVolume( rawVolume, filterbank )
%Convolute 3d raw OCT volume with a filter bank
%   The rawVolume should be of type double.
%   The filterbank should be of size [filterDim, filterDim, nFilters]
%   and type double.
%   The returned 4d volume has dimensions [filterNumber, Z,Y,X]
%   NOTE: if the whole volume is filtered with a large filterbank like
%   this, the resulting 4d volume will be huge! E.g. a 49x512x496 volume
%   with 36 filters will be approximately 3.4 GB!

[~,~,fn] = size(filterbank);
[iz,iy,ix] = size(rawVolume);

if ~isa(rawVolume, 'double')
  warning(['Filtering raw volume of type ', class(rawVolume), ', but expecting type double']);
end

fprintf('filtering 3d volume');

convVolumes = zeros([fn, iz,iy,ix], 'double');

for b = 1:iz
  fprintf('.');
  img2d = squeeze(rawVolume(b,:,:));
  convImgs = convolute2dImage(img2d,filterbank);
  convVolumes(:,b,:,:) = convImgs;
end

