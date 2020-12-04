function editorSetSource(bDisplaySource)   
%function editorSetSource(bDisplaySource)   
%Set Editor DICOM Source.
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

    dFoundValidDicomFile = false;

    if editorMultiFiles('get') == true

        if editorSortFiles('get') == true 
             datasets = editorDicomInfoSortFolder(editorMainDir('get'));
             if numel(datasets)
                sFileList = datasets.FileNames;            
             end
        else
             f = java.io.File( char(editorMainDir('get')) );
             sFileList = f.listFiles();

        end

         sFilesDisplay = '';
         dNumberOfFiles = 0;             

         if editorSortFiles('get') == true                  

             for dDirOffset = 1 : numel(sFileList)    

                 editorProgressBar(dDirOffset / numel(sFileList) /2, 'Processing file list');

                  if (dFoundValidDicomFile == false)  

                      j=1;
                      remain = char(sFileList(dDirOffset)); 

                      while (remain ~= "")                   
                         [token, remain] = strtok(remain, '\/');
                         j = j+1;
                      end

                      sFilesDisplay = ...
                          sprintf('%s\n', char(token));

                      sDCMimg = char(sFileList(dDirOffset));
                      dFoundValidDicomFile = true;
                  else

                      j=1;
                      remain = char(sFileList(dDirOffset)); 

                      while (remain ~= "")                   
                         [token, remain] = strtok(remain, '\/');
                         j = j+1;
                      end

                      sFilesDisplay = ...
                          sprintf('%s%s\n', sFilesDisplay, char(token));                                                                      
                  end   

                  dNumberOfFiles = dNumberOfFiles + 1;    
                  if (dNumberOfFiles > 5000)
                      break
                  end    
             end

         else    

             for dDirOffset = 1 : numel(sFileList)   

                editorProgressBar(dDirOffset / numel(sFileList) /2, 'Processing file list');

                 if ~(sFileList(dDirOffset).isDirectory)

                     if (dFoundValidDicomFile == false)  

                         sFilesDisplay = ...
                             sprintf('%s\n', char(sFileList(dDirOffset).getName()));

                         sDCMimg = char(sFileList(dDirOffset));
                         dFoundValidDicomFile = true;
                     else

                         sFilesDisplay = ...
                             sprintf('%s%s\n', sFilesDisplay,char(sFileList(dDirOffset).getName()));                                                                         
                     end   

                     dNumberOfFiles = dNumberOfFiles + 1;    
                     if (dNumberOfFiles > 5000)
                         break
                     end    
                 end
             end                

         end   

        editorProgressBar(1, 'Ready');

     else                
         sDCMimg = [editorMainDir('get') editorDicomFileName('get')];            
         sFilesDisplay = editorDicomFileName('get');
         if isdicom(sDCMimg)
             dFoundValidDicomFile = true;
         end    
     end                         

     if dFoundValidDicomFile == true

        set(lbEditorFilesWindowPtr('get'), 'value', true);
        set(lbEditorMainWindowPtr('get') , 'value', true);

         try
             if bDisplaySource == true
                editorDisplaySource(sDCMimg);      
             end   
         catch                 
         end

          set(lbEditorFilesWindowPtr('get'), 'enable', 'on')

          if editorMultiFiles('get') == true
            if strcmpi(get(btnEditorSortFilesPtr('get')  ,'enable'), 'off')
                set(btnEditorSortFilesPtr('get'), 'enable', 'on');
            end 
          end

         set(lbEditorFilesWindowPtr('get'),'string', sFilesDisplay);                           

         if strcmpi(get(btnEditorSaveHeaderPtr('get') ,'enable'), 'off')
             set(btnEditorSaveHeaderPtr('get'),'enable', 'on');
         end 

         if strcmpi(get(btnEditorWriteHeaderPtr('get'),'enable'), 'off')
             set(btnEditorWriteHeaderPtr('get'),'enable', 'on');
         end  
     end 
 end
