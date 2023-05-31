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

    gbNewField = false;
    
    gsLineValue = '';

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

    gbPatientName = false;
    gdPNOffset = 0;
    
    if(numel(stMainWindow) > 1)
        if (numel(stMainWindow) > dElementOffset)

            sSelectedLine = ...
                stMainWindow{dElementOffset}; 

            stSelectedLine = ...
                strsplit(sSelectedLine);        

            if (numel(stSelectedLine) > 9)

                stGroupAndElement = ...
                    strsplit(stSelectedLine{3},{',','(',')'});

                if (numel(stGroupAndElement) > 3)
                    tDicomTag.sGroup   = stGroupAndElement{2};
                    tDicomTag.sElement = stGroupAndElement{3};
                    tDicomTag.sVR      = stSelectedLine{4}   ;  
                    
                    for sl=9:numel(stSelectedLine)

                        gsLineValue = sprintf('%s %s', gsLineValue, stSelectedLine{sl});
                        
                        if contains(gsLineValue, ']')
                            break;
                        end
                    end
                    
                    gsLineValue = erase(gsLineValue, '[');
                    gsLineValue = erase(gsLineValue, ']');
                    
                    gsLineValue = strtrim(gsLineValue);
                   
                    if strcmpi(tDicomTag.sVR, 'PN')
                        gbPatientName = true;
                        gdPNOffset = 100;
                    end
                end                               
            end

            
        end
    end

    dScreenSize  = get(groot, 'Screensize');
    dDlgPosition = get(dlgEditorWindowsPtr('get'),'position');

    xSize     = dScreenSize(3) * dDlgPosition(3); 
    xPosition = dScreenSize(3) * dDlgPosition(1) + ((xSize /2)-140);

    ySize     = dScreenSize(4) * dDlgPosition(4); 
    yPosition = dScreenSize(4) * dDlgPosition(2) + ((ySize /2)-(125+(gdPNOffset/2)));
    
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
                            225+gdPNOffset ...
                            ],...
              'Color', editorBackgroundColor('get'), ...
              'Name', 'Write Tag'...
               );        

     txtWriteGroup = ...
         uicontrol(dlgWrite,...
                   'style'   , 'text',...
                   'enable'  , 'on',...
                   'string'  , 'DICOM Group:',...
                   'horizontalalignment', 'left',...
                   'BackgroundColor', editorBackgroundColor('get'), ...
                   'ForegroundColor', editorForegroundColor('get'), ...                      
                   'position', [20 190+gdPNOffset 100 20]...
                   );        

    edtWriteGroup = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'off',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sGroup,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                   
                  'position'  , [150 190+gdPNOffset 100 20]...
                  );        

     txtWriteElement = ...
       uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'enable'  , 'on',...
                  'string'  , 'DICOM Element:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 165+gdPNOffset 100 20]...
                  );        

    edtWriteElement = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'off',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sElement,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position'  , [150 165+gdPNOffset 100 20]...
                  );                        

    txtWriteVR = ...
        uicontrol(dlgWrite,...
                  'style'   , 'text',...
                  'enable'  , 'on',...
                  'string'  , 'DICOM VR:',...
                  'horizontalalignment', 'left',...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position', [20 140+gdPNOffset 100 20]...
                  );        

    edtWriteVR = ...
        uicontrol(dlgWrite,...
                  'enable'    , 'off',...
                  'style'     , 'edit',...
                  'Background', 'white',...
                  'string'    , tDicomTag.sVR,...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'position'  , [150 140+gdPNOffset 100 20]...
                  );  
              
    if gbPatientName == true    
         
        txtFamilyNameValue = ...                  
             uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Family Name:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 190 100 20]...
                      );  

        edtFamilyNameValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , '',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [150 190 100 20]...
                      );  
                  
        txtGivenNameValue = ...                  
             uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Given Name:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 165 100 20]...
                      );  

        edtGivenNameValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , '',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [150 165 100 20]...
                      ); 
                  
        txtMiddleNameValue = ...                  
             uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Middle Name:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 140 100 20]...
                      );  

        edtMiddleNameValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , '',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [150 140 100 20]...
                      ); 
                  
        txtNamePrefixValue = ...                  
             uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Name Prefix:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 115 100 20]...
                      );  

        edtNamePrefixValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , '',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [150 115 100 20]...
                      ); 
                  
        txtNameSuffixValue = ...                  
             uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Name Suffix:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 90 100 20]...
                      );  

        edtNameSuffixValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , '',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [150 90 100 20]...
                      );                   
    else      
                            
            uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Value:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 90 60 20]...
                      );        

        edtWriteValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , gsLineValue,...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [80 90 170 20]...
                      );                       
    end
         
    btnNewFieldValue = ...
        uicontrol(dlgWrite,...
                  'String'  ,'New Tag',...
                  'Position',[20 50 125 20],...
                  'BackgroundColor', editorBackgroundColor('get'), ...
                  'ForegroundColor', editorForegroundColor('get'), ...                    
                  'Callback', @newFieldCallback...
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
        set(edtWriteGroup  , 'enable', 'off');
        set(edtWriteElement, 'enable', 'off');
        set(edtWriteVR     , 'enable', 'off');        
        set(btnNewFieldValue, 'enable', 'off');        
        if gbPatientName == true
            set(edtFamilyNameValue, 'Enable', 'off');
            set(edtGivenNameValue , 'Enable', 'off');
            set(edtMiddleNameValue, 'Enable', 'off');
            set(edtNamePrefixValue, 'Enable', 'off');
            set(edtNameSuffixValue, 'Enable', 'off');
        else
            set(edtWriteValue  , 'Enable', 'off');
        end

        tDicomTag.sGroup   = get(edtWriteGroup  , 'String');    
        tDicomTag.sElement = get(edtWriteElement, 'String');               
        tDicomTag.sVR      = get(edtWriteVR     , 'String');  
        if gbPatientName == true
            tDicomTag.sFamilyName = get(edtFamilyNameValue, 'String'); 
            tDicomTag.sGivenName  = get(edtGivenNameValue , 'String'); 
            tDicomTag.sMiddleName = get(edtMiddleNameValue, 'String'); 
            tDicomTag.sNamePrefix = get(edtNamePrefixValue, 'String'); 
            tDicomTag.sNameSuffix = get(edtNameSuffixValue, 'String'); 
        else
            tDicomTag.sValue   = get(edtWriteValue  , 'String'); 
        end
                       
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
        
        try
            
        set(dlgWrite, 'Pointer', 'watch');
        set(dlgEditorWindowsPtr('get'), 'Pointer', 'watch');
        drawnow;  
        
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
                
                if mod(dd,5)==1 || dd == aNbFiles(1)         
                    editorProgressBar(dd/aNbFiles(1), sprintf('Updating Header %d/%d, please wait', dd, aNbFiles(1)));
                end

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
                if gbNewField == true
                    
                    sFieldName = dicomlookup(tDicomTag.sGroup,tDicomTag.sElement);
                    tMetaData.(sFieldName) = castVrValue(tDicomTag.sVR, tDicomTag.sValue);
                    
                    atMetaData{ee} = tMetaData;
                else
                    if gbPatientName == true
                        sFieldName = dicomlookup(tDicomTag.sGroup, tDicomTag.sElement);

                        tMetaData.(sFieldName).FamilyName = tDicomTag.sFamilyName;
                        tMetaData.(sFieldName).GivenName  = tDicomTag.sGivenName;
                        tMetaData.(sFieldName).MiddleName = tDicomTag.sMiddleName;
                        tMetaData.(sFieldName).NamePrefix = tDicomTag.sNamePrefix;
                        tMetaData.(sFieldName).NameSuffix = tDicomTag.sNameSuffix;  

                        atMetaData{ee} = tMetaData;

                    else
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
%                                if numel(sFieldName) > 64
                                    editorWriteMetaData('set', '');
                                    newValue = castVrValue(tDicomTag.sVR ,tDicomTag.sValue);
                                    sStruct = sprintf('tMetaData.%s', sFieldName);

                                    editorWriteUnfold(sStruct, newValue, tMetaData);
                                    tWriteMetaData = editorWriteMetaData('get');
                                    sNewField = erase(sStruct, ['.' dicomlookup(tDicomTag.sGroup, tDicomTag.sElement)]);
                                    eval([sNewField ' = tWriteMetaData']);

%                                else
%                                    tMetaData.(sFieldName) = castVrValue(tDicomTag.sVR ,tDicomTag.sValue);
%                                end
                            catch
                                editorProgressBar(1, sprintf('Error:, cant write the field %s', dicomlookup(tDicomTag.sGroup, tDicomTag.sElement)) );  
                                dError = true;                      
                            end

                            atMetaData{ee} = tMetaData;
                        end
                    end
                end
            end

            if dError == false
                                
                editorDicomMetaData('set', atMetaData);

                asString    = get(lbEditorMainWindowPtr('get'), 'String');
                dValue      = get(lbEditorMainWindowPtr('get'), 'Value');     
                dListboxTop = get(lbEditorMainWindowPtr('get'), 'ListboxTop');  

                if numel(asString) 
                    
                    if gbNewField == true
                        
                    else                    
                        sLine = asString{dValue};
                        if gbPatientName == true
                            sValue = sprintf('%s^%s^%s^%s^%s', ...
                                tDicomTag.sFamilyName, ...
                                tDicomTag.sGivenName , ...
                                tDicomTag.sMiddleName, ...
                                tDicomTag.sNamePrefix, ...
                                tDicomTag.sNameSuffix); 

                        else
                            sValue = tDicomTag.sValue;
                        end                    
                        sNewLine = replaceBetween(sLine,'[',']', sValue);

                        sNewLine = strrep(sNewLine, ' ', '&nbsp;');   

                        sFontName = get(lbEditorMainWindowPtr('get'), 'FontName');
                        aColor   = editorWriteTagLineColor('get');
                        sColor   = reshape(dec2hex([round(aColor(1)*255) round(aColor(2)*255) round(aColor(3)*255)], 2)',1, 6);
                        sNewLine = sprintf('<HTML><FONT color="%s" face="%s">%s', sColor, sFontName, sNewLine);                

                        asString{dValue} = sNewLine;

                       set(lbEditorMainWindowPtr('get'), 'String'    , asString); 
                       set(lbEditorMainWindowPtr('get'), 'ListboxTop', dListboxTop); 
                   end
                end

                set(btnEditorResetHeaderPtr('get'), 'enable', 'on');  
                
                editorProgressBar(1, 'Ready');      
                
            end            
            
        end   
        
        catch
            editorProgressBar(1, 'Error: editorWriteTagCallbak()');            
        end
        
        set(dlgEditorWindowsPtr('get'), 'Pointer', 'default');
        drawnow;  
        
                             
    end         

    function newFieldCallback(~, ~)
        
        set(edtWriteGroup  , 'enable', 'on');
        set(edtWriteElement, 'enable', 'on');
        set(edtWriteVR     , 'enable', 'on'); 
        
        set(edtWriteGroup  , 'String', '');
        set(edtWriteElement, 'String', '');
        set(edtWriteVR     , 'String', '');         
        
        gbNewField = true;
        
        if gbPatientName == true  
            
            gbPatientName = false;
            gdPNOffset = 0;    
            
            delete(txtFamilyNameValue);                  
            delete(edtFamilyNameValue);
            delete(txtGivenNameValue );      
            delete(edtGivenNameValue );                
            delete(txtMiddleNameValue);                  
            delete(edtMiddleNameValue);                  
            delete(txtNamePrefixValue);                   
            delete(edtNamePrefixValue);                   
            delete(txtNameSuffixValue);                 
            delete(edtNameSuffixValue);
            
            set(dlgWrite, ...
                'Position', [xPosition ...
                            yPosition ...
                            280 ...
                            225+gdPNOffset ...
                            ]...
                );        

            set(txtWriteGroup, ...                   
                'position', [20 190+gdPNOffset 100 20]...
                );        

            set(edtWriteGroup, ...               
                'position'  , [150 190+gdPNOffset 100 20]...
                );        

            set(txtWriteElement, ...                  
                'position', [20 165+gdPNOffset 100 20]...
                );        

            set(edtWriteElement, ...                  
                'position'  , [150 165+gdPNOffset 100 20]...
                );                        

            set(txtWriteVR, ...                  
                'position', [20 140+gdPNOffset 100 20]...
                );        

            set(edtWriteVR, ...                 
                'position'  , [150 140+gdPNOffset 100 20]...
                );        
            
            uicontrol(dlgWrite,...
                      'style'   , 'text',...
                      'string'  , 'Value:',...
                      'horizontalalignment', 'left',...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position', [20 90 60 20]...
                      );        

        edtWriteValue = ...
            uicontrol(dlgWrite,...
                      'enable'    , 'on',...
                      'style'     , 'edit',...
                      'Background', 'white',...
                      'string'    , gsLineValue,...
                      'BackgroundColor', editorBackgroundColor('get'), ...
                      'ForegroundColor', editorForegroundColor('get'), ...                    
                      'position'  , [80 90 170 20]...
                      );                        
        end
        
        set(edtWriteValue     , 'String', '');

    end

    function cancelWriteCallback(~, ~)
        
        editorCancelWriteTag('set', true);
        delete(dlgWrite);                     
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

        sStructName =[];
        
        if isempty(aList)
            return;
        end
        
        if numel(aList) == 1
            sStructName = aList{1};
            return;
        else % Find Item           
            aItem = [];

            dRootItemOffset = 0;
            dNbTag = 0;
         
            jj = dElementOffset;
            
            while jj >= 1
                
                if strfind(stMainWindow{jj}, 'Item')
                    aSplit = strsplit(stMainWindow{jj-1},' ');
                    sItemRoot = aSplit(end-1);
                    for ll=1:numel(aList)
                        if strfind(aList{ll}, sItemRoot)
                            dNbTag=dNbTag+1;
                            aItem{dNbTag} = aList{ll}; % Lowest elememt will be the item
                            if dRootItemOffset == 0
                                dRootItemOffset = jj-1;
                            end

                        end
                    end
                    if dNbTag ~= 0
                        break;
                    end
                end

                jj = jj - 1;

            end

            if dNbTag == 1
                sStructName = aItem{1};
            elseif dNbTag > 1
                aItem = [];
                jj = dRootItemOffset;
                while jj >= 1
                    
                    % Decrement jj
                    if strfind(stMainWindow{jj}, 'Item')
                        aSplit = strsplit(stMainWindow{jj-1},' ');
                        sItemRoot = aSplit(end-1);
                        for ll=1:numel(aList)
                            if strfind(aList{ll}, sItemRoot)
                                dNbTag=dNbTag+1;
                                aItem{dNbTag} = aList{ll}; % Lowest elememt will be the item
                                if dRootItemOffset == 0
                                    dRootItemOffset = jj-1;

                                end
    
                            end
                        end
                        if dNbTag ~= 0
                            break;
                        end
                    end
    
                    jj = jj - 1;
    
                end

                if dNbTag == 1
                    sStructName = aItem{1};
                end
            else
                sStructName = [];
            end
        end

    end
       
    function value = castVrValue(sVR, sValue)    
        
        switch lower(sVR)
            case 'fd'
                value = cast(str2double(sValue),'double');

            case 'fl'
                value = cast(str2double(sValue),'single');

            case 'us'
                value = cast(str2double(sValue),'uint16');

            case 'ul'
                value = cast(str2double(sValue),'uint32');

            case 'ss'
                value = cast(str2double(sValue),'int16');

            case 'sl'
                value = cast(str2double(sValue),'int32');

            case {'ds','is'}
                value = cast(str2double(sValue),'double');

            case {'ae','as','cs','da','dt','lo','lt','od',...
                    'of','ow','pn','sh','st','tm','ui','ut'}
                value = sValue;
                
            otherwise
                value = '';
        end
    end                
end
