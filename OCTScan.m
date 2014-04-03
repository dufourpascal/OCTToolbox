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
    
    
    function volumeMatrix = getRawVolume(oct)
      %returns the OCT data as a 3d volume
      octDim = getDimensions(oct);
      volumeMatrix = zeros(octDim);
      for b = 1:octDim(1)
        volumeMatrix(b,:,:) = oct.bScans{b}.image;
      end
    end
    
    
  end
  
end


