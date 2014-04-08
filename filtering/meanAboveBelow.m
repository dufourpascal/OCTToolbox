function [ meanImgAbove, meanImgBelow ] = meanAboveBelow( img2d )
%TODO description

[ny,nx] = size(img2d);
type = class(img2d);

meanImgAbove = zeros(ny,nx, type);
meanImgBelow = zeros(ny,nx, type);

cImg = cumsum(img2d,1); %cumulative image

for y = 1:ny-1
  for x = 1:nx
    meanImgAbove(y,x) = cImg(y,x) / y;
    meanImgBelow(y,x) = (cImg(ny,x) - cImg(y,x)) / (ny-y+1);
  end
end

end
