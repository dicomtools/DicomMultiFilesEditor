function editorSearchTagCallback(~, ~)      
%function editorSearchTagCallback(~, ~)
%Search For a Specific Value, Call From ui Menu.
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

   persistent iLastIndex;
   persistent sLastValue;

   sValue = get(edtEditorFindValuePtr('get'), 'String');

   if ~strcmpi(sLastValue, sValue)
       iLastIndex = 1;      
   else
       iLastIndex = get(lbEditorMainWindowPtr('get'), 'Value');
   end              

   sBuffer = cellstr(get(lbEditorMainWindowPtr('get'), 'String'));

   lIndex = contains(sBuffer, sValue, 'IgnoreCase', true);

    for i=1+iLastIndex:numel(lIndex)
        if ~(lIndex(i) == 0)
            set(lbEditorMainWindowPtr('get'), 'Value', i);
            break;
        end    
    end                            

    sLastValue = sValue;
end