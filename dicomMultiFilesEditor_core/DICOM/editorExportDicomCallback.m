function editorExportDicomCallback(~, ~)
%function editorExportDicomCallback(~, ~)
%Export DICOM series.
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

    dNumberOfFile = 0;

    if editorDefaultPath('get') == true
        
         sCurrentDir = editorRootPath('get');            

         sMatFile = [sCurrentDir '/' 'lastWriteDir.mat'];
         % load last data directory
         if exist(sMatFile, 'file') % lastDirMat mat file exists, load it

            load('-mat', sMatFile);
            if exist('lastWriteDir', 'var') 
                sCurrentDir = lastWriteDir;
            end                     
         end
            
        sOutDir = uigetdir(sCurrentDir, 'Write Directory');
        if sOutDir == 0
            return;
        else
            try
                lastWriteDir = sOutDir;
                save(sMatFile, 'lastWriteDir');
            catch
                editorProgressBar(1 , sprintf('Warning: Cant save file %s', sMatFile));
            end            
        end        
           
    else   
        if (numel(editorTargetDir('get')))
            sOutDir = editorTargetDir('get');
        else
            editorDisplayMessage('Error: editorExportDicomCallback(), cannot set the target directory!');
            editorProgressBar(1, 'Error: editorExportDicomCallback(), cannot set the target directory!');
            return;
        end
    end 

    if ~exist(char(sOutDir), 'dir')
        mkdir(char(sOutDir));
    end

    if editorDefaultDict('get') == true
        dicomdict('factory');  
    else    
        if numel(editorCustomDict('get'))
            dicomdict('set', editorCustomDict('get'));   
        else
            editorDisplayMessage('Error: editorExportDicomCallback(), cannot set the DICOM dictionary!');
            editorProgressBar(1, 'Error: editorExportDicomCallback(), cannot set the DICOM dictionary!');
            return;
        end
    end
    
    if editorAutoSeriesUID('get') == true
        lSeriesUID = dicomuid;
    end
    
    try
        warning('off','all')
            
        sTmpDir = sprintf('%stemp_dicom_%s//', tempdir, datetime('now','Format','MMMM-d-y-hhmmss'));
        if exist(char(sTmpDir), 'dir')
            rmdir(char(sTmpDir), 's');
        end
        mkdir(char(sTmpDir));

        f = java.io.File(char(editorMainDir('get')));
        sFilesList = f.listFiles();
        
        atMetaData = editorDicomMetaData('get');

        if editorMultiFiles('get') == true
            dDirLastOffset = numel(sFilesList);
        else
            dDirLastOffset = 1;
        end       
        
        for dDirOffset=1 : dDirLastOffset

            editorProgressBar(dDirOffset / dDirLastOffset, 'Write in progress');
            
            if editorMultiFiles('get') == false
                dOffset = get(lbEditorFilesWindowPtr('get'), 'Value');
            else
                dOffset = dDirOffset;
            end

            if ~sFilesList(dOffset).isDirectory

                if editorMultiFiles('get') == false
                    sDicomImg = sprintf('%s%s', editorMainDir('get'), editorDicomFileName('get'));
                else
                    sDicomImg = ...
                        sprintf('%s%s', editorMainDir('get'), char(sFilesList(dOffset).getName()));  
                end
                
                if(isdicom(sDicomImg))                               
                    if isempty(atMetaData)
                        tMetaData = dicominfo(sDicomImg);
                    else
                        tMetaData = atMetaData{dOffset};
                    end

                    sDicomRead = dicomread(sDicomImg);    
                    
                    if editorMultiFiles('get') == false
                        if contains(lower(editorDicomFileName('get')), '.dcm')
                            sOutFiles = sprintf('%s%s', char(sTmpDir), editorDicomFileName('get'));                                
                        else    
                            sOutFiles = sprintf('%s%s.dcm', char(sTmpDir), editorDicomFileName('get'));                                
                        end                         
                    else
                        if contains(lower(char(sFilesList(dOffset).getName())), '.dcm')
                            sOutFiles = sprintf('%s%s', char(sTmpDir), char(sFilesList(dOffset).getName()));                                
                        else    
                            sOutFiles = sprintf('%s%s.dcm', char(sTmpDir), char(sFilesList(dOffset).getName()));                                
                        end    
                    end
                    
                    if editorAutoSeriesUID('get') == true
                        if isfield(tMetaData, 'SeriesInstanceUID')
                            tMetaData.SeriesInstanceUID = lSeriesUID;
                        end
                    end

                    try
                        dicomwrite(sDicomRead    , ...
                                   sOutFiles     , ...
                                   tMetaData     , ...
                                   'CreateMode'  , ...
                                   'copy'        , ...
                                   'WritePrivate',true ...
                                  );

                        dNumberOfFile = dNumberOfFile +1;
                    catch

                        editorDisplayMessage('Error: editorExportDicomCallback(), write faild!');
                        editorProgressBar(1, 'Error: editorExportDicomCallback(), write faild!');
                        return;
                    end 
                end                                   
            end
        end
        
        f = java.io.File(char(sTmpDir));
        dinfo = f.listFiles();                   
        for K = 1 : 1 : numel(dinfo)
            if ~(dinfo(K).isDirectory)
                copyfile([char(sTmpDir) char(dinfo(K).getName())], char(sOutDir) );
            end
        end 
        rmdir(char(sTmpDir), 's');

        editorProgressBar(1, 'Ready');        
        
    catch
        editorDisplayMessage('Error: editorExportDicomCallback(), write faild!');
        editorProgressBar(1, 'Error: editorExportDicomCallback(), write faild!');
        return;       
    end
    
    sMessage = ...
        sprintf('Write %d file(s) completed %s', ...
                dNumberOfFile, ...
                sOutDir ...
                ); 

    editorProgressBar(1, sMessage);                
end