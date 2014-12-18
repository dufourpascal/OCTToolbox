function [ ] = writeSegmentationMetaImage( segmentation, path )
%WRITESEGMENTATIONMETAIMAGE Summary of this function goes here
%   Detailed explanation goes here


[dimZ,dimY,dimX] = size(segmentation);


miHeader = 'ObjectType = Image\n';
miHeader = [miHeader, 'NDims = 3\n'];
miHeader = [miHeader, 'BinaryData = true\n'];
miHeader = [miHeader, 'BinaryDataByteOrderMSB = False\n'];
miHeader = [miHeader, 'CompressedData = False\n'];
miHeader = [miHeader, 'TransformMatrix = 1 0 0 0 1 0 0 0 1\n'];
miHeader = [miHeader, 'Offset = 0 0 0\n'];
miHeader = [miHeader, 'CenterOfRotation = 0 0 0\n'];
miHeader = [miHeader, 'AnatomicalOrientation = RAI\n'];


miHeader = [miHeader, 'ElementSpacing = 0.0112 0.0039 0.114\n'];
miHeader = [miHeader, 'DimSize = ', num2str(dimX), ' ', ...
                                    num2str(dimY), ' ', ...
                                    num2str(dimZ), '\n'];
miHeader = [miHeader, 'ElementType = MET_UCHAR\n'];
miHeader = [miHeader, 'ElementDataFile = LOCAL\n'];
miHeader = sprintf(miHeader);
segmentationReordered = permute(segmentation, [3,2,1]);

disp(path)
fid = fopen( path, 'w+');
fwrite(fid,miHeader);
fwrite(fid, segmentationReordered, 'uchar');
fclose(fid);

disp(['Exported OCT as MetaImage to ', path]);

end

