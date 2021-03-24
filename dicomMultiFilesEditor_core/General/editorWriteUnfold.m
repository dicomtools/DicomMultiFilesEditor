function editorWriteUnfold(sFieldName, value, SC, varargin)
%editorUnfold Unfolds a structure.
%   editorUnfold(SC) displays the content of a variable. If SC is a structure it
%   recursively shows the name of SC and the fieldnames of SC and their
%   contents. If SC is a cell arraythe contents of each cell are displayed.
%   It uses the caller's workspace variable name as the name of SC. 
%   editorUnfold(SC,NAME) uses NAME as the name of SC.
%   editorUnfold(SC,SHOW) If SHOW is false only the fieldnames and their sizes
%   are  shown, if SHOW is true the contents are shown also.
%   editorUnfold(SC,NAME,SHOW)

%R.F. Tap
%15-6-2005, 7-12-2005, 5-1-2006, 3-4-2006

% check input
switch nargin
    case 3
        Name = inputname(3);
        show = true;
    case 4
        if islogical(varargin{1})
            Name = inputname(3);
            show = varargin{1};
        elseif ischar(varargin{1})
            Name = varargin{1};
            show = true;
        else
            error('Second input argument must be a string or a logical')
        end
    case 5
        if ischar(varargin{1})
            if islogical(varargin{2})
                Name = varargin{1};
                show = varargin{2};
            else
                error('Third input argument must be a logical')
            end
        else
            error('Second input argument must be a string')
        end
    otherwise
        error('Invalid number of input arguments')
end


if isstruct(SC)
    %number of elements to be displayed
    NS = numel(SC);
    if show
        hmax = NS;
    else
        hmax = min(1,NS);
    end

    %recursively display structure including fieldnames
    for h=1:hmax
        F = fieldnames(SC(h));
        NF = length(F);
        for i=1:NF
            if NS>1
                siz = size(SC);
                if show
                    Namei = [Name '(' ind2str(siz,h) ').' F{i}];
                else
                    Namei = [Name '(' ind2str(siz,NS) ').'  F{i}];
                end
            else
                Namei = [Name '.' F{i}];
            end
            if isstruct(SC(h).(F{i}))
                editorWriteUnfold(sFieldName, value, SC(h).(F{i}),Namei,show);
            else
      %          disp(Namei)   
                if strcmpi(sFieldName, Namei)
                    SC(h).(F{i}) = value; 
                    editorWriteMetaData('set', SC);
                end
                
       %         if show
       %             disp(SC(h).(F{i}))                    
       %         end                
            end
        end
    end
else
    disp(Name)
%    if show
%        disp(SC)
%    end
end


%local functions
%--------------------------------------------------------------------------
function str = ind2str(siz,ndx)

n = length(siz);
%treat vectors and scalars correctly
if n==2
    if siz(1)==1
        siz = siz(2);
        n = 1;
    elseif siz(2)==1
        siz = siz(1);
        n = 1;
    end
end
k = [1 cumprod(siz(1:end-1))];
ndx = ndx - 1;
str = '';
for i = n:-1:1,
    v = floor(ndx/k(i))+1;
    if i==n
        str = num2str(v);
    else
        str = [num2str(v) ',' str];
    end
    ndx = rem(ndx,k(i));
end

