function [ oct ] = readOCTMetaImage( fileName )
%READOCTMETAIMAGE Summary of this function goes here
%   Detailed explanation goes here

[raw, spacing] = readRawMetaImage(fileName);
dim = size(raw);
spacing
bScans = cell(1,dim(3));

for z = 1:dim(3)
  bScans{z} = BScan( squeeze(raw(:,:,z))' );
  bScans{z}.spacing = [spacing(2), spacing(1)];
end  
  
oct = OCTScan();
oct.bScans = bScans;
oct.oopSpacing = spacing(3);

end

