function editorSetSourceCallback(~, ~)
%function editorSetSourceCallback(~, ~)
%Set Editor DICOM Source, Call From ui Menu.
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

         sCurrentDir = pwd;
         if editorIntegrateToBrowser('get') == true
             sCurrentDir = [sCurrentDir '/dicomMultiFilesEditor'];
         end

         sMatFile = [sCurrentDir '/' 'lastOpenDir.mat'];
         % load last data directory
         if exist(sMatFile, 'file') % lastDirMat mat file exists, load it

            load('-mat', sMatFile);
            if exist('lastOpenDir', 'var')
                sCurrentDir = lastOpenDir;
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
            editorMainDir('set', sOutDir);
            editorSetSource(true);

            try
                lastOpenDir = sOutDir;
                save(sMatFile, 'lastOpenDir');
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
    else
        sCurrentDir = pwd;
        if editorIntegrateToBrowser('get') == true
             sCurrentDir = [sCurrentDir '/dicomMultiFilesEditor'];
        end

        sMatFile = [sCurrentDir '/' 'lastOpenDir.mat'];
        % load last data directory
        if exist(sMatFile, 'file')
                                    % lastDirMat mat file exists, load it
           load('-mat', sMatFile);
           if exist('lastOpenDir', 'var')
               sCurrentDir = lastOpenDir;
           end

           if sCurrentDir == 0
              sCurrentDir = pwd;
           end
        end

        [sDcmFileName, sOutDir] = uigetfile('.dcm', 'DICOM File', sCurrentDir);

        if sOutDir == 0
            return;
        else
            try
                lastOpenDir = [sOutDir '/'];
                save(sMatFile, 'lastOpenDir');
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

            sOutDir = sprintf('%s/', sOutDir);
            editorMainDir('set', sOutDir);

            editorDicomFileName('set', sDcmFileName);

            editorSetSource(true);
        end

    end
end
