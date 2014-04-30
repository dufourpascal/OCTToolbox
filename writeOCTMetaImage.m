function [ ] = writeOCTMetaImage( oct, path )
%WRITEOCTMETAIMAGE Summary of this function goes here
%   Detailed explanation goes here

octRaw = oct.getRawVolume .* 255;
[dimZ,dimY,dimX] = size(octRaw);

miHeader = 'ObjectType = Image\n';
miHeader = [miHeader, 'NDims = 3\n'];
miHeader = [miHeader, 'BinaryData = true\n'];
miHeader = [miHeader, 'BinaryDataByteOrderMSB = False\n'];
miHeader = [miHeader, 'CompressedData = False\n'];
miHeader = [miHeader, 'TransformMatrix = 1 0 0 0 1 0 0 0 1\n'];
miHeader = [miHeader, 'Offset = 0 0 0\n'];
miHeader = [miHeader, 'CenterOfRotation = 0 0 0\n'];
miHeader = [miHeader, 'AnatomicalOrientation = RAI\n'];

spacing = oct.getSpacing;
miHeader = [miHeader, 'ElementSpacing = ', num2str(spacing(3)), ' ', ...
                                           num2str(spacing(2)), ' ', ...
                                           num2str(spacing(1)), '\n'];
miHeader = [miHeader, 'DimSize = ', num2str(dimX), ' ', ...
                                    num2str(dimY), ' ', ...
                                    num2str(dimZ), '\n'];
miHeader = [miHeader, 'ElementType = MET_UCHAR\n'];
miHeader = [miHeader, 'ElementDataFile = LOCAL\n'];
miHeader = sprintf(miHeader);


octReordered = permute(octRaw, [3,2,1]);

disp(path)
fid = fopen( path, 'w+');
fwrite(fid,miHeader);
fwrite(fid, octReordered, 'uchar');
fclose(fid);

disp(['Exported OCT as MetaImage to ', path]);

end

