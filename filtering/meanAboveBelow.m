function [ meanImgAbove, meanImgBelow ] = meanAboveBelow( img2d )
%TODO description

[ny,nx] = size(img2d);
type = class(img2d);

cImg = cumsum(img2d,1); %cumulative image
cImgFlipped = cumsum(flipud(img2d),1);

mask = zeros(ny,nx, type);
for x = 1:nx
  mask(:,x) = 1:ny;
end

meanImgAbove = cImg ./ mask;
meanImgBelow = flipud( cImgFlipped ./ mask );

end
