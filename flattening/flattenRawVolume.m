function [ flattenedVol ] = flattenRawVolume( rawVol )
%FLATTENRAWVOLUME Summary of this function goes here
%   Detailed explanation goes here

pixelType = class(rawVol)
[sz sy sx] = size(rawVol);
flattenedVol = zeros([sz sy sx], pixelType);
tmpVol = zeros([sz sy sx], pixelType);

yRange = 64;

for b = 1:sz
    disp(['bscan ', num2str(b)]);
    for a = 1:sx
        
        sumPixels = sum(rawVol(b,1:yRange, a));
        tmpVol(b, yRange/2,a) = sumPixels;
        for y = 2:sy-yRange
            sumPixels = sumPixels - rawVol(b,y-1,a) + rawVol(b,y+yRange,a);
            tmpVol(b, y+yRange/2, a) = sumPixels;
        end
    end
end

flattenedVol = tmpVol;

end

