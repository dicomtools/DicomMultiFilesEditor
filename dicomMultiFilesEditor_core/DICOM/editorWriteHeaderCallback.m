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

    dScreenSize  = get(groot, 'Screensize');
    dDlgPosition = get(dlgEditorWindowsPtr('get'),'position');

    xSize     = dScreenSize(3) * dDlgPosition(3); 
    xPosition = dScreenSize(3) * dDlgPosition(1) + ((xSize /2)-140);

    ySize     = dScreenSize(4) * dDlgPosition(4); 
    yPosition = dScreenSize(4) * dDlgPosition(2) + ((ySize /2)-100);
    
    if(isempty(tDicomTag.sGroup))
        editorProgressBar(1, 'Error: editorWriteTagCallbak(), invalid group!');
        return;
    end

    if(isempty(tDicomTag.sElement))
        editorProgressBar(1, 'Error: editorWriteTagCallbak(), invalid element!');
        return;
    end           

    if(isempty(tDicomTag.sVR))
        editorProgressBar(1, 'Error: editorWriteTagCallbak(), invalid VR value!');
        return;
    end  

    if strcmpi(tDicomTag.sGroup, 'FFFE') && strcmpi(tDicomTag.sElement, 'E000')
        editorProgressBar(1, 'Error: editorWriteTagCallbak(), cant write an item!');
        return;
    end
        
    dlgWrite = ...
        dialog('Position', [xPosition ...
                            yPosition ...
                            280 ...
                            200 ...
                            ],...
              'Color', editorBackgroundColor('get'), ...
              'Name', 'Write Field'...
               );        

         uicontrol(dlgWrite,...
                   'style'   , 'text',...
                   'enable'  , 'on',...
                   'string'  , 'DICOM Group:',...
                   'horizontalalignment', 'left',...
                   'BackgroundColor', editorBackgroundColor('get'), ...
                   'ForegroundColor', editorForegroundColor('get'), ...                      
                   'position', [20 165 100 20]...
                   );        

    edtWriteGroup = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'off',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sGroup,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                   
                  'position'  , [150 165 100 20]...
                  );        

        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'enable'  , 'on',...
                  'string'  , 'DICOM Element:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 140 100 20]...
                  );        

    edtWriteElement = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'off',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sElement,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position'  , [150 140 100 20]...
                  );                        

        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'enable'  , 'on',...
                  'string'  , 'DICOM VR:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 115 100 20]...
                  );        

    edtWriteVR = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'off',...
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

    % Cancel or Proceed

        uicontrol(dlgWrite,...
                  'String'  ,'Cancel',...
                  'Position',[200 7 75 25],...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'Callback', @cancelWriteCallback...
                  );  
              
    btnProceed = ...
        uicontrol(dlgWrite,...
                  'String'  ,'Proceed',...
                  'Position',[120 7 75 25],...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'Callback', @editorWriteTagCallbak...
                  );       
              

        
%         if editorIntegrateToBrowser('get') == true
%            sLogo = './dicomMultiFilesEditor/logo.png';
%         else
%            sLogo = './logo.png';
%         end

%        javaFrame = get(dlgWrite,'JavaFrame');
%        javaFrame.setFigureIcon(javax.swing.ImageIcon(sLogo));  


    function editorWriteTagCallbak(~, ~)
        
        editorCancelWriteTag('set', false);
        dError = false;
        
        set(btnProceed     , 'Enable', 'off');
        set(edtWriteValue  , 'Enable', 'off');
        set(edtWriteGroup  , 'enable', 'off');
        set(edtWriteElement, 'enable', 'off');
        set(edtWriteVR     , 'enable', 'off');        
                
        tDicomTag.sGroup   = get(edtWriteGroup  , 'String');    
        tDicomTag.sElement = get(edtWriteElement, 'String');               
        tDicomTag.sVR      = get(edtWriteVR     , 'String');  
        tDicomTag.sValue   = get(edtWriteValue  , 'String'); 
                       
        if(isempty(tDicomTag.sGroup))
            editorProgressBar(1, 'Error: editorWriteTagCallbak(), invalid group!');
            delete(dlgWrite);     
            return;
        end

        if(isempty(tDicomTag.sElement))
            editorProgressBar(1, 'Error: editorWriteTagCallbak(), invalid element!');
            delete(dlgWrite);                 
            return;
        end           
        
        if(isempty(tDicomTag.sVR))
            editorProgressBar(1, 'Error: editorWriteTagCallbak(), invalid VR value!');
            delete(dlgWrite);                 
            return;
        end  
        
        if strcmpi(tDicomTag.sGroup, 'FFFE') && strcmpi(tDicomTag.sElement, 'E000')
            editorProgressBar(1, 'Error: editorWriteTagCallbak(), cant write an item!');
            delete(dlgWrite);                 
            return;            
        end
        
        set(lbEditorFilesWindowPtr('get'), 'Enable', 'off'); 
        
        atMetaData = editorDicomMetaData('get');
        if isempty(atMetaData)
                
            if (editorDefaultDict('get') == true)
                dicomdict('factory');  
            else    
                if (numel(editorCustomDict('get')))
                    dicomdict('set', editorCustomDict('get'));   
                else
                    editorDisplayMessage('Error: editorDicomDisplay(), cannot set the DICOM dictionary!');
                    editorProgressBar(1, 'Error: editorDicomDisplay(), cannot set the DICOM dictionary!');  
                    dError = true;
                end
            end
                        
            asDicomFiles = get(lbEditorFilesWindowPtr('get'), 'String');
            aNbFiles = size(asDicomFiles);
            for dd=1:aNbFiles(1)
                if editorCancelWriteTag('get') == true
                    if isempty(editorDicomMetaData('get'))
                        set(btnEditorResetHeaderPtr('get'), 'enable', 'off');        
                        set(lbEditorFilesWindowPtr('get'), 'Enable', 'on'); 
                    end
                    break;
                end
                
                editorProgressBar(dd/aNbFiles(1), sprintf('Updating Header %d/%d, please wait', dd, aNbFiles(1)));

                sDicomFile = sprintf('%s%s', editorMainDir('get'), asDicomFiles(dd,:));
                try
                    if ~isempty(asDicomFiles(dd,:))
                        if isdicom(sDicomFile)
                            atMetaData{dd} = dicominfo(sDicomFile);                            
                        end
                    end
                catch
                end
            end
        end
      
        if editorCancelWriteTag('get') == false
            
            dElementOffset = get(lbEditorMainWindowPtr('get'), 'Value');                       
            stMainWindow   = cellstr(get(lbEditorMainWindowPtr('get'), 'String'));    
    
            delete(dlgWrite);
            
                           
            for ee=1:numel(atMetaData)

                tMetaData = atMetaData{ee};
%                sUnfolfddMeta = evalc('editorUnfold(tMetaData)');
%                aUnfolfddMeta = splitlines(sUnfolfddMeta);  
                editorUnfoldString('set', '');
                editorUnfold(tMetaData);                  
                aUnfolfddMeta = editorUnfoldString('get');
                
                aFieldList = getDicomLookupStructNames(aUnfolfddMeta, dicomlookup(tDicomTag.sGroup, tDicomTag.sElement));
                
                sFieldName = extractStructElementName(aFieldList, stMainWindow, dElementOffset); 
                      
                if isempty(aFieldList) || isempty(sFieldName)
                    editorProgressBar(1, sprintf('Error:editorWriteTagCallbak, cant find the field %s', dicomlookup(tDicomTag.sGroup, tDicomTag.sElement)) );   
                    dError = true;
                else                 
                    sFieldName = erase(sFieldName, 'tMetaData.');
                    
                    try
                        if numel(sFieldName) > 64
                            editorWriteMetaData('set', '');
                            newValue = castValue(tDicomTag.sVR ,tDicomTag.sValue);
                            sStruct = sprintf('tMetaData.%s', sFieldName);
                            
                            editorWriteUnfold(sStruct, newValue, tMetaData);
                            tWriteMetaData = editorWriteMetaData('get');
                            sNewField = erase(sStruct, ['.' dicomlookup(tDicomTag.sGroup, tDicomTag.sElement)]);
                            eval([sNewField ' = tWriteMetaData']);
                            
                        else
                            tMetaData.(sFieldName) = castValue(tDicomTag.sVR ,tDicomTag.sValue);
                        end
                    catch
                        editorProgressBar(1, sprintf('Error:editorWriteTagCallbak, cant write the field %s', dicomlookup(tDicomTag.sGroup, tDicomTag.sElement)) );  
                        dError = true;                      
                    end

                    atMetaData{ee} = tMetaData;
                end
            end

            if dError == false
                                
                editorDicomMetaData('set', atMetaData);

                asString    = get(lbEditorMainWindowPtr('get'), 'String');
                dValue      = get(lbEditorMainWindowPtr('get'), 'Value');     
                dListboxTop = get(lbEditorMainWindowPtr('get'), 'ListboxTop');  

                if numel(asString) 
                                        
                    sLine = asString{dValue};
                    sNewLine = replaceBetween(sLine,'[',']', tDicomTag.sValue);

                    sNewLine = strrep(sNewLine, ' ', '&nbsp;');   

                    sFontName = get(lbEditorMainWindowPtr('get'), 'FontName');
                    aColor   = editorWriteTagLineColor('get');
                    sColor   = reshape(dec2hex([round(aColor(1)*255) round(aColor(2)*255) round(aColor(3)*255)], 2)',1, 6);
                    sNewLine = sprintf('<HTML><FONT color="%s" face="%s">%s', sColor, sFontName, sNewLine);                

                    asString{dValue} = sNewLine;

                   set(lbEditorMainWindowPtr('get'), 'String'    , asString); 
                   set(lbEditorMainWindowPtr('get'), 'ListboxTop', dListboxTop); 
                end

                set(btnEditorResetHeaderPtr('get'), 'enable', 'on');  
                
                editorProgressBar(1, 'Ready');      
                
            end            
            
        end             
               
    end         

    function cancelWriteCallback(~, ~)
        
        editorCancelWriteTag('set', true);
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

    function asLookupNames = getDicomLookupStructNames(aUnfolfddMeta, sFieldName)
        
        asLookupNames = '';
        dNbSub = 0;
        
        for jj=1: numel(aUnfolfddMeta)
            aSplit = strsplit(aUnfolfddMeta{jj},'.');
            
            if strcmpi(aSplit{end}, sFieldName)
                dNbSub = dNbSub+1;
                asLookupNames{dNbSub} = aUnfolfddMeta{jj};
            end                        
        end
        
    end

    function sStructName = extractStructElementName(aList, stMainWindow, dElementOffset)
        
        aItemOffset =[];
        sStructName =[];
        
        if isempty(aList)
            return;
        end
        
        if numel(aList) == 1
            sStructName = aList{1};
            return;
        else % Find Item           
            for jj=1:numel(aList)
                aItemOffset{jj} = [];
                aSplit = strsplit(aList{jj},'.');
                aItemRoot = aSplit(end-2);
                for kk=1:numel(stMainWindow)
                    if strfind(stMainWindow{kk}, aItemRoot)
                        if isempty(strfind(stMainWindow{kk}, '[')) && ... % Item has no value
                           isempty(strfind(stMainWindow{kk}, ']')) 
                            if dElementOffset > kk
                                aItemOffset{jj} = dElementOffset-kk; % Lowest elememt will be the item
                            end                        
                       end
                    end
                    
                end
            end            
        end
        
        dNbItemOffset = 0;
        
        dOffsetMin = min([aItemOffset{:}]);
        for tt=dElementOffset-dOffsetMin:dElementOffset
            if strfind(stMainWindow{tt}, 'Item')
                if isempty(strfind(stMainWindow{kk}, '[')) && ... % Item has no value               
                   isempty(strfind(stMainWindow{kk}, ']'))                  
                    dNbItemOffset = dNbItemOffset+1;
                end
            end
        end
        
        dOffsetCount = 0;
        for mm=1:numel(aList)
            if aItemOffset{mm} == dOffsetMin
                dOffsetCount = dOffsetCount+1;
                if dOffsetCount == dNbItemOffset
                    sStructName = aList{mm};
                    break;
                end
                
                
            end
            
        end
        
    end
       

end
