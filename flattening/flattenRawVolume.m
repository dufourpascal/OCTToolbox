function [ flattenedVol, heightBMCoarse ] = flattenRawVolume( rawVol, surfaceBMEstimate )
%FLATTENRAWVOLUME Summary of this function goes here
%   Detailed explanation goes here

pixelType = class(rawVol)
[sz sy sx] = size(rawVol);
flattenedVol = zeros([sz sy sx], pixelType);

% yRange = 64;

meanBMY = int32(mean(mean(surfaceBMEstimate)));
heightBMCoarse = meanBMY;

for z = 1:sz
  disp(['bscan ', num2str(z)]);
  for x = 1:sx
    bmY = int32(surfaceBMEstimate(z,x));
    dBMY = bmY - meanBMY;
    if dBMY == 0
      flattenedVol(z, :,x) = rawVol(z, :, x);
    elseif dBMY < 0 %shift up
      flattenedVol(z, 1:-dBMY,x) = 0;
      flattenedVol(z, -dBMY+1:end,x) = rawVol(z, 1:end+dBMY, x);
    else % shift down
      flattenedVol(z, 1:end-dBMY+1, x) = rawVol(z, dBMY:end, x);
      flattenedVol(z, end-dBMY+1:end, x) = 0;
    end
      %         sumPixels = sum(rawVol(b,1:yRange, a));
      %         tmpVol(b, yRange/2,a) = sumPixels;
      %         for y = 2:sy-yRange
      %             sumPixels = sumPixels - rawVol(b,y-1,a) + rawVol(b,y+yRange,a);
      %             tmpVol(b, y+yRange/2, a) = sumPixels;
      %         end
  end
end

% flattenedVol = tmpVol;

end

