classdef OCTScan
  %OCT C-Scan class
  %  Represents a C-Scan with multiple B-Scans.
  %  This class should be used to represent an OCT.
  %  It contains meta-information such as patient name and birthdate,
  %  examination date, fixation target, as well as additional OCT specific
  %  data, e.g. the localizer image and name.
  
  properties
    patientName;
    birthdate;
    patientId;
    seriesId;
    bScans; %list of BScan objects
    localizer; %Localizer object
    laterality;
    examDate;
    oopSpacing
  end
  
  methods
    
    function obj = OCTScan(patientName) %constructor
      if nargin > 0
        obj.patientName = patientName;
      else
        obj.patientName = 'No Name';
      end
      
      obj.oopSpacing = 0.114;
    end
    
    
    function dim = getDimensions(oct)
      %returns the dimension of the oct in [z,y,x] coords
      dimZ = size(oct.bScans,1);
      if dimZ == 0
        dim = [0 0 0]; %no bscans -> no dimension
      else
        img = oct.bScans{1}.image;
        dimYX = size(img);
        dim = [dimZ dimYX ];
      end
    end
    
    
    function spacing = getSpacing(oct)
      spacingBscan = oct.bScans{1}.spacing;
      spacing = [oct.oopSpacing, spacingBscan(1), spacingBscan(2)];
    end
    
    
    function slice = getRawSlice(oct, plane, index, type)
      %Returns a single 2d slice
      %   index is the slice number
      %   plane can be 'inplane' (BScan), 'outofplane' or 'enface'
      %   type can be 'double' (default) or 'uint8'
            
      if ~strcmp(type,'double') && ~strcmp(type, 'uint8')
        warning(['Cannot handle pixel type ', type, ', reverting to type double']);
      end
      dim = oct.getDimensions();
      nz = dim(1); ny = dim(2); nx = dim(3);
      
      if strcmp(plane, 'enface')
        %% handle en-face plane
        if index > ny
          error(['Cannot get slice ', num2str(index), ', maximum is ', num2str(ny)]);
        end
        
        slice = zeros(nz,nx, type);
        for z = 1:nz
          slice(z,:) = squeeze(oct.bScans{z}.image(index,:));
        end
        
      elseif strcmp(plane, 'outofplane')
        %% handle out-of-plane
        if index > nx
          error(['Cannot get slice ', num2str(index), ', maximum is ', num2str(nx)]);
        end
        
        slice = zeros(ny,nz, type);
        for z = 1:nz
          slice(:,z) = squeeze(oct.bScans{z}.image(:,index));
        end
      
      else
        %% handle in-plane
        if ~strcmp(plane, 'inplane')
          warning(['Cannot handle plane type ', plane, ', reverting to inplane']);
        end
        
        if index > ny
          error(['Cannot get slice ', num2str(index), ', maximum is ', num2str(ny)]);
        end
        
        slice = zeros(ny,nx, type);
        slice(:,:) = squeeze(oct.bScans{index}.image);
      end
    end
    
    
    function volumeMatrix = getRawVolume(oct, type)
      %Returns the OCT data as a 3d volume
      %type can be 'double' (default) or 'uint8'
      octDim = getDimensions(oct);
      
      if nargin < 2
        type = 'double';
      end
      
      if ~strcmp(type,'double') && ~strcmp(type, 'uint8')
        warning(['Cannot handle pixel type ', type, ', reverting to type double']);
      end
      
      volumeMatrix = zeros(octDim, type);
      for b = 1:octDim(1)
        if strcmp(type, 'double')
          volumeMatrix(b,:,:) = im2double(oct.bScans{b}.image);
        elseif strcmp(type,'uint8')
          volumeMatrix(b,:,:) = oct.bScans{b}.image;
        end
          
      end
    end
    
    
  end
  
end


