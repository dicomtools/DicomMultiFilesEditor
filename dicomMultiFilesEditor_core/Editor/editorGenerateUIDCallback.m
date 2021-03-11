function editorGenerateUIDCallback(~, ~)
%function editorGenerateUIDCallback(~, ~)
%Generate a New UID, Call From ui Menu.
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

    dScreenSize  = get(groot, 'Screensize');
    dDlgPosition = get(dlgEditorWindowsPtr('get'),'position');

    xSize     = dScreenSize(3) * dDlgPosition(3); 
    xPosition = dScreenSize(3) * dDlgPosition(1) + ((xSize /2)-250);

    ySize     = dScreenSize(4) * dDlgPosition(4); 
    yPosition = dScreenSize(4) * dDlgPosition(2) + ((ySize /2)-200);

    dlgUID = ...
        dialog('Position', [xPosition ...
                            yPosition ...
                            500 ...
                            100 ...
                            ],...
               'Color', editorBackgroundColor('get'), ...
               'Name'    , 'DICOM UID "Highlight the UID to copy"'...
               );

    lbUID = ...
        uicontrol(dlgUID,...
                  'style'   , 'listbox',...
                  'Units'   , 'normalized',...
                  'position', [0 0.30 1 0.70],...
                  'FontSize', 9,... 
                  'Fontname', 'Monospaced',... 
                  'Value'   , 1,... 
                  'Selected', 'on',...
                  'BackgroundColor', editorLbBackgroundColor('get'), ...
                  'ForegroundColor', editorLbForegroundColor('get'), ...                   
                  'Callback', @lbUIDCallback...
                  );

        uicontrol(dlgUID,...
                  'Position', [296 4 100 25],...
                  'String'  , 'Generate UID',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                         
                  'Callback', @generateDICOMUID...
                  );         

        uicontrol(dlgUID,...
                  'Position', [398 4 100 25],...
                  'String'  , 'Copy',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                        
                  'Callback', @copyClipBoard...
                  );     
              
    generateDICOMUID();

%        if editorIntegrateToBrowser('get') == true
%            sLogo = './dicomMultiFilesEditor/logo.png';
%        else
%            sLogo = './logo.png';
%        end

%        javaFrame = get(dlgUID,'JavaFrame');
%        javaFrame.setFigureIcon(javax.swing.ImageIcon(sLogo));    


    function lbUIDCallback(~, ~)

        persistent dChk

        if isempty(dChk)
              dChk = 1;
              pause(0.5); % Add a delay to distinguish single click from a double click
              if (dChk == 1) % Single click!              
                  dChk = [];
              end
        else % Double click!
              dChk = [];   

              copyClipBoard();                  
        end
    end

    function copyClipBoard(~, ~)

        dLbUIDOffsetValue = get(lbUID,'Value');

        if ((dLbUIDOffsetValue == 2)||(dLbUIDOffsetValue == 4)) 

            stLbUIDListValues = cellstr(get(lbUID,'string'));

            sLbUIDselectedItems = stLbUIDListValues{dLbUIDOffsetValue};
            clipboard('copy', sLbUIDselectedItems);    

            delete(dlgUID);              
        end   

    end    

    function generateDICOMUID(~, ~)

        sUID = sprintf('Study Instance UID:\n%s\nSeries Instance UID:\n%s',... 
            dicomuid, dicomuid);

        set(lbUID,'string', sUID);
    end   

end

