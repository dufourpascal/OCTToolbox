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
  end
  
  methods
    
    function obj = OCTScan(patientName) %constructor
      if nargin > 0
        obj.patientName = patientName;
      else
        obj.patientName = 'Not Initialized';
      end
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


