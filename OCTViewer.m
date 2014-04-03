classdef OCTViewer < handle
  %OCTVIEWER Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    ParentPanel
    Axis
    TestLabel
  end
  
  methods
    
    function obj = OCTViewer(parent)
      obj.ParentPanel = parent;
      
      obj.Axis = axes('Parent', obj.ParentPanel, ...
                      'Units', 'pixels');
      obj.TestLabel = uicontrol(obj.ParentPanel, 'Style', 'text', 'String', 'test');
      obj.resize();
    end
    
    function showBScan(obj, octScan, bScanIndex)
      octDim = octScan.getDimensions();
      if octDim(1) >= bScanIndex
%         disp('displaying bscan');
        axes(obj.Axis);
        img = octScan.bScans{bScanIndex}.image;
        imshow(img, []);
        set(obj.TestLabel, 'String', ['BScan: ', num2str(bScanIndex)]);
      else
        disp(['bscan index ', num2str(bScanIndex), ' out of range. ', ...
              'OCT has only', num2str(octDim(1)), ' B-scans']);
      end
    end
    
    function resize(obj)
      disp('resizing OCTViewer');
      
      position = getpixelposition(obj.ParentPanel);
      position = position + [ 0 -14 -6 -18 ];
      setpixelposition(obj.Axis, position);
      
      
    end
    
  end
  
end

