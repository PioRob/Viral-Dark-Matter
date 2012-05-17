function varargout = methods(obj, varargin)
%METHODS Display class method names.
%
%   METHODS CLASSNAME displays the names of the methods for the
%   class with the name CLASSNAME.
% 
%   METHODS(OBJECT) displays the names of the methods for the
%   class of OBJECT.
% 
%   M = METHODS('CLASSNAME') returns the methods in a cell array of
%   strings.
% 
%   METHODS differs from WHAT in that the methods from all method
%   directories are reported together, and METHODS removes all
%   duplicate method names from the result list. METHODS will also
%   return the methods for a Java class.
% 
%   METHODS CLASSNAME -full  displays a full description of the
%   methods in the class, including inheritance information and,
%   for Java methods, also attributes and signatures.  Duplicate
%   method names with different signatures are not removed.
%   If class_name represents a MATLAB class, then inheritance 
%   information is returned only if that class has been instantiated. 
% 
%   M = METHODS('CLASSNAME', '-full') returns the full method
%   descriptions in a cell array of strings.
%    
%   See also METHODSVIEW, WHAT, WHICH, HELP.
%

%   MP 10-14-02
%   Copyright 1999-2008 The MathWorks, Inc. 
%   $Revision: 1.1.6.3 $  $Date: 2008/05/19 23:18:20 $

% Error checking.
if (nargout > 1)
    error('serial:methods:maxlhs', 'Too many output arguments.');
end

if (nargin > 2)
    error('serial:methods:invalidSyntax', 'Invalid syntax. Type ''help methods'' for more information.');
end

if ~isvalid(obj)
    error('serial:methods:invalidObj', 'OBJECT must be a valid instrument object.');
end

if length(obj) > 1
    error('serial:methods:invalidLength', 'OBJECT must be a 1-by-1 instrument object.');
end

if (nargin == 2)
    if ~strcmp(varargin{1}, '-full')
        error('serial:methods:invalidArg', ['Invalid second argument. The only valid second argument is ''-full''.',...
            sprintf('\n') 'Type ''help methods'' for more information.']);
    end
end

% Get the methods provided by the instrument object.
objMethodNames = builtin('methods', obj);
icMethodNames = builtin('methods', 'icinterface');
instrumentMethodNames = builtin('methods', 'instrument');
methodNames = {objMethodNames{:} icMethodNames{:} instrumentMethodNames{:}};
methodNames = unique(sort(methodNames));
methodNames = localCleanupMethodNames(methodNames);

switch nargout
case 0
    switch nargin
    case 1
		% Calculate the maximum base method name.
		maxLength = max(cellfun('length', methodNames));
        
		% Print out the method names.
		localPrettyPrint(methodNames, maxLength, ['Methods for class ' class(obj) ':']);
        
        fprintf('\n\n');
    case 2
        builtin('methods', obj, '-full');
    end
case 1
    varargout{1} = methodNames;        
end

% ----------------------------------------------------------------
% Pretty print the methods.
function localPrettyPrint(methodNames, maxMethodLength, heading)

% Calculate spacing information.
maxColumns = floor(80/maxMethodLength);
maxSpacing = 2;
numOfRows = ceil(length(methodNames)/maxColumns);

% Reshape the methods into a numOfRows-by-maxColumns matrix.
numToPad = (maxColumns * numOfRows) - length(methodNames);
for i = 1:numToPad
    methodNames = {methodNames{:} ' '};
end
methodNames = reshape(methodNames, numOfRows, maxColumns);

% Print out the methods.
fprintf(['\n' heading '\n\n']);

% Loop through the methods and print them out.
for i = 1:numOfRows
    out = '';
    for j = 1:maxColumns
        m = methodNames{i,j};
        out = [out sprintf([m blanks(maxMethodLength + maxSpacing - length(m))])]; %#ok<AGROW>
    end    
    fprintf([out '\n']);
end

% ----------------------------------------------------------------
function methodNames = localCleanupMethodNames(methodNames)

% Remove loadobj and saveobj.
names =  {'loadobj', 'saveobj'};

for i=1:length(names)
    index = strmatch(names{i}, methodNames, 'exact');
    methodNames(index) = [];
end