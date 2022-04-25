function initEditorRootPath()
%function initEditorRootPath()
%Init editor root path.
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

    editorRootPath('set', '');
    
    if isdeployed 
        % User is running an executable in standalone mode. 
        [~, result] = system('set PATH');
        sRootDir = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
        if sRootDir(end) ~= '\' || ...
           sRootDir(end) ~= '/'     
            sRootDir = [sRootDir '/'];
        end         
        editorRootPath('set', sRootDir);
    else             
        sRootDir = pwd;
        if sRootDir(end) ~= '\' || ...
           sRootDir(end) ~= '/'     
            sRootDir = [sRootDir '/'];
        end   

        if isfile(sprintf('%sDICOMmultiFileEditor.png', sRootDir))
            editorRootPath('set', sRootDir);
        else
            if integrateToBrowser('get') == true
                if isfile(sprintf('%sdicomMultiFilesEditor_core/DICOMmultiFileEditor.png', sRootDir))
                    editorRootPath('set', sprintf('%sDICOMmultiFileEditor/', sRootDir) );
                end
            else    
                sRootDir = fileparts(mfilename('fullpath'));
                sRootDir = erase(sRootDir, 'dicomMultiFilesEditor_core');        

                if isfile(sprintf('%sDICOMmultiFileEditor.png', sRootDir))
                    editorRootPath('set', sRootDir);
                end
            end
        end    
    end
end