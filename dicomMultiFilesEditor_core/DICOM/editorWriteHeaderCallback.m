function editorWriteHeaderCallback(~, ~)
%function editorWriteHeaderCallback(~, ~)  
%Write a new DICOM dataset With Upadated Dicom Field, Call From ui Menu.
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

    tDicomTag.sGroup   = '';
    tDicomTag.sElement = '';
    tDicomTag.sVR      = '';

    dElementOffset = get(lbEditorMainWindowPtr('get'), 'Value');                       
    stMainWindow   = cellstr(get(lbEditorMainWindowPtr('get'), 'String'));             

    if editorDefaultDict('get') == true
        sPrivateDictEnable = 'on';
    else    
        sPrivateDictEnable = 'off';
    end

    if(numel(stMainWindow) > 1)
        if (numel(stMainWindow) > dElementOffset)

            sSelectedLine = ...
                stMainWindow{dElementOffset}; 

            stSelectedLine = ...
                strsplit(sSelectedLine);        

            if (numel(stSelectedLine) > 4)

                stGroupAndElement = ...
                    strsplit(stSelectedLine{3},{',','(',')'});

                if (numel(stGroupAndElement) > 3)
                    tDicomTag.sGroup   = stGroupAndElement{2};
                    tDicomTag.sElement = stGroupAndElement{3};
                    tDicomTag.sVR      = stSelectedLine{4}   ;         
                end
            end
        end
    end

    dScreenSize  = get(groot, 'Screensize'  );
    dDlgPosition = get(dlgEditorWindowsPtr('get'),'position');

    xSize     = dScreenSize(3) * dDlgPosition(3); 
    xPosition = dScreenSize(3) * dDlgPosition(1) + ((xSize /2)-250);

    ySize     = dScreenSize(4) * dDlgPosition(4); 
    yPosition = dScreenSize(4) * dDlgPosition(2) + ((ySize /2)-200);

    dlgWrite = ...
        dialog('Position', [xPosition ...
                            yPosition ...
                            280 ...
                            200 ...
                            ],...
              'Color', editorBackgroundColor('get'), ...
              'Name', 'Write DICOM'...
               );        

         uicontrol(dlgWrite,...
                   'style'   , 'text',...
                   'string'  , 'DICOM Group:',...
                   'horizontalalignment', 'left',...
                   'BackgroundColor', editorBackgroundColor('get'), ...
                   'ForegroundColor', editorForegroundColor('get'), ...                      
                   'position', [20 165 100 20]...
                   );        

    edtWriteGroup = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'on',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sGroup,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                   
                  'position'  , [150 165 100 20]...
                  );        

        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'string'  , 'DICOM Element:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 140 100 20]...
                  );        

    edtWriteElement = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'on',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sElement,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position'  , [150 140 100 20]...
                  );                        

        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'string'  , 'DICOM VR:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 115 100 20]...
                  );        

    edtWriteVR = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'on',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sVR,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position'  , [150 115 100 20]...
                  );           

        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'string'  , 'Value:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 65 100 20]...
                  );        

    edtWriteValue = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'on',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , '',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position'  , [150 65 100 20]...
                  );                       

    chkPrivDict = ...
        uicontrol(dlgWrite,...
                  'style'   , 'checkbox',...
                  'enable'  , sPrivateDictEnable,...
                  'value'   , 0,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 45 20 20]...
                  );                    

    txtPrivDict = ...
        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'string'  , 'Private Filed',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [41 42 100 20]...
                  );  

    txtPrivDict.Enable = 'Inactive';
    txtPrivDict.ButtonDownFcn = @privateDictTxtCallback;

    % Cancel or Proceed

        uicontrol(dlgWrite,...
                  'String'  ,'Cancel',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'Callback', @cancelWriteCallback...
                  );  

        uicontrol(dlgWrite,...
                  'String'  ,'Proceed',...
                  'Position',[120 7 75 25],...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'Callback', @editorProceedWriteCallback...
                  );                      

%         if editorIntegrateToBrowser('get') == true
%            sLogo = './dicomMultiFilesEditor/logo.png';
%         else
%            sLogo = './logo.png';
%         end

%        javaFrame = get(dlgWrite,'JavaFrame');
%        javaFrame.setFigureIcon(javax.swing.ImageIcon(sLogo));  

    function privateDictTxtCallback(~, ~)
        if get(chkPrivDict, 'value')
            set(chkPrivDict, 'value', 0);
        else
            set(chkPrivDict, 'value', 1);
        end
    end

    function editorProceedWriteCallback(~, ~)

        dNumberOfFile = 0;

        tDicomTag.sGroup   = get(edtWriteGroup  , 'String');    
        tDicomTag.sElement = get(edtWriteElement, 'String');               
        tDicomTag.sVR      = get(edtWriteVR     , 'String');  
        tDicomTag.sValue   = get(edtWriteValue  , 'String'); 
        tDicomTag.dPrivate = get(chkPrivDict    , 'Value' ); 

        delete(dlgWrite);                     

        if(isempty(editorMainDir('get')))
            editorDisplayMessage('Error: editorProceedWriteCallback(), please select a source directory!');
            editorProgressBar(1, 'Error: editorProceedWriteCallback(), please select a source directory!');
            return;
        end

        if(isempty(tDicomTag.sGroup))
            editorDisplayMessage('Error: editorProceedWriteCallback(), please set a group!');
            editorProgressBar(1, 'Error: editorProceedWriteCallback(), please set a group!');
            return;
        end

        if(isempty(tDicomTag.sElement))
            editorDisplayMessage('Error: editorProceedWriteCallback(), please set an element!');
            editorProgressBar(1, 'Error: editorProceedWriteCallback(), please set an element!');
            return;
        end           

        if (editorDefaultPath('get') == true)
            sDate   = sprintf('%s', datetime('now','Format','MMMM-d-y-hhmmss'));
            sOutDir = sprintf('%supdated_dicom_%s/', editorMainDir('get'), sDate);                
        else   
            if (numel(editorTargetDir('get')))
                sOutDir = editorTargetDir('get');
            else
                editorDisplayMessage('Error: editorProceedWriteCallback(), cannot set the target directory!');
                editorProgressBar(1, 'Error: editorProceedWriteCallback(), cannot set the target directory!');
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
                editorDisplayMessage('Error: editorProceedWriteCallback(), cannot set the DICOM dictionary!');
                editorProgressBar(1, 'Error: editorProceedWriteCallback(), cannot set the DICOM dictionary!');
                return;
            end
        end

        if editorAutoSeriesUID('get') == true
            lSeriesUID = dicomuid;
        end

        try            
            warning('off','all')

            if editorMultiFiles('get') == true

                sTmpDir = sprintf('%stemp_dicom_%s//', tempdir, datetime('now','Format','MMMM-d-y-hhmmss'));
                if exist(char(sTmpDir), 'dir')
                    rmdir(char(sTmpDir), 's');
                end
                mkdir(char(sTmpDir));

                f = java.io.File(char(editorMainDir('get')));
                sFilesList = f.listFiles();

                for dDirOffset=1 : numel(sFilesList)

                    clear tMetadata sDicomRead;

                    editorProgressBar(dDirOffset / numel(sFilesList), 'Write in progress');

                    if ~sFilesList(dDirOffset).isDirectory

                        sDicomImg = ...
                            sprintf('%s%s', editorMainDir('get'), char(sFilesList(dDirOffset).getName()));

                        if(isdicom(sDicomImg))                               

                            tMetaData = dicominfo(sDicomImg);

                            if (tDicomTag.dPrivate == 1)
                                sDicomField = ...
                                    sprintf('tMetaData.Private_%s_%s', char(tDicomTag.sGroup), char(tDicomTag.sElement));

                                tMetaData.(char(sDicomField)) = ...
                                    castValue(tDicomTag.sVR, tDicomTag.sValue );                                                                        
                            else    
                                sDicomField = ...
                                    dicomlookup(char(tDicomTag.sGroup) ,...
                                                char(tDicomTag.sElement)...
                                               );

                                [aResult, ~] = StructSearch(tMetaData, sDicomField);

                                aResultSize = size(aResult);
                                if aResultSize(1) >1  
                                    dElementOffset = get(lbEditorMainWindowPtr('get'), 'Value');                       
                                    stMainWindow   = cellstr(get(lbEditorMainWindowPtr('get'), 'String')); 
                                    dSameNameOffset =0;
                                    for ii=1:dElementOffset
                                        if contains(char(stMainWindow(ii)), char([' ' sDicomField ' ']) )
                                            dSameNameOffset = dSameNameOffset+1;
                                        end
                                    end

                                    sDicomField = aResult(dSameNameOffset,2);                                       
                                else
                                    sDicomField = aResult(1,2);
                                end

                            end

                            eval([char(sDicomField) ' = castValue(tDicomTag.sVR, tDicomTag.sValue)']);

                            sDicomRead = dicomread(sDicomImg);    

                            if contains(lower(char(sFilesList(dDirOffset).getName())), '.dcm')
                                sOutFiles = sprintf('%s%s', char(sTmpDir), char(sFilesList(dDirOffset).getName()));                                
                            else    
                                sOutFiles = sprintf('%s%s.dcm', char(sTmpDir), char(sFilesList(dDirOffset).getName()));                                
                            end    


                            if editorAutoSeriesUID('get') == true

                                if isfield(tMetaData, 'SeriesInstanceUID')
                                    tMetaData.SeriesInstanceUID = lSeriesUID;
                                end
                            end
                            
                            try
%                            tMetaData.AcquisitionContextSequence.Item_1.ConceptCodeSequence.Item_1.CodeValue = '109091';                            
%                            tMetaData.AcquisitionContextSequence.Item_1.ConceptCodeSequence.Item_1.CodingSchemeDesignator = 'DCM';
%                            tMetaData.AcquisitionContextSequence.Item_1.ConceptCodeSequence.Item_1.CodeMeaning = 'Cardiac Stress State';
                            
                                dicomwrite(sDicomRead    , ...
                                           sOutFiles     , ...
                                           tMetaData     , ...
                                           'CreateMode'  , ...
                                           'copy'        , ...
                                           'WritePrivate',true ...
                                          );

                                dNumberOfFile = dNumberOfFile +1;
                            catch

                                editorDisplayMessage('Error: editorProceedWriteCallback(), write faild!');
                                editorProgressBar(1, 'Error: editorProceedWriteCallback(), write faild!');
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

            else
                if numel(editorDicomFileName('get'))

                    sDicomImg = [editorMainDir('get') editorDicomFileName('get')];

                    if(isdicom(sDicomImg))

                        tMetaData = dicominfo(sDicomImg);

                        if tDicomTag.dPrivate == 1
                            sDicomField = ...
                                sprintf('tMetaData.Private_%s_%s', char(tDicomTag.sGroup), char(tDicomTag.sElement));
                        else    
                            sDicomField = ...
                                dicomlookup(char(tDicomTag.sGroup) ,...
                                            char(tDicomTag.sElement)...
                                            );


                            [aResult, ~] = StructSearch(tMetaData, sDicomField);

                            aResultSize = size(aResult);
                            if aResultSize(1) >1  
                                dElementOffset = get(lbEditorMainWindowPtr('get'), 'Value');                       
                                stMainWindow   = cellstr(get(lbEditorMainWindowPtr('get'), 'String')); 
                                dSameNameOffset =0;
                                for ii=1:dElementOffset
                                    if contains(char(stMainWindow(ii)), char([' ' sDicomField ' ']) )
                                        dSameNameOffset = dSameNameOffset+1;
                                    end
                                end

                                sDicomField = aResult(dSameNameOffset,2);                                       
                            else
                                sDicomField = aResult(1,2);
                            end                                         

                        end

                        eval([char(sDicomField) ' = castValue(tDicomTag.sVR, tDicomTag.sValue)']);

                        sDicomRead = dicomread(sDicomImg);    

                        if contains(lower(sDicomImg), '.dcm')
                            sOutFile = sprintf('%s%s', char(sOutDir), editorDicomFileName('get'));                                
                        else    
                            sOutFile = sprintf('%s%s.dcm', char(sOutDir), editorDicomFileName('get'));                                
                        end    

                        if editorAutoSeriesUID('get') == true

                            if isfield(tMetaData, 'SeriesInstanceUID')
                                tMetaData.SeriesInstanceUID = lSeriesUID;
                            end
                        end

                        try
                            
 %                           tMetaData.AcquisitionContextSequence.Item_1.ConceptCodeSequence.Item_1.CodeValue = '109091';                            
 %                           tMetaData.AcquisitionContextSequence.Item_1.ConceptCodeSequence.Item_1.CodingSchemeDesignator = 'DCM';
 %                           tMetaData.AcquisitionContextSequence.Item_1.ConceptCodeSequence.Item_1.CodeMeaning = 'Cardiac Stress State';
                            dicomwrite(sDicomRead    , ...
                                       sOutFile      , ...
                                       tMetaData     , ...
                                       'CreateMode'  , ...
                                       'copy'        , ...
                                       'WritePrivate',true ...
                                      );

                            dNumberOfFile = 1;
                        catch
                            editorDisplayMessage('Error: editorProceedWriteCallback(), write faild!');
                            editorProgressBar(1, 'Error: editorProceedWriteCallback(), write faild!');
                            return;
                        end
                    end
                else
                    editorDisplayMessage('Error: editorProceedWriteCallback(), no DICOM file found!');
                    editorProgressBar(1, 'Error: editorProceedWriteCallback(), no DICOM file found!');
                    return;
                end
            end                
        catch                    
            editorDisplayMessage('Error: editorProceedWriteCallback(), write faild!');
            editorProgressBar(1, 'Error: editorProceedWriteCallback(), write faild!');
            return;
        end

        sMessage = ...
            sprintf('Write %d file(s) completed %s', ...
                    dNumberOfFile, ...
                    sOutDir ...
                    ); 

        editorProgressBar(1, sMessage);

    end             

    function cancelWriteCallback(~, ~)

        delete(dlgWrite);                     
    end

    function returnValue = castValue(sVR, sValue)

        returnValue = '';

        if ischar(sVR)

            switch sVR
                case {'IS','SS'}
                    returnValue = str2num(sValue);                       

                case {'US'}
                    returnValue = str2num(sValue);                       
                    returnValue = cast(returnValue,'uint16');
                otherwise                    
                    returnValue = char(sValue);                                            
            end
        else
            editorDisplayMessage('Error: castValue(), unsupported variable type!');
            editorProgressBar(1, 'Error: castValue(), unsupported variable type!');
        end
    end

end
