function [ convImgs ] = convolute2dImage( image2d, filterbank )
%Convolute 2d BScan image with a filter bank
%   The image should be of type double.
%   The filterbank should be of size [filterDim, filterDim, nFilters]
%   and type double.
%   The returned 3d image has dimensions [filterNumber, Y,X]

[~,~,fn] = size(filterbank);
[iy,ix] = size(image2d);

if ~isa(image2d, 'double')
  warning(['Filtering image of type ', class(image2d), ', but expecting type double']);
end

convImgs = zeros(fn,iy,ix, 'double');

% t = cputime; 
for f = 1:fn
  convImgs(f,:,:) = imfilter(image2d, squeeze(filterbank(:,:,f)));
end
% e = cputime-t;
% disp(['time filtering: ', num2str(e)]);

end

