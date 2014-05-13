function [ ] = convertHeyexExportToMetaImage( heyexExportXMLPath )
%CONVERTHEYEXEXPORTTOMETAIMAGE Summary of this function goes here
%   Detailed explanation goes here

octH = readHeyexXMLExportOCT(heyexExportXMLPath);
oct = octFromHeyexExport(octH{1});
patname = strrep(oct.patientName, ' ', '');
[pathFolder,~,~] = fileparts(heyexExportXMLPath);
metaImagePath = [pathFolder, '/', patname, '.mha'];


writeOCTMetaImage(oct, metaImagePath);

end

