function [ oct ] = octFromHeyexExport( octHeyex )
%Convert the read struct from a Heyex XML export to an OCTScan object

oct = OCTScan(octHeyex.patientName);
oct.birthdate = octHeyex.birthdate;
oct.patientId = octHeyex.patientId;
oct.seriesId = octHeyex.seriesId;
oct.laterality = octHeyex.laterality;

%bScans
[nBscans,~] = size(octHeyex.bScans);
oct.bScans = cell(nBscans,1);
for b = 1:nBscans
  bScanHeyex = octHeyex.bScans{b};
  bScan = BScan(bScanHeyex.image);
  bScan.spacing = bScanHeyex.spacing;
  bScan.acquisitionDate = bScanHeyex.acquisitionDate;
  bScan.quality = bScanHeyex.quality;
  bScan.nAveraged = bScanHeyex.nAveraged;
  oct.bScans{b} = bScan;
end

%localizer
localizerHeyex = octHeyex.localizer;
localizer = Localizer(localizerHeyex.image, localizerHeyex.spacing);
localizer.name = localizerHeyex.name;
localizer.fixationTarget = localizerHeyex.fixationTarget;
oct.localizer = localizer;


end

