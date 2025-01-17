function [b,ia] = stack(a,dataVars,varargin)
%STACK Stack up data from multiple variables into a single variable
%   TALL = STACK(WIDE,DATAVARS) converts a dataset array WIDE to an equivalent
%   dataset array TALL that is in "tall format", by "stacking up" multiple
%   variables in WIDE into a single variable in TALL.  In general, TALL
%   contains fewer variables, but more observations, than WIDE.
%
%   DATAVARS specifies a group of M data variables in WIDE.  STACK creates a
%   single data variable in TALL by interleaving their values, and if WIDE has
%   N observations, then TALL has M*N observations.  In other words, STACK
%   takes the M data values from each observation in WIDE and stacks them up
%   to create M observations in TALL.  DATAVARS is a positive integer, a
%   vector of positive integers, a variable name, a cell array containing one
%   or more variable names, or a logical vector.  STACK also creates a new
%   variable in TALL to indicate which of the M data variables in WIDE each
%   observation in TALL corresponds to.
%
%   Stack assigns values for the "per-variable properties (e.g., Units and
%   VarDescription) for the new data variable in TALL from the corresponding
%   property values for the first variable listed in DATAVARS.
%
%   STACK copies the remaining variables from WIDE to TALL without stacking,
%   by replicating each of their values M times.  These are typically grouping
%   variables, and since their values are constant across each group of M
%   observations in TALL, they serve to identify which observation in WIDE an
%   observation in TALL came from.
%
%   Type "help groupingvariable" for more information about grouping
%   variables.
%
%   [TALL,IWIDE] = STACK(WIDE,DATAVARS) returns an index vector IWIDE
%   indicating the correspondence between observations in TALL and those in
%   WIDE.  STACK creates the "tall" observations TALL(IWIDE==I,:) using the
%   "wide" observation WIDE(I,:).  In other words, STACK creates TALL(J,:)
%   using WIDE(IWIDE(J),DATAVARS).
%
%   Use the following parameter name/value pairs to control how variables in
%   WIDE are converted to variables in TALL:
%
%      'ConstVars'        Variables in WIDE to be copied to TALL without
%                         stacking.  CONSTVARS is a positive integer, a vector
%                         of positive integers, a variable name, a cell array
%                         containing one or more variable names, or a logical
%                         vector.  The default is all variables in WIDE not
%                         specified in DATAVARS.
%      'NewDataVarName'   A name for the data variable to be created in TALL.
%                         The default is a concatenation of the names of the M
%                         variables that are stacked up.
%      'IndVarName'       A name for the new variable to be created in TALL
%                         that indicates the source of each value in the new
%                         data variable.  The default is based on the
%                         'NewDataVarName' parameter.
%
%   You can also specify more than one group of data variables in WIDE, each
%   of which will become a variable in TALL.  All groups must contain the same
%   number of variables.  Use a cell array to contain multiple parameter
%   values for DATAVARS, and a cell array of strings to contain multiple
%   'NewDataVarName'.
%
%   Example: convert a "wide format" data set to "tall format", and then back
%   to a different "wide format".
%
%      load flu
%
%      % FLU has a 'Date' variable, and 10 variables for estimated influenza
%      % rates (in 9 different regions, estimated from Google searches, plus a
%      % nationwide extimate from the CDC).  Combine those 10 variables into a
%      % "tall" array that has a single data variable, 'FluRate', and an indicator
%      % variable, 'Region', that says which region each estimate is from.
%      [flu2,iflu] = stack(flu, 2:11, 'NewDataVarName','FluRate', 'IndVarName','Region')
%
%      % The second observation in FLU is for 10/16/2005.  Find the observations
%      % in FLU2 that correspond to that date.
%      flu(2,:)
%      flu2(iflu==2,:)
%
%      % Use the 'Date' variable from that tall array to split 'FluRate' into 52
%      % separate variables, each containing the estimated influenza rates for
%      % each unique date.  The new "wide" array has one observation for each
%      % region.  In effect, this is the original array FLU "on its side".
%      dateNames = cellstr(datestr(flu.Date,'mmm_DD_YYYY'));
%      [flu3,iflu2] = unstack(flu2, 'FluRate', 'Date', 'NewDataVarNames',dateNames)
%
%      % Since observations in FLU3 represent regions, IFLU2 indicates the first
%      % occurrence in FLU2 of each region.
%      flu2(iflu2,:)
%
%   See also DATASET/UNSTACK, GROUPINGVARIABLE, GRPSTATS, DATASET/JOIN.

%   Copyright 2009-2010 The MathWorks, Inc. 
%   $Revision: 1.1.6.6 $  $Date: 2010/05/10 17:38:16 $

% Since [] is a valid value for constvars, cannot use it as a default to
% detect whether the arg was passed in or not.  For now, do this.
pnames = {'constvars' 'newdatavarnames' 'indvarname'}; % accepts NewDataVarName or NewDataVarNames
dflts =  {       -99                []           [] };

[eid,errmsg,constVars,tallVarNames,indicatorName] ...
    = dataset.getargs(pnames,dflts,varargin{:});
if ~isempty(eid)
    error(sprintf('stats:dataset:stack:%s',eid),errmsg);
end

% Convert dataVars or dataVars{:} to indices.  [] is valid, and does not
% indicate "default".
if isempty(dataVars)
    dataVars = {[]}; % guarantee a zero length list in a non-empty cell
elseif iscell(dataVars) && ~iscellstr(dataVars)
    for i = 1:length(dataVars)
        dataVars{i} = getvarindices(a,dataVars{i}); % each cell containing a row vector
    end
else
    dataVars = { getvarindices(a,dataVars) }; % a cell containing a row vector
end
allDataVars = cell2mat(dataVars);
nTallVars = length(dataVars);

% Reconcile constVars and dataVars.  The two must have no variables in common.
% If only dataVars is provided, constVars defaults to "everything else".
if isequal(constVars,-99) % no value passed in
    constVars = setdiff(1:size(a,2),allDataVars);
else
    % Convert constVars to indices.  [] is valid, and does not indicate "default".
    constVars = getvarindices(a,constVars); % a row vector
    if ~isempty(intersect(constVars,allDataVars))
        error('stats:dataset:stack:ConflictingConstAndDataVars','CONSTVARS and DATAVARS must not have variables in common.');
    end
end

% Make sure all the sets of variables are the same width.
m = unique(cellfun(@numel,dataVars));
if ~isscalar(m)
    error('stats:dataset:stack:UnequalSizeDataVarsSets','All sets of variables in DATAVARS must be the same size.');
end

% Replicate rows for each of the constant variables.  This carries over
% properties of the wide dataset
n = size(a,1);
ia = repmat(1:n,max(m,1),1); ia = ia(:);
b = subsref(a,struct('type',{'()'},'subs',{{ia constVars}})); % a(ia,constVars);

aNames = a.varnames;

if m > 0
    % Add the indicator variable
    vars = dataVars{1}(:);
    % Unique the data vars for the indicator levels.  This will create the indicator
    % variable with levels ordered by var location in the original dataset.
    uvars = unique(vars);
    indicator = nominal(repmat(vars,n,1),aNames(uvars),uvars);
    b.nvars = b.nvars + 1;
    b.data{b.nvars} = indicator;
    b.varnames{b.nvars} = ''; % fill this in later
    indicatorVar = b.nvars;
    
    % Preallocate room in the data array
    b.nvars = b.nvars + nTallVars;
    b.data{b.nvars} = [];
    
    % For each group of wide variables to reshape ...
    for i = 1:nTallVars
        vars = dataVars{i}(:);

        % Interleave the group of wide variables into a single tall variable
        if ~isempty(vars)
            szOut = size(a.data{vars(1)}); szOut(1) = b.nobs;
            tallVar = a.data{vars(1)}(ia,:);
            for j = 2:m
                interleaveIdx = j:m:m*n;
                try
                    tallVar(interleaveIdx,:) = a.data{vars(j)}(:,:);
                catch ME
                    throw(addCause(MException('stats:dataset:stack:InterleavingDataVarsFailed', ...
                          'Error when stacking data variable ''%s''.', a.varnames{vars(j)}), ME));
                end
            end
            b.data{indicatorVar+i} = reshape(tallVar,szOut);
        end
    end
    
    % Generate default names for the tall data vars if needed, making sure
    % they don't conflict with existing names.  If names were given, duplicate
    % names are an error.
    if isempty(tallVarNames)
        % These will always be valid, no need to call genvalidnames
        tallVarNames = cellfun(@(c)strcollapse(aNames(c),'_'),dataVars,'UniformOutput',false);
        uniqueNames = genuniquenames([b.varnames tallVarNames(:)'],indicatorVar+1);
        tallVarNames = uniqueNames((indicatorVar+1):b.nvars);
    end
    try
        b = setvarnames(b,tallVarNames,(indicatorVar+1):b.nvars,false); % error if invalid
    catch me
        if isequal(me.identifier,'stats:dataset:setvarnames:DuplicateVarnames') ...
                && length(unique(tallVarNames)) == length(tallVarNames)
            % Give a more detailed err msg than the one from setvarnames
            error('stats:dataset:stack:ConflictingNewDataVarName','Variable names in NEWDATAVARNAME conflict with variables in CONSTVARS or with INDVARNAME.');
        else
            rethrow(me);
        end
    end
    
    % Now that the data var names are OK, we can generate a default name for
    % the indicator var if needed, making sure it doesn't conflict with
    % existing names.  If a name was given, a duplicate name is an error.
    if isempty(indicatorName);
        % This will always be valid, no need to call genvalidnames
        indicatorName = [b.varnames{indicatorVar+1} '_Indicator'];
        uniqueNames = genuniquenames([b.varnames indicatorName],b.nvars);
        indicatorName = uniqueNames{end};
    end
    try
        b = setvarnames(b,indicatorName,indicatorVar,false); % error if invalid
    catch me
        if isequal(me.identifier,'stats:dataset:setvarnames:DuplicateVarnames')
            % Give a more detailed err msg than the one from setvarnames
            error('stats:dataset:stack:ConflictingDataIndVarName','INDVARNAME conflicts with variables in CONSTVARS.');
        else
            rethrow(me);
        end
    end
    
end

% Copy units and variable descriptions from the first data var in each group
if m > 0
    firstDataVars = cellfun(@(x) x(1),dataVars);
    varPropsIndices = [constVars indicatorVar firstDataVars];
else
    varPropsIndices = constVars;
end
if ~isempty(a.props.Units)
    b.props.Units = a.props.Units(varPropsIndices);
    b.props.Units{indicatorVar} = '';
end
if ~isempty(a.props.VarDescription)
    b.props.VarDescription = a.props.VarDescription(varPropsIndices);
    b.props.VarDescription{indicatorVar} = 'Data indicator';
end


%-----------------------------------------------------------------------
function t = strcollapse(s,sep)
%STRCOLLAPSE Concatenate strings into a single string.
%   T = STRCOLLAPSE(S) concatenates all the strings in S into a single string.
%   S is either a character array, where each row is a string, or a cell array
%   of strings.  T is a character row vector.
%
%   T = STRCOLLAPSE(S,SEP) concatenates the strings in S into a single string,
%   separated by the string SEP.
%
%   STRCOLLAPSE ignores trailing ASCII white space characters and omits all 
%   such characters from the output.  White space characters in ASCII are 
%   space, newline, carriage return, tab, vertical tab, or form-feed 
%   characters, all of which return a TRUE response from the MATLAB ISSPACE
%   function.
%
%   Example
%       strcat({'Red','Yellow','Green','Blue'})
%   returns
%       'RedGreenYellowBlue'
%
%   See also STRCAT, CELLSTR.

%   Copyright 2009 The MathWorks, Inc.

if ischar(s), s = cellstr(s); end

if nargin > 1
    if ~isstring(sep)
        error('MATLAB:strcollapse:InvalidSeperator','SEP must be a string.');
    end
    s = [s(:)'; repmat({sep},1,numel(s))];
    if ~isempty(s), s{end} = ''; end
end
if isempty(s)
    t = '';
else
    t = strcat(s{:});
end


%-----------------------------------------------------------------------
function tf = isstring(s) % require a row of chars, or possibly ''
%   T = ISSTRING(S) returns true if S is a 1-by-M character vector, where M
%   can be zero, or if S is the empty string ''.  ISSTRING returns false
%   otherwise.
%   
%   See also STRINGS.

%   Copyright 2009 The MathWorks, Inc.

tf = ischar(s) && ( (isvector(s) && (size(s,1) == 1)) || all(size(s)==0) );
