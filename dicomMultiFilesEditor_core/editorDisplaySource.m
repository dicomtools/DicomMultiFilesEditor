function editorDisplaySource(sDCMimg)
%function editorDisplaySource(sDCMimg)  
%Display DICOM Header.
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

    if (editorDefaultDict('get') == true)
        dicomdict('factory');  
    else    
        if (numel(editorCustomDict('get')))
            dicomdict('set', editorCustomDict('get'));   
        else
            editorDisplayMessage('Error: editorDisplaySource(), cannot set the DICOM dictionary!');
            editorProgressBar(1, 'Error: editorDisplaySource(), cannot set the DICOM dictionary!');
            return;
        end
    end  

    if numel(sDCMimg)
        try    
            set(lbEditorMainWindowPtr('get'), 'string', editorDicomDisplay(sDCMimg));
        catch
            editorDisplayMessage('Error: editorDisplaySource(), cannot display the source!');
            editorProgressBar(1, 'Error: editorDisplaySource(), cannot display the source!');
            return;
        end
    end           
end