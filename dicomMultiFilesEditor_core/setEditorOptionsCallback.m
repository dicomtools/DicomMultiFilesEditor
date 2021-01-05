function setEditorOptionsCallback(~, ~)
%function setEditorOptionsCallback(~, ~)
%Set Editor Options, Call From ui Menu.
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

    if editorMultiFiles('get') == true
        chkSaveHeaderEnable = 'on';
    else
        chkSaveHeaderEnable = 'off';
    end

    if editorSaveAllHeader('get') == true
        sAllHeader = 'off';
    else
        sAllHeader = 'on';
    end

    if editorDefaultPath('get') == true
        sDirEnable = 'off';
    else
        sDirEnable = 'on';
    end

    if editorDefaultDict('get') == true
        sDicEnable = 'off';
    else
        sDicEnable = 'on';
    end

    dScreenSize  = get(groot, 'Screensize');
    dDlgPosition = get(dlgEditorWindowsPtr('get'),'position');

    xSize     = dScreenSize(3) * dDlgPosition(3);
    xPosition = dScreenSize(3) * dDlgPosition(1) + ((xSize /2)-250);

    ySize     = dScreenSize(4) * dDlgPosition(4);
    yPosition = dScreenSize(4) * dDlgPosition(2) + ((ySize /2)-200);

    dlgOptions = ...
        dialog('Position', [xPosition ...
                            yPosition ...
                            460 ...
                            230 ...
                            ],...
               'Name','Options'...
               );

    chkAutoUID = ...
        uicontrol(dlgOptions,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , editorAutoSeriesUID('get'),...
                  'position', [20 200 20 20]...
                  );

    txtAutoUID = ...
        uicontrol(dlgOptions,...
                  'style'   , 'text',...
                  'string'  , 'Ovewrite series UID',...
                  'horizontalalignment', 'left',...
                  'position', [40 197 200 20]...
                  );

    txtAutoUID.Enable = 'Inactive';
    txtAutoUID.ButtonDownFcn = @autoUIDTxtCallback;

    % Multi or Single file(s) editor

    chkMultiFile = ...
        uicontrol(dlgOptions,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , editorMultiFiles('get'),...
                  'position', [20 170 20 20],...
                  'Callback', @checkBoxMultiFilesCallback...
                  );

    txtMultiFile = ...
        uicontrol(dlgOptions,...
                  'style'   , 'text',...
                  'string'  , 'Multi-Files Editor',...
                  'horizontalalignment', 'left',...
                  'position', [40 167 200 20]...
                  );

    txtMultiFile.Enable = 'Inactive';
    txtMultiFile.ButtonDownFcn = @multiFilesTxtCallback;


    % Save Header

    chkSaveHeader = ...
        uicontrol(dlgOptions,...
                  'style'   , 'checkbox',...
                  'enable'  , chkSaveHeaderEnable,...
                  'value'   , editorSaveAllHeader('get'),...
                  'position', [40 150 20 20],...
                  'Callback', @checkBoxSaveHeaderCallback...
                  );

    txtSaveHeader = ...
        uicontrol(dlgOptions,...
                  'style'   , 'text',...
                  'string'  , 'Save All Header',...
                  'horizontalalignment', 'left',...
                  'position', [60 147 200 20]...
                  );

     txtSaveHeader.Enable = 'Inactive';
     txtSaveHeader.ButtonDownFcn = @saveHeaderTxtCallback;

     edtSaveHeader = ...
         uicontrol(dlgOptions,...
                   'enable'    , sAllHeader,...
                   'style'     , 'edit',...
                   'Background', 'white',...
                   'string'    , editorSaveHeaderNumber('get'),...
                   'position'  , [200 147 200 20]...
                   );

    % Destination path

    chkDefTarget = ...
        uicontrol(dlgOptions,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , editorDefaultPath('get'),...
                  'position', [20 120 20 20],...
                  'Callback', @checkBoxDefaultPathCallback...
                  );

    txtDefTarget = ...
        uicontrol(dlgOptions,...
                  'style'   , 'text',...
                  'string'  , 'Default Destination Path',...
                  'horizontalalignment', 'left',...
                  'position', [40 117 200 20]...
                  );

    txtDefTarget.Enable = 'Inactive';
    txtDefTarget.ButtonDownFcn = @defaultPathTxtCallback;


        uicontrol(dlgOptions,...
                  'style'   , 'text',...
                  'string'  , 'Destination Path:',...
                  'horizontalalignment', 'left',...
                  'position', [20 97 100 20]...
                  );

    edtDirPath = ...
        uicontrol(dlgOptions,...
                  'enable'    , sDirEnable,...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , editorTargetDir('get'),...
                  'position'  , [200 100 200 20]...
                  );

    btnSetDirPath = ...
        uicontrol(dlgOptions,...
                  'enable'  , sDirEnable,...
                  'String'  , '...',...
                  'Position', [405 100 20 20],...
                  'Callback', @setDirPathCallback...
                  );

    % DICOM Dictionary

    chkDefDict = ...
        uicontrol(dlgOptions,...
                  'style'   , 'checkbox',...
                  'enable'  , 'on',...
                  'value'   , editorDefaultDict('get'),...
                  'position', [20 75 20 20],...
                  'Callback', @checkBoxPrivDictCallback...
                  );

    txtDefDict = ...
        uicontrol(dlgOptions,...
                  'style'   , 'text',...
                  'string'  , 'Default DICOM Dictionary',...
                  'horizontalalignment', 'left',...
                  'position', [40 72 200 20]...
                  );

    txtDefDict.Enable = 'Inactive';
    txtDefDict.ButtonDownFcn = @privDictTxtCallback;

        uicontrol(dlgOptions,...
                 'style'   , 'text',...
                 'string'  , 'Dictionary File:',...
                 'horizontalalignment', 'left',...
                 'position', [20 52 100 20]...
                 );

    edtDictPath = ...
        uicontrol(dlgOptions,...
                 'enable'     , sDicEnable,...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , editorCustomDict('get'),...
                  'position'  , [200 55 200 20]...
                  );

    btnSetDictPath = ...
        uicontrol(dlgOptions,...
                  'enable'  , sDicEnable,...
                  'String'  ,'...',...
                  'Position',[405 55 20 20],...
                  'Callback', @setDictPathCallback...
                  );

    % Cancel or Proceed

        uicontrol(dlgOptions,...
                  'String','Cancel',...
                  'Position',[370 7 75 25],...
                  'Callback', @cancelOptionsCallback...
                  );

        uicontrol(dlgOptions,...
                  'String','Ok',...
                  'Position',[290 7 75 25],...
                  'Callback', @okOptionsCallback...
                  );

%        if editorIntegrateToBrowser('get') == true
%            sLogo = './dicomMultiFilesEditor/logo.png';
%        else
%            sLogo = './logo.png';
%        end

%        javaFrame = get(dlgOptions,'JavaFrame');
%        javaFrame.setFigureIcon(javax.swing.ImageIcon(sLogo));

    function checkBoxSaveHeaderCallback(hObject, ~)

        if (get(hObject, 'value'))

            set(edtSaveHeader, 'enable', 'off');
            sAllHeader = 'off';
        else

            set(edtSaveHeader, 'enable', 'on');
            sAllHeader = 'on';
        end
    end

    function saveHeaderTxtCallback(~, ~)

        if (get(chkMultiFile, 'value'))

            if (get(chkSaveHeader, 'value'))
                set(chkSaveHeader, 'value', 0);
            else
                set(chkSaveHeader, 'value', 1);
            end

            checkBoxSaveHeaderCallback(chkSaveHeader);
        end
    end

    function checkBoxMultiFilesCallback(hObject, ~)

        if (get(hObject,'value'))

            if(strcmpi(get(chkSaveHeader, 'enable'), 'off'))
                set(chkSaveHeader, 'enable', 'on');
            end

            if(strcmpi(get(edtSaveHeader, 'enable'), 'off'))
                if (get(chkSaveHeader, 'value'))
                    set(edtSaveHeader, 'enable', 'off');
                else
                    set(edtSaveHeader, 'enable', 'on');
                end
            end
        else

            if(strcmpi(get(chkSaveHeader, 'enable'), 'on'))
                set(chkSaveHeader, 'enable', 'off');
            end

            if(strcmpi(get(edtSaveHeader, 'enable'), 'on'))
                set(edtSaveHeader, 'enable', 'off');
            end
        end
    end

    function autoUIDTxtCallback(~, ~)

        if (get(chkAutoUID,'value'))
            set(chkAutoUID, 'value', false);
        else
            set(chkAutoUID, 'value', true);
        end
    end

    function multiFilesTxtCallback(~, ~)
        if (get(chkMultiFile,'value'))
            set(chkMultiFile, 'value', false);
        else
            set(chkMultiFile, 'value', true);
        end

        checkBoxMultiFilesCallback(chkMultiFile);
    end

    function checkBoxDefaultPathCallback(hObject, ~)

        if ~(get(hObject,'value'))
            if(strcmpi(get(edtDirPath, 'enable'), 'off'))
                set(edtDirPath   , 'enable', 'on');
            end

            if(strcmpi(get(btnSetDirPath, 'enable'), 'off'))
                set(btnSetDirPath, 'enable', 'on');
            end
        else
            if(strcmpi(get(edtDirPath, 'enable'), 'on'))
                set(edtDirPath   , 'enable', 'off');
            end

            if(strcmpi(get(btnSetDirPath, 'enable'), 'on'))
                set(btnSetDirPath, 'enable', 'off');
            end
        end
    end

    function defaultPathTxtCallback(~, ~)

        if (get(chkDefTarget,'value'))
            set (chkDefTarget, 'value', false);
        else
            set (chkDefTarget, 'value', true);
        end

        checkBoxDefaultPathCallback(chkDefTarget);
    end

    function setDirPathCallback(~, ~)

         sCurrentDir = pwd;
         if editorIntegrateToBrowser('get') == true
             sCurrentDir = [sCurrentDir '/dicomMultiFilesEditor'];
         end

         sMatFile = [sCurrentDir '/' 'lastDestDir.mat'];
         % load last data directory
         if exist(sMatFile, 'file') % lastDirMat mat file exists, load it

            load('-mat', sMatFile);
            if exist('lastDestDir', 'var')
                sCurrentDir = lastDestDir;
            end

            if sCurrentDir == 0
              sCurrentDir = pwd;
           end
        end

        sOutDir = uigetdir(sCurrentDir);
        if sOutDir == 0
            return;
        else
            sOutDir = [sOutDir '/'];
            set(edtDirPath, 'string', sOutDir);

            try
                lastDestDir = sOutDir;
                save(sMatFile, 'lastDestDir');
            catch
                editorProgressBar(1 , sprintf('Warning: Cant save file %s', sMatFile));
%                h = msgbox(sprintf('Warning: Cant save file %s', sMatFile), 'Warning');    

%                    if editorIntegrateToBrowser('get') == true
%                        sLogo = './dicomMultiFilesEditor/logo.png';
%                    else
%                        sLogo = './logo.png';
%                    end

%                    javaFrame = get(h, 'JavaFrame');
%                    javaFrame.setFigureIcon(javax.swing.ImageIcon(sLogo));
            end
        end

    end

    function checkBoxPrivDictCallback(hObject, ~)

        if ~(get(hObject,'value'))

            set(edtDictPath   ,'enable', 'on');
            set(btnSetDictPath,'enable', 'on');
        else
            set(edtDictPath   ,'enable', 'off');
            set(btnSetDictPath,'enable', 'off');
        end
    end

    function privDictTxtCallback(~, ~)

        if (get(chkDefDict,'value'))

            set(chkDefDict   ,'value' , 0);
        else
            set(chkDefDict   ,'value' , 1);
        end

        checkBoxPrivDictCallback(chkDefDict);
    end

    function setDictPathCallback(~, ~)

        if editorIntegrateToBrowser('get') == true
            sOpenPath = ['./dicomMultiFilesEditor/'];
        else
            sOpenPath = ['./'];
        end

        [sDicomDict, sDictPathName] = ...
            uigetfile([sOpenPath '*.txt'], 'DICOM Dictionary');
        sDicomDict = [sDictPathName sDicomDict];

        if sDictPathName ~= 0
            set(edtDictPath, 'string', sDicomDict);
        end
     end

    function cancelOptionsCallback(~, ~)

        delete(dlgOptions);
    end

    function dErrorCode = okOptionsCallback(~, ~)

        dErrorCode = false;

        if (get(chkAutoUID,'value'))
            editorAutoSeriesUID('set', true);
        else
            editorAutoSeriesUID('set', false);
        end

        % Proceed with the Directory

        if ~(get(chkDefTarget,'value'))
            editorDefaultPath('set', false);
            sTargetDir = get(edtDirPath,'string');
            if (~numel(sTargetDir))
                dErrorCode = true;
                editorDisplayMessage('Error: okOptionsCallback(), please select a directory!');
                editorProgressBar(1, 'Error: okOptionsCallback(), please select a directory!');
            else
                if ~strcmpi(sTargetDir, '')
                    if ~(sTargetDir(end) == '\') || ...
                       ~(sTargetDir(end) == '/')
                        editorTargetDir('set', [sTargetDir '/']);
                    end
                end
            end
        else
            editorDefaultPath('set', true);
        end

        % Proceed with the DICOM Dict

        bDisplaySource = false;
        if~(get(chkDefDict, 'value') ==  editorDefaultDict('get'))
            bDisplaySource = true;
        end

        if ~(get(chkDefDict,'value'))

            sDicomDict = get(edtDictPath,'string');
            editorDefaultDict('set', false);
            if (numel(sDicomDict))
                editorCustomDict('set', sDicomDict);
                dicomdict ('set', editorCustomDict('get'));
            else
                dErrorCode = true;
                editorDisplayMessage('Error: okOptionsCallback(), please enter a dictionary!');
                editorProgressBar(1, 'Error: okOptionsCallback(), please enter a dictionary!');
            end
        else
             editorDefaultDict('set', true);
        end

        % Proceed with sub directory

        if get(chkMultiFile, 'value')

            if strcmpi(get(btnEditorSortFilesPtr('get')  ,'enable'), 'off')
                set(btnEditorSortFilesPtr('get'), 'enable', 'on');
            end

            editorMultiFiles('set', true);

            % Proceed with the save header

            if ~(get(chkSaveHeader, 'value'))
                editorSaveAllHeader('set', false);
                sSaveHeaderNumber = get(edtSaveHeader, 'string');
                if (numel(sSaveHeaderNumber))
                    editorSaveHeaderNumber('set', sSaveHeaderNumber);
                else
                    dErrorCode = true;
                    editorDisplayMessage('Error: okOptionsCallback(), please enter the slice(s) to save!');
                    editorProgressBar(1, 'Error: okOptionsCallback(), please enter the slice(s) to save!');
                end

            else
                editorSaveAllHeader('set', true);
            end
        else

            if strcmpi(get(btnEditorSortFilesPtr('get')  ,'enable'), 'on')
                set(btnEditorSortFilesPtr('get'), 'enable', 'off');
            end

            editorMultiFiles   ('set', false);
            editorSaveAllHeader('set', false);
        end

        delete(dlgOptions);


        stFilesWindow = ...
            cellstr(get(lbEditorFilesWindowPtr('get'), 'string'));

        if numel(stFilesWindow)

            dElementOffset = get(lbEditorFilesWindowPtr('get'), 'Value');

            if numel(stFilesWindow) >= dElementOffset

                sSelectedLine = ...
                    stFilesWindow{dElementOffset};

                sDCMimg = [editorMainDir('get') sSelectedLine];

                try
                    if bDisplaySource == true
                        set(lbEditorFilesWindowPtr('get'), 'enable', 'off');
                        set(lbEditorMainWindowPtr('get') , 'enable', 'off');

                        editorDisplaySource(sDCMimg);

                        set(lbEditorFilesWindowPtr('get'), 'enable', 'on');
                        set(lbEditorMainWindowPtr('get') , 'enable', 'on');
                    end
                catch
                    dErrorCode = true;
                    set(lbEditorFilesWindowPtr('get'), 'enable', 'on');
                    set(lbEditorMainWindowPtr('get') , 'enable', 'on');
                    editorProgressBar(1, 'Error');
                end
            end
        end
    end
end
