function [tFileList, iNbFiles] = editorGetDicomFileList(sDirName, tFileList)
%function [tFileList, iNbFiles] = editorGetDicomFileList(sDirName, tFileList)
%Return Series DICOM Files Name.
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

    iNbFiles = 0;

    f = java.io.File(char(sDirName));
    asFileList = f.listFiles();

    for iLoop=1:length(asFileList)

        editorProgressBar(iLoop / length(asFileList), 'Acquiring file list');

        if ~asFileList(iLoop).isDirectory               
            tInfo = editorDicomInfo4che3(asFileList(iLoop));

            if ~isempty(tInfo)

                dInstanceNumber = 0;
                adImagePositionPatient = [0 0 0];
                sFileName = asFileList(iLoop);

                if (isfield(tInfo,'InstanceNumber'))
                    if numel(tInfo.InstanceNumber)                        
                        dInstanceNumber = tInfo.InstanceNumber; 
                    end    
                end

                if (isfield(tInfo, 'ImagePositionPatient'))
                    if ~isempty(tInfo.ImagePositionPatient)
                        adImagePositionPatient = tInfo.ImagePositionPatient;  
                    end
                end

                iNbFiles = iNbFiles+1; 

                tFileList.FileName {iNbFiles}              = char(sFileName);
                tFileList.DicomInfo{iNbFiles}              = tInfo;
                tFileList.InstanceNumber(iNbFiles)         = dInstanceNumber;
                tFileList.ImagePositionPatient(iNbFiles,:) = adImagePositionPatient(:)';

            end
        end
    end

    editorProgressBar(1, 'Ready');

end