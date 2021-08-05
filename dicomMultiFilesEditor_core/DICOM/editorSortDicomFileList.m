function tDataSets = editorSortDicomFileList(tFileList, iNbFiles)
%function tDataSets = editorSortDicomFileList(tFileList, iNbFiles)
%Return Sorted Dataset.
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

    iDataSetIDs = unique(tFileList.aHash(1:iNbFiles));

    for iLoop=1 : length(iDataSetIDs)

        h = find(tFileList.aHash(1:iNbFiles) == iDataSetIDs(iLoop));
        iInstanceNumbers=tFileList.InstanceNumber(h);
        aImagePositionPatient=tFileList.ImagePositionPatient(h,:);

        if(length(unique(iInstanceNumbers)) == length(iInstanceNumbers))
            [~, ind] = sort(iInstanceNumbers);
        else
            [~, ind] = sort(aImagePositionPatient(:,3));
        end

        h = h(ind);

        tDataSets(iLoop).FileNames  = cell(length(h),1);
        tDataSets(iLoop).DicomInfos = cell(length(h),1);

        endJloop = length(h);
        for jLoop=1:endJloop
            
            if mod(jLoop,5)==1 || jLoop == endJloop         
                editorProgressBar(jLoop / endJloop, sprintf('Sorting file list %d/%d', jLoop, endJloop) );
            end
            
            tDataSets(iLoop).FileNames{jLoop}    = tFileList.FileName{h(jLoop)} ;
            tDataSets(iLoop).DicomInfos{jLoop}   = tFileList.DicomInfo{h(jLoop)} ;
        end

        editorProgressBar(1, 'Ready');

    end
end