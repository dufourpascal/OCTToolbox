function [ rawNormalized ] = normalizeBScans( rawVolume )
%NORMALIZEBSCANS Summary of this function goes here
%   Detailed explanation goes here

rawNormalized = double(rawVolume);
[~, ~, sz] = size(rawVolume);

allOnes = ones(101);
sumOnes = sum(sum(allOnes));
allOnes = allOnes ./sumOnes;

for z = 1:sz
  bScan = im2double(squeeze(rawVolume(:,:,z)));
  bScanMean = imfilter( bScan, allOnes, 'same', 'replicate');
  rawNormalized(:,:,z) = bScan - bScanMean;
end

