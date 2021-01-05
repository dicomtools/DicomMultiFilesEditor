function editorSaveDicomHeaderCallback(~, ~)
%function editorSaveDicomHeaderCallback(~, ~)
%Export DICOM Header.
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

    persistent sTargetDir;

    if editorMultiFiles('get') == true

         sCurrentDir = pwd;
         if editorIntegrateToBrowser('get') == true
             sCurrentDir = [sCurrentDir '/dicomMultiFilesEditor'];
         end

         sMatFile = [sCurrentDir '/' 'lastSaveDir.mat'];
         % load last data directory
         if exist(sMatFile, 'file') % lastDirMat mat file exists, load it

            load('-mat', sMatFile);
            if exist('lastSaveDir', 'var')
                sCurrentDir = lastSaveDir;
            end
            if sCurrentDir == 0
                sCurrentDir = pwd;
            end
        end

        sTargetDir = uigetdir(sCurrentDir);
        if sTargetDir == 0
            return;
        else
            sTargetDir = [sTargetDir '/'];

            try
                lastSaveDir = sTargetDir;
                save(sMatFile, 'lastSaveDir');
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


        f = java.io.File(char(editorMainDir('get')));
        sFileList = f.listFiles();

 %       sFileList = dir(editorMainDir('get'));

        dUseOffsetArray = false;
        if(editorMultiFiles('get') == true)
            if (editorSaveAllHeader('get') == false)
                i=1;
                remain = editorSaveHeaderNumber('get');
                if ~size(remain)
                    editorDisplayMessage('Error: editorSaveDicomHeaderCallback(), no slice(s) to save, verify the options!');
                    editorProgressBar(1, 'Error: editorSaveDicomHeaderCallback(), no slice(s) to save, verify the options!');
                    return;
                else
                    dUseOffsetArray = true;
                end
                while (remain ~= "")
                   [token,remain] = strtok(remain, ',');
                   adHeaderNumber{i} = str2num(token);
                   i = i+1;
                end

            end
        end

        dNumberOfFile = 0;

        i=1;
        lFirstOffset = -1;
        for dDirOffset = 1 : numel(sFileList)

            editorProgressBar(dDirOffset / numel(sFileList), 'Save in progress');

            if ~sFileList(dDirOffset).isDirectory

                if dUseOffsetArray == true
                    if (numel(adHeaderNumber) >= i)

                        if (lFirstOffset == -1)
                            lFirstOffset = dDirOffset-1;
                        end

                        dDirOffset = adHeaderNumber{i} + lFirstOffset;
                        i = i+1;
                        if(dDirOffset > numel(sFileList))
                            break;
                        end
                    else
                        break;
                    end
                end

                sDicomImg = char(sFileList(dDirOffset));

                if isdicom(sDicomImg)
                    try
                        fFileID = fopen( sprintf('%s%s.txt', sTargetDir, char(sFileList(dDirOffset).getName()) ),'w');
                        cellDisplay = editorDicomDisplay(sDicomImg);

                        fprintf(fFileID, '%s\n', string(cellDisplay) );
                        fclose(fFileID);
                        dNumberOfFile = dNumberOfFile +1;
                    catch
                        editorProgressBar(1, sprintf('Error: editorSaveDicomHeaderCallback(), cant save file %s', char(sFileList(dDirOffset).getName()) ) );
                    end
                end
            end
        end

        editorProgressBar(1, 'Ready');

       sMessage = ...
        sprintf('Saved %d file(s) to %s', dNumberOfFile, sTargetDir);

        editorProgressBar(1, sMessage);

      % editorDisplayMessage(sMessage);
    else
        sMainDisplay = char(get(lbEditorMainWindowPtr('get'), 'string'));
        if(numel(sMainDisplay))
             sCurrentDir = pwd;
             if editorIntegrateToBrowser('get') == true
                 sCurrentDir = [sCurrentDir '/dicomMultiFilesEditor'];
             end

             sMatFile = [sCurrentDir '/' 'lastSaveDir.mat'];
             % load last data directory
             if exist(sMatFile, 'file')
                                        % lastDirMat mat file exists, load it
                load('-mat', sMatFile);
                if exist('lastSaveDir', 'var')
                    sCurrentDir = lastSaveDir;
                end

                if sCurrentDir == 0
                   sCurrentDir = pwd;
                end
             end

            [sFileName, sPathName] = uiputfile(...
                {'*.txt';'*.*'},...
                'Save as', sCurrentDir);

            if sFileName == 0
                return;
            else

                try
                    lastSaveDir = [sPathName '/'];
                    save(sMatFile, 'lastSaveDir');
                catch
                    editorProgressBar(1 , sprintf('Warning: Cant save file %s', sMatFile));
%                    h = msgbox(sprintf('Warning: Cant save file %s', sMatFile), 'Warning');

%                        if editorIntegrateToBrowser('get') == true
%                            sLogo = './dicomMultiFilesEditor/logo.png';
%                        else
%                            sLogo = './logo.png';
%                        end

%                        javaFrame = get(h, 'JavaFrame');
%                        javaFrame.setFigureIcon(javax.swing.ImageIcon(sLogo));
                end

                    % Write header to file
                    fFileID = fopen([sPathName sFileName],'w');
                    for i = 1:  size(sMainDisplay,1)
                        fprintf(fFileID,'%s\r\n',sMainDisplay(i,:));
                    end
                    fclose(fFileID);
                    sMessage = ...
                        sprintf('Saved %d file(s) to %s', 1, sPathName);

                    editorProgressBar(1, sMessage);
            end
        end
    end
end
