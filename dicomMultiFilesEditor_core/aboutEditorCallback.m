function aboutEditorCallback(~, ~)
%function aboutEditorCallback(~, ~)
%Display About Editor.
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

    % sRootPath  = editorRootPath('get');
    % 
    % % msgbox(sRootPath)
    % sAboutFile = sprintf('%s/about.txt', sRootPath);
    % 
    % sDisplayBuffer = '';
    % fFileID = fopen(sAboutFile,'r');
    % if~(fFileID == -1)
    %     tline = fgetl(fFileID);
    %     while ischar(tline)
    %         sDisplayBuffer = sprintf('%s%s\n', sDisplayBuffer, tline);
    %         tline = fgetl(fFileID);
    %     end
    %     fclose(fFileID);            
    % 
    %     editorDisplayMessage(sDisplayBuffer);            
    % end   

    sRootPath  = editorRootPath('get');
    sAboutFile = sprintf('%s/about.txt', sRootPath);

    sDisplayBuffer = '';

    % Open the file for reading
    fFileID = fopen(sAboutFile, 'r');
    if fFileID == -1
        % If the file couldn't be opened, display a warning and exit
        warning('Could not open file: %s', sAboutFile);
        return;
    end
    
    dNbLines = 0;
    % Read the file line by line
    tline = fgetl(fFileID);
    while ischar(tline)
        % Append the line to the display buffer
        sDisplayBuffer = sprintf('%s%s\n',sDisplayBuffer, tline);  % More efficient string concatenation
        tline = fgetl(fFileID);

        dNbLines = dNbLines+1;
    end
    
    % Close the file after reading
    fclose(fFileID);

    % % Show the content in a message box
    % h = msgbox(sDisplayBuffer, 'About','help');

    xSize = 420;
    ySize = round(27*dNbLines);

    dScreenSize  = get(groot  , 'Screensize');
    dDlgPosition  =get(dlgEditorWindowsPtr('get'),'position');

    xDialogPosition = dScreenSize(1) * dDlgPosition(1); 
    yDialogPosition = dScreenSize(2) * dDlgPosition(2);
    xDialogSize = dScreenSize(3) * dDlgPosition(3); 
    yDialogSize = dScreenSize(4) * dDlgPosition(4); 
  

    dlgAbout = ...
        uifigure('Position', [(xDialogPosition+(xDialogSize/2)-xSize/2) ...
                              (yDialogPosition+(yDialogSize/2)-ySize/2) ...
                              xSize ...
                              ySize ...
                             ],...
               'Resize'     , 'off', ...
               'Color'      , editorBackgroundColor('get'),...
               'WindowStyle', 'modal', ...
               'Name'       , 'About'...
               );

    sRootPath = editorRootPath('get');
            
    if ~isempty(sRootPath) 
                    
        dlgAbout.Icon = fullfile(sRootPath, 'logo.png');
    end

    aDlgPosition = get(dlgAbout, 'Position');

    uicontrol(dlgAbout,...
              'String','OK',...
              'Position',[(aDlgPosition(3)/2)-(75/2) 7 75 25],...
              'BackgroundColor', editorBackgroundColor('get'), ...
              'ForegroundColor', editorForegroundColor('get'), ...               
              'Callback', @okAboutCallback...
              );   

    % Display text with line breaks
    uicontrol(dlgAbout, ...
              'Style'   , 'text', ...
              'HorizontalAlignment','left', ...
              'String'  , sDisplayBuffer, ...
              'Position', [10 40 aDlgPosition(3)-20 aDlgPosition(4)-50], ... % Adjusted padding              'HorizontalAlignment', 'left', ...
              'BackgroundColor', editorBackgroundColor('get'), ...
              'ForegroundColor', editorForegroundColor('get'),...
              'FontSize', 10, ...
              'FontName', 'Arial');
    
    drawnow;

    function okAboutCallback(~, ~)

        delete(dlgAbout);
    end    
end 