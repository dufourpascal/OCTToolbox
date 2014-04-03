classdef Localizer
  %LOCALIZER Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    image
    spacing
    name
    fixationTarget
  end
  
  methods
    
    function obj = Localizer(img, spacing) %constructor
      if nargin == 2
        obj.image = img;
        obj.spacing = spacing;
      elseif nargin == 1 %just image specified
        obj.image = img;
        obj.spacing = [1 1]; %default spacing
      end
    end
    
  end
  
end

