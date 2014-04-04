classdef OCTViewer < handle
  %OCTVIEWER Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    ParentPanel
    Axis
    TestLabel
    Slider
    oct
    currentBScan
  end
  
  methods
    
    function obj = OCTViewer(parent, oct)
      obj.ParentPanel = parent;
      
      obj.Axis = axes('Parent', obj.ParentPanel, ...
                      'Units', 'pixels');
      axis(obj.Axis, 'off');
      colormap(obj.Axis, 'Gray');
      obj.TestLabel = uicontrol(obj.ParentPanel, 'Style', 'text', 'String', 'test');
      obj.Slider = uicontrol(obj.ParentPanel, 'Style', 'slider', ...
                             'Enable', 'off', 'SliderStep', [1 0.05], ...
                             'Units', 'pixels', ...
                             'Max', 1, 'Min', 0, 'Value', 1);
      
      lh = addlistener(obj.Slider, 'ContinuousValueChange', @obj.onSlide);
      setappdata(obj.Slider,'sliderListener',lh);
            
      
      if nargin > 1
%         disp('setting oct');
        obj.oct = oct;
        
        %set up slider
        octDim = obj.oct.getDimensions();
        sliderStep = octDim(1)-1;
        if sliderStep > 0
          set(obj.Slider, 'Max', octDim(1), 'Min', 1, 'Enable', 'on', ...
                          'SliderStep', [1/sliderStep 0.05]);
        else
          set(obj.Slider, 'Max', octDim(1), 'Min', 1, 'Enable', 'off');
        end
        
        obj.setBScan(1);
      end
      
      obj.resize();
    end
    
    
    function setOCT(obj, oct, currentBScan)
      obj.oct = oct;
      
      if nargin > 2
        obj.showBScan(currentBScan)
      else
        obj.setBScan(1)
      end
    end
    
    
    function setBScan(obj, bScanIndex)
      if  isempty(obj.oct)
        disp('oct is not set');
        return %oct has not been assigned yet
      end
            
      octDim = obj.oct.getDimensions();
      if octDim(1) >= bScanIndex
%         disp('displaying bscan');

        
        bScan = obj.oct.bScans{bScanIndex};
        spacing = bScan.spacing;
        aspectYX = spacing(1)/spacing(2);
        
        img = bScan.image;
        imgDim = size(img);
        
        imagesc([1 imgDim(2)], [1 imgDim(1)*aspectYX], img, 'Parent', obj.Axis)
        
%         axis(obj.Axis, 'off');
      
        set(obj.TestLabel, 'String', ['BScan: ', num2str(bScanIndex)]);
        
        obj.currentBScan = bScanIndex;
        set(obj.Slider, 'Value', bScanIndex);
      else
        disp(['bscan index ', num2str(bScanIndex), ' out of range. ', ...
              'OCT has only', num2str(octDim(1)), ' B-scans']);
      end
    end
    
    
    function resize(obj)
%       disp('resizing OCTViewer');
      
      position = getpixelposition(obj.ParentPanel);
%       position = position + [ 0 50 -6 -18 ];
      
      %keep aspect ratio
      imgOffset = 60;
      spacing = obj.oct.bScans{obj.currentBScan}.spacing;
      aspectYX = spacing(1)/spacing(2);
      maxWidth = position(3)-6;
      maxHeight = position(4)-imgOffset;
%       imgHeight = position(4)-60;
      imgWidth = maxHeight * aspectYX;
      
      if imgWidth > maxWidth %limit axis to view
        imgWidth = maxWidth;
        imgHeight = maxWidth / aspectYX;
      else
        imgHeight = maxHeight;
      end
      
      imgX = round(maxWidth - imgWidth) / 2;
      imgY = round(maxHeight - imgHeight) / 2 + imgOffset;
      
      setpixelposition(obj.Axis, [imgX imgY imgWidth imgHeight]);
      
      sliderPosition = [ 10 10 position(3)-6 - 20, 15 ];
      setpixelposition(obj.Slider, sliderPosition);
      
    end
    
    
    function onSlide(hObject, eventdata, handles)
      sliderVal = round(get(eventdata, 'Value'));
      set(eventdata, 'Value', sliderVal);
      
      if hObject.currentBScan ~= sliderVal
        hObject.setBScan(sliderVal);
      end    
      
    end
    
  end
  
end

