classdef OCTViewer < handle
  %OCTVIEWER Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
    ParentPanel
    Axis
    TestLabel
    Slider
    PlaneSelectionGroup
    oct
    segVolume
    currentSlice
    currentPlane
    SliderSegAlpha
  end
  
  methods
    
    function obj = OCTViewer(parent, oct)
      obj.ParentPanel = parent;
      
      obj.Axis = axes('Parent', obj.ParentPanel, ...
        'Units', 'pixels');
      axis(obj.Axis, 'off');
      colormap(obj.Axis, 'Gray');
      obj.TestLabel = uicontrol(obj.ParentPanel, 'Style', 'text', 'String', 'test');
      
      obj.PlaneSelectionGroup = uibuttongroup('Parent', obj.ParentPanel, 'Title', 'Plane');
      uicontrol('Parent', obj.PlaneSelectionGroup, ...
        'Style','radiobutton','String','in-plane',...
        'pos',[10 45 80 20], ...
        'HandleVisibility','off');
      uicontrol('Parent', obj.PlaneSelectionGroup, ...
        'Style','radiobutton','String','out-of-plane',...
        'pos',[10 25 80 20], ...
        'HandleVisibility','off');
      uicontrol('Parent', obj.PlaneSelectionGroup, ...
        'Style','radiobutton','String','en-face',...
        'pos',[10 5 80 20], ...
        'HandleVisibility','off');
      set(obj.PlaneSelectionGroup,'SelectionChangeFcn',@obj.onPlaneChange);
      
      obj.Slider = uicontrol(obj.ParentPanel, 'Style', 'slider', ...
        'Enable', 'off', 'SliderStep', [1 0.05], ...
        'Units', 'pixels', ...
        'Max', 1, 'Min', 0, 'Value', 1);
      
      lh = addlistener(obj.Slider, 'ContinuousValueChange', @obj.onSlide);
      setappdata(obj.Slider,'sliderListener',lh);
      
      obj.SliderSegAlpha = uicontrol(obj.ParentPanel, 'Style', 'slider', ...
        'Enable', 'on', 'SliderStep', [1 0.01], ...
        'Units', 'pixels', ...
        'pos', [160 100 300 15], ...
        'Max', 1, 'Min', 0, 'Value', 1);
      lhsa = addlistener(obj.SliderSegAlpha, 'ContinuousValueChange', @obj.onSlideAlpha);
      setappdata(obj.SliderSegAlpha,'sliderListener',lhsa);
      
      obj.currentPlane = 'inplane';
      
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
        
        obj.setSlice(1, 'inplane');
      end
      
      obj.resize();
    end
    
    
    function setOCT(obj, oct)
      obj.oct = oct;
      
      octDim = obj.oct.getDimensions();
      sliderStep = octDim(1)-1;
      if sliderStep > 0
        set(obj.Slider, 'Max', octDim(1), 'Min', 1, 'Enable', 'on', ...
          'SliderStep', [1/sliderStep 0.05]);
      else
        set(obj.Slider, 'Max', octDim(1), 'Min', 1, 'Enable', 'off');
      end
      obj.setSlice(1, 'inplane')
    end
    
    
    function setSegmentation(obj, segVolumeRGBA)
      %set a raw volume as the segmentation of the corresponding oct
      %   the segmentation volume has to be a 4 dimensional matrix
      %   of the format [sz,sy,sx, RGBA], double type.
      
      obj.segVolume = segVolumeRGBA;
      obj.setSlice(obj.currentSlice, obj.currentPlane);
    end
    
    
    function setSlice(obj, sliceIndex, plane)
      if  isempty(obj.oct)
        disp('oct is not set');
        return %oct has not been assigned yet
      end
      
      spacing = obj.oct.getSpacing();
      octDim = obj.oct.getDimensions();
      
      if ~strcmp(obj.currentPlane, plane)
        obj.resetSlider(plane);
        obj.resizeAxes(plane)
      end
      
      switch plane
        case 'inplane'
          if sliceIndex > octDim(1)
            warning('slice index out of bounds');
            return;
          end
          viewerSpacingY = spacing(2);
          viewerSpacingX = spacing(3);
        case 'outofplane'
          if sliceIndex > octDim(3)
            warning('slice index out of bounds');
            return;
          end
          viewerSpacingY = spacing(2);
          viewerSpacingX = spacing(1);
        case 'enface'
          if sliceIndex > octDim(2)
            warning('slice index out of bounds');
            return;
          end
          viewerSpacingY = spacing(1);
          viewerSpacingX = spacing(3);
        otherwise
          error(['Cannot handle plane ', plane, '.']);
      end
      
      rawSlice = obj.oct.getRawSlice(plane, sliceIndex, 'uint8');
      imgDim = size(rawSlice);
      aspectXY = viewerSpacingX/viewerSpacingY;
      
      
      imagesc([1 imgDim(2)], [1 imgDim(1)*aspectXY], rawSlice, 'Parent', obj.Axis)
      
      %% set segmentation
      if ~isempty(obj.segVolume)
        %get raw slice of segmentation
        switch plane
          case 'inplane'
            rawSegSlice = squeeze(obj.segVolume(sliceIndex,:,:,:));
          case 'outofplane'
            rawSegSlice = squeeze(obj.segVolume(:,:,sliceIndex,:));
            rawSegSlice = permute(rawSegSlice, [2 1 3]);
          case 'enface'
            rawSegSlice = squeeze(obj.segVolume(:,sliceIndex,:,:));
          otherwise
            error(['Cannot handle plane ', plane, '.']);
        end
        
        %display overlay
        hold(obj.Axis, 'on');
        imgH = imagesc([1 imgDim(2)], [1 imgDim(1)*aspectXY], rawSegSlice(:,:,1:3), 'Parent', obj.Axis);
        set(imgH, 'AlphaData', rawSegSlice(:,:,4));
        hold(obj.Axis, 'off');
%         hold off;
      end
      
      axis(obj.Axis, 'off');
      set(obj.TestLabel, 'String', ['Slice: ', num2str(sliceIndex)]);
      
      obj.currentSlice = sliceIndex;
      set(obj.Slider, 'Value', sliceIndex);
    end
    
    
    function resetSlider(obj, plane)
      %set up slider
      octDim = obj.oct.getDimensions();
      
      switch plane
        case 'inplane'
          maxDim = octDim(1);
        case 'outofplane'
          maxDim = octDim(3);
        case 'enface'
          maxDim = octDim(2);
        otherwise
          error(['Cannot set plane to ', plane]);
      end
      
      if maxDim > 1
        sliderStep = [1/(maxDim-1) 0.05];
        set(obj.Slider, 'Max', maxDim, 'Min', 1, 'Enable', 'on', ...
          'SliderStep', sliderStep);
      else
        set(obj.Slider, 'Max', 1, 'Min', 1, 'Enable', 'off');
      end
    end
    
    
    function resizeAxes(obj, plane)
      %% keep aspect ratio
      position = getpixelposition(obj.ParentPanel);
      imgOffset = 100;
      spacing = obj.oct.getSpacing();
      octDim = obj.oct.getDimensions();
      
      switch plane
        case 'inplane'
          extentX = octDim(3)*spacing(3);
          extentY = octDim(2)*spacing(2);
          aspectXY = extentX/extentY;
        case 'outofplane'
          extentX = octDim(1)*spacing(1);
          extentY = octDim(2)*spacing(2);
          aspectXY = extentX/extentY;
        case 'enface'
          extentX = octDim(1)*spacing(1);
          extentY = octDim(3)*spacing(3);
          aspectXY = extentX/extentY;
      end
      maxWidth = position(3)-6;
      maxHeight = position(4)-imgOffset;
      imgWidth = maxHeight * aspectXY;
      
      if imgWidth > maxWidth %limit axis to view
        imgWidth = maxWidth;
        imgHeight = maxWidth / aspectXY;
      else
        imgHeight = maxHeight;
      end
      
      imgX = round(maxWidth - imgWidth) / 2;
      imgY = round(maxHeight - imgHeight) / 2 + imgOffset;
      
      setpixelposition(obj.Axis, [imgX imgY imgWidth imgHeight]);
    end
    
    
    function resize(obj)
      if isempty(obj.oct)
        disp('no oct set');
        return
      end
      position = getpixelposition(obj.ParentPanel);
      
      obj.resizeAxes(obj.currentPlane);
      
      %% slider
      sliderPosition = [ 10, 10, position(3)-20, 15 ];
      setpixelposition(obj.Slider, sliderPosition);
      
      %% plane selection
      planePanelPosition = [ 10, 45, 110, 80];
      setpixelposition(obj.PlaneSelectionGroup, planePanelPosition);
    end
    
    
    function onSlide(hObject, eventdata, handles)
      sliderVal = round(get(eventdata, 'Value'));
      set(eventdata, 'Value', sliderVal);
      if hObject.currentSlice ~= sliderVal
        radItem = get(hObject.PlaneSelectionGroup, 'SelectedObject');
        plane = strrep(get(radItem,'String'), '-', '');
        hObject.setSlice(sliderVal, plane);
      end
    end
    
    function onSlideAlpha(hObject, eventdata, handles)
      if isempty(hObject.segVolume)
        return; %no segmentation, so ignore
      end
      alpha = get(eventdata, 'Value');
      hObject.segVolume(:,:,:,4) = alpha;
      hObject.setSlice(hObject.currentSlice, hObject.currentPlane);
    end
    
    function onPlaneChange(hObject, eventdata, handles)
      planeMethod = get(get(eventdata,'SelectedObject'),'String');
      planeMethod = strrep(planeMethod, '-', '');
      hObject.setSlice(1, planeMethod);
      hObject.currentPlane = planeMethod;
    end
    
  end
  
end

