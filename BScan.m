classdef BScan
  %OCT B-Scan class
  %  Represents a single B-Scan of an OCT.
  %  Contains a 2D image, pixel spacing in micro-meter,
  %  quality (SNR) and the number of averaged frames.
  
  properties
    image;
    quality;
    nAveraged;
    spacing; %[x y] pixel spacing
    acquisitionDate %acquisition date and time in datenum format
  end
  
  methods
    function obj = BScan(img)
      if nargin > 0
        obj.image = img;
        obj.spacing = [1 1];
      end
    end
  end
  
end

