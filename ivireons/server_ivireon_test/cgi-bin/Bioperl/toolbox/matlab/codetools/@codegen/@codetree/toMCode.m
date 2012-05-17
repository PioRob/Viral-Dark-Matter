function toMCode(hCodeTree,hText,options,isFirst)
% Generates code based on input codetree object

% Copyright 2006-2009 The MathWorks, Inc.

if nargin == 2
    isFirst = false;
    options.MFileName = '';
    options.OutputTopNode = true;
end

local_generate_function_header(hCodeTree,hText,options,isFirst);
hCodeTree.CodeRoot.toMCode(hText);
hCodeTree.CodeRoot.subFunctionsToMCode(hText,options,false);

%---------------------------------------------------------------------%
function local_generate_function_header(hCodeTree,hText,options,isFirst)
% Generate first line of code in the following form:
% function [h] = create<ObjectName> (<property_name>_in, ...)

% If this is not the first, add a separator:
if ~isFirst
    hText.addln('');
    hText.addln('%-------------------------------------------------------------------------%');
end

hVarTable = hCodeTree.VariableTable;

% Determine m-file name
if ~isFirst || isempty(options.MFileName)
    function_name = hCodeTree.String;
else
    name = options.MFileName;
    function_name = name;
end

% Generate output variable
output_variable = [];
if (options.OutputTopNode)
    % Loop through argument list and find first argument that is flagged
    % as an output variable
    hVarList = get(hVarTable,'VariableList');
    for n = 1:length(hVarList)
        hVar = hVarList(n);
        if get(hVar,'IsOutputArgument')  
            output_variable = get(hVar,'String');
        end
    end
    setRemovalPermissions(hVar,false);
end

% Add function name 
if (options.OutputTopNode) && ~isempty(output_variable)
    str = ['function [',output_variable,'] = ',function_name]; 
else 
    str = ['function ',function_name];
end

hText.addln(str);

% Get the number of input arguments
% ToDo: this needs to be optimized for performance
hVarList = get(hVarTable,'VariableList');
count = 0;
inputInd = [];
for n = 1:length(hVarList)
    hVar = hVarList(n);
    % Only consider variables marked as parameters
    if get(hVar,'IsParameter') && ~get(hVar,'IsOutputArgument')
        count = count + 1;
        inputInd = [inputInd,n];
    end
end

% Get list of input argument objects
hInputVarList = hVarList(inputInd);

% Flags
is_first = true;

% Add function input arguments
for n = length(hVarList):-1:1
    hVar = hVarList(n);

    % Only show input arguments marked as parameters
    if get(hVar,'IsParameter') && ~get(hVar,'IsOutputArgument')
        str = get(hVar,'String');
        assert(~isempty(str),'MATLAB:codetools:codeargument:NoString','codeargument String property is empty')
        if is_first
            hText.add(sprintf('(%s',str));
            is_first = false;
        else
            tmp = sprintf(', %s',str);
            hText.add(tmp);
        end
    end
end

% Close out parenthesis for function input arguments
if count > 0
    hText.add(')');
end

% Standard H1 line
str = sprintf('%%%s',upper(function_name));
hText.addln(str);

% Add input variables to H1 line
len = length(hInputVarList);
for n = len:-1:1
    hVar = hInputVarList(n);
    if(n==len)
        hText.add('(');
    end
    str = get(hVar,'String');
    hText.add(upper(str));
    if (n==1)
        hText.add(')');
    else
        hText.add(',');
    end
end

% Create comments for each input argument
for n = length(hInputVarList):-1:1
    hVar = hInputVarList(n);
    comment = get(hVar,'Comment');
    str = get(hVar,'String');
    if ~isempty(comment) && ischar(comment)
        % Force variable description to use upper/lower case format
        % MYVARIABLE myvariable description
        hText.addln(['%  ',upper(str),':  ',lower(comment)]);
    else
        hText.addln(['%  ',upper(str)]);
    end
end

% If this is the first function in the file, add the internal comment.
if isFirst
    % Internal comment
    hText.addln(' ');
    currentDate = datestr(now);
    hText.addln(sprintf('%%  Auto-generated by MATLAB on %s', currentDate));
    hText.addln(' ');
end