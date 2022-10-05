function info = editorDicomInfo4che3(fileInput)
%function info = editorDicomInfo4che3(fileInput)
%Return a Structure Of Some DICOM Header Fields.
%See dicomMultiFilesEditor.doc (or pdf) for more information about options.
%
%Note: option settings must fit on one line and can contain one semicolon at most.
%Options can be strings, cell arrays of strings, or numerical arrays.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2020, Daniel Lafontaine, on behalf of the dicomMultiFilesEditor development team.
% 
% This file is part of The DICOM Multi-Files Editor (dicomMultiFilesEditor).
% 
% dicomMultiFilesEditor development has been led by: Daniel Lafontaine
% 
% dicomMultiFilesEditor is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of dicomMultiFilesEditor is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% dicomMultiFilesEditor is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with dicomMultiFilesEditor.  If not, see <http://www.gnu.org/licenses/>.

    try 
        din = org.dcm4che3.io.DicomInputStream(...
                java.io.BufferedInputStream(java.io.FileInputStream(char(fileInput))));    
    catch 
       info = ''; 
       return;
    end  

    dataset = din.readDataset(-1, -1);        

    info.PatientName           = char(dataset.getString(org.dcm4che3.data.Tag.PatientName, 0));
    info.PatientID             = char(dataset.getString(org.dcm4che3.data.Tag.PatientID, 0));

    info.InstanceNumber        = dataset.getInt(org.dcm4che3.data.Tag.InstanceNumber, 0);

    info.PatientPosition         = char(dataset.getStrings(org.dcm4che3.data.Tag.PatientPosition));      
    info.ImagePositionPatient    = dataset.getDoubles(org.dcm4che3.data.Tag.ImagePositionPatient);
    info.ImageOrientationPatient = dataset.getDoubles(org.dcm4che3.data.Tag.ImageOrientationPatient);   
       
    info.SeriesInstanceUID     = char(dataset.getString(org.dcm4che3.data.Tag.SeriesInstanceUID, 0));
    info.StudyInstanceUID      = char(dataset.getString(org.dcm4che3.data.Tag.StudyInstanceUID, 0));

    info.AccessionNumber       = char(dataset.getString(org.dcm4che3.data.Tag.AccessionNumber, 0));

end