function [ surface ] = surfaceFromSegVolume( segVolume, boundary )
%SURFACEFROMSEGVOLUME Summary of this function goes here
%   Detailed explanation goes here

[sz, sy, sx] = size(segVolume);
surface = zeros(sz,sx);

for z = 1:sz
  for x = 1:sx
    for y = 1:sy
      if segVolume(z,y,x) == boundary
        surface(z,x) = y;
        break;
      end
    end
  end
end

end

