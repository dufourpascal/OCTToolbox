function [ volume ] = segVolumeFromSurfaces( surfaces, height )
%SEGVOLUMEFROMSURFACES Summary of this function goes here
%   Detailed explanation goes here

[nSurfaces, sz, sx] = size(surfaces);
volume = zeros(sz,height,sx);
for z = 1:sz
  for x = 1:sx
    
    lastY = round(surfaces(1,z,x))-2;
    volume(z, 1:lastY ,x) = 1;
    for s = 2:nSurfaces
      y = round(surfaces(s,z,x))-2;
      volume(z,lastY:y,x) = s;
      lastY = y+1;
    end
    volume(z,lastY:height,x) = nSurfaces+1;
  end
end

