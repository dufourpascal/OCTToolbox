function [ surfaces ] = surfacesFromSegVolume( segVolume )
%SURFACEFROMSEGVOLUME Summary of this function goes here
%   Detailed explanation goes here

[sz, sy, sx] = size(segVolume);
nSurf = max(max(max(segVolume)));
surfaces = zeros(sz,sx,nSurf);

for z = 1:sz
  for x = 1:sx
    surfInd = 1;
    for y = 1:sy
      surfIndY = segVolume(z,y,x);
      dSurfInd = surfIndY - surfInd;
      
      while dSurfInd > 0 %surface changed
        surfaces(z,x,surfInd) = y+1;
        dSurfInd = dSurfInd-1;
        surfInd = surfInd+1;
      end
    end
  end
end

end

