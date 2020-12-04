function editorResizeDialog(hObject, ~)
%function editorResizeDialog(hObject, ~)
%Resize Editor Dialog Main Window.
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

    dScreenSize  = get(groot  , 'Screensize');
    dDlgPosition = get(hObject, 'position'  );

    dDialogSize = dScreenSize(4) * dDlgPosition(4); 
    yPosition   = dDialogSize - 30;

    xSize = dScreenSize(3) * dDlgPosition(3); 
    ySize = dDialogSize - 30;                       

    if ~isempty(uiEditorMainWindowPtr('get'))
        set(uiEditorMainWindowPtr('get'), ...
            'position', [0 ...
                         30 ...
                         xSize ...
                         ySize-30 ...
                         ] ...
           );
    end

    if ~isempty(uiEditorProgressWindowPtr('get'))
        set(uiEditorProgressWindowPtr('get'), ...
            'position', [0 ...
                         0 ...
                         xSize ...
                         30 ...
                         ] ...
           );
    end           

    if ~isempty(lbEditorFilesWindowPtr('get'))

        uiMainWindow = uiEditorMainWindowPtr('get');
        set(lbEditorFilesWindowPtr('get'), ...
            'position', [0 ...
                         20 ...
                         250 ...
                         uiMainWindow.Position(4)-30-20 ...
                        ] ...
           );
    end

    if ~isempty(lbEditorMainWindowPtr('get'))

        uiMainWindow = uiEditorMainWindowPtr('get');
        set(lbEditorMainWindowPtr('get'), ...
            'position', [250 ...
                         0 ...
                         uiMainWindow.Position(3)-250 ...
                         uiMainWindow.Position(4)-30 ...
                         ] ...
           );
    end        

    if ~isempty(btnEditorOpenPtr('get'))
        set(btnEditorOpenPtr('get'), ...
            'position', [5 ...
                         yPosition ...
                         100 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorWriteHeaderPtr('get'))
        set(btnEditorWriteHeaderPtr('get'), ...
            'position', [106 ...
                         yPosition ...
                         100 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorOptionsPtr('get'))
        set(btnEditorOptionsPtr('get'), ...
            'position', [207 ...
                         yPosition ...
                         100 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorGenUIDPtr('get'))
        set(btnEditorGenUIDPtr('get'), ...
            'position', [317 ...
                         yPosition ...
                         100 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorSaveHeaderPtr('get'))
        set(btnEditorSaveHeaderPtr('get'), ...
            'position', [418 ...
                         yPosition ...
                         100 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(edtEditorFindValuePtr('get'))
        set(edtEditorFindValuePtr('get'), ...
            'position', [xSize-360 ...
                         yPosition+1 ...
                         200 ...
                         23 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorSearchTagPtr('get'))
        set(btnEditorSearchTagPtr('get'), ...
            'position', [xSize-160 ...
                         yPosition ...
                         50 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorHelpPtr('get'))
        set(btnEditorHelpPtr('get'), ...
            'position', [xSize-106 ...
                         yPosition ...
                         50 ...
                         25 ...
                         ] ...
           );
    end

    if ~isempty(btnEditorAboutPtr('get'))
        set(btnEditorAboutPtr('get'), ...
            'position', [xSize-55 ...
                         yPosition ...
                         50 ...
                         25 ...
                         ] ...
           );
    end                
end