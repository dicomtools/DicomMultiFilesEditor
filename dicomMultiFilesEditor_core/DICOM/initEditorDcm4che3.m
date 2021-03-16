function initEditorDcm4che3()
%function initEditorDcm4che3()
%Init dcm4che Lib.
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

    checkjava = which('org.dcm4che2.io.DicomInputStream');
    if isempty(checkjava)

        sRootPath  = editorRootPath('get');
        libpath = sprintf('%s/lib/',sRootPath); 
        javaaddpath([libpath 'dcm4che-core-3.2.1.jar']);
        javaaddpath([libpath 'dcm4che-image-3.2.1.jar']);
        javaaddpath([libpath 'dcm4che-imageio-3.2.1.jar']);
         javaaddpath([libpath 'dcm4che-net-3.2.1.jar'])

        javaaddpath([libpath 'slf4j-api-1.6.1.jar']);
        javaaddpath([libpath 'slf4j-log4j12-1.6.1.jar']);
        javaaddpath([libpath 'log4j-1.2.16.jar']);
    end
end