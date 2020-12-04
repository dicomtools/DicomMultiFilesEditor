function [Results,child_struct]=StructSearch(input_struct,search_term)
    %Input arguments parent struct and search string 
    % returns  fields and child struct with matching parameter
    %Praveen :Praveen.ivp@gmail.com

    %Error checking
    if(~isstruct(input_struct))
        error('Only accepts structs/class obj');
        return;
    end
    if nargin==1
        warning('No search term! function will return all fields'); 
        search_term='';
    end
    if ~ischar(search_term)
        error('Accepts only string as second argument');
        return;
    end

    %intialization
    child_struct=struct;
    L0='input_struct';
    L1=string(fieldnames(input_struct));
    col1=L1;
    col2=strcat(L0,'.',L1);
    next_level=['X']; %for do while
    curr_level=col2;

    %get all  fields(col1) and its fullpath(col2)
    while(~(isempty(next_level)))
        next_level=[];
        for i=1:length(curr_level)
            if(isstruct(eval(curr_level(i)))||isobject(eval(curr_level(i)))) 
                temp=string(fieldnames(eval(curr_level(i))));
                col1=[col1;temp ];
                col2=[col2;strcat(curr_level(i),'.',temp)];
                next_level=[next_level;strcat(curr_level(i),'.',temp)];
            end
        end
        curr_level=next_level;

    end

    %Get matching parameter list idx
    Matching_List=contains(col1,search_term,'IgnoreCase',true);
    %return a struct with the matching fields
    s=(col2(Matching_List));
    for i=1:length(s)
        try
        eval(strcat(strrep(s(i),L0,'child_struct'),' = ',s(i),';'));
        catch
            fprintf('The Outputted struct may not have all fields');
        end
    end



    %class(col3) and details(col4) of the matching parameters
    col3=[];
    col4=[];
    for i=1:length((s))
        col3=[col3; string(class(eval((s(i)))))];
        try
           col4=[col4; DispStructRoughly(eval(s(i)))];
        catch
            col4=[col4; "Error"];
        end
    end

    %concatnate and replace the local struct name with the passed struct name 
    Results=[col1(Matching_List) strrep(col2(Matching_List),L0,inputname(1)) col3 col4]; 

    fprintf('Found %d mathing parameters\n',length(s));
    fprintf(evalc('disp(Results)'));
    end


    %Function to get a small description of a variable for col4 of results 
    function c = DispStructRoughly(s)
    if(isnumeric(s))
        if(isempty(s))
            c="[]";
        elseif(numel(s)<5)
            c=mat2str(s);
        else
            c=mat2str(size(s));
        end
    elseif(ischar(s))
        if(numel(s)<25)
            c=string(s);
        else
            c=string(s(1:25));
        end
    elseif(iscell(s)&&numel(s)==1)
        c=string(s);
    else
        c=string(class(s));
    end
    if(size(c,1)>2)
        c='Error';
    end
end
